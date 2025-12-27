#include "Game.h"
#include "Ball.h"
#include "Paddle.h"
#include <SDL3/SDL_main.h>    // SDL3 requires including SDL_main separately
#include <iostream>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <vector>
#include <string>

// Helper function to find a font on macOS
static TTF_Font* OpenFirstFontThatExists(int px) {
    // Practical macOS-first list + project-local fallback
    std::vector<std::string> candidates = {
        "/System/Library/Fonts/SFNS.ttf",
        "/System/Library/Fonts/Supplemental/Arial.ttf",
        "/System/Library/Fonts/Supplemental/Verdana.ttf",
        "/Library/Fonts/Arial.ttf",
        "./assets/Roboto-Regular.ttf",
        "arial.ttf"
    };

    for (const auto& path : candidates) {
        TTF_Font* f = TTF_OpenFont(path.c_str(), (float)px);
        if (f) {
            std::fprintf(stderr, "Using font: %s\n", path.c_str());
            return f;
        }
    }
    return nullptr;
}

Game::Game(int w, int h)
    : window(nullptr), renderer(nullptr),
      windowWidth(w), windowHeight(h),
      ball(new Ball()), paddleLeft(new Paddle()), paddleRight(new Paddle()),
      scoreLeft(0), scoreRight(0), difficulty(Difficulty::Medium),
      font(nullptr), scoreTexture(nullptr), scoreTexW(0), scoreTexH(0)
{
    // Initialize ball size
    ball->rect.w = ball->rect.h = 16.0f; // 16x16 px ball
    ball->vx = 0.0f;
    ball->vy = 0.0f;

    // Initialize paddle sizes
    paddleLeft->rect.w = paddleRight->rect.w = 18.0f;
    paddleLeft->rect.h = paddleRight->rect.h = 120.0f;
    // Positions will be set in Init/Reset
}

Game::~Game() {
    // Clean up dynamically allocated objects
    delete ball;
    delete paddleLeft;
    delete paddleRight;

    // Destroy SDL objects
    if (scoreTexture) SDL_DestroyTexture(scoreTexture);
    if (font) TTF_CloseFont(font);
    if (renderer) SDL_DestroyRenderer(renderer);
    if (window) SDL_DestroyWindow(window);
    TTF_Quit();
    SDL_Quit();
}

bool Game::Init() {
    if (!SDL_Init(SDL_INIT_VIDEO)) { // returns false on failure in SDL3
        std::cerr << "SDL_Init failed: " << SDL_GetError() << std::endl;
        return false;
    }

    if (!TTF_Init()) { // returns false on failure
        std::cerr << "TTF_Init failed: " << SDL_GetError() << std::endl;
        return false;
    }

    // Create window
    window = SDL_CreateWindow("SDL3 Pong Clone", windowWidth, windowHeight, 0);
    if (!window) {
        std::cerr << "SDL_CreateWindow Error: " << SDL_GetError() << std::endl;
        return false;
    }

    // Create renderer with vsync
    renderer = SDL_CreateRenderer(window, nullptr);
    if (!renderer) {
        std::cerr << "SDL_CreateRenderer Error: " << SDL_GetError() << std::endl;
        return false;
    }

    // Initialize paddles positions and speeds
    int w, h;
    SDL_GetWindowSizeInPixels(window, &w, &h);
    windowWidth = w;
    windowHeight = h;

    paddleLeft->rect.x = 60.0f;
    paddleLeft->rect.y = (h - paddleLeft->rect.h) / 2.0f; // center vertically
    paddleRight->rect.x = w - paddleRight->rect.w - 60.0f;
    paddleRight->rect.y = (h - paddleRight->rect.h) / 2.0f;

    // Base paddle speed (will be adjusted by difficulty)
    paddleLeft->speed = 720.0f;
    paddleRight->speed = 640.0f;

    // Initial difficulty
    SetDifficulty(difficulty);

    // Load font
    font = OpenFirstFontThatExists(48);
    if (!font) {
        std::cerr << "WARNING: No font found. Score will not render.\n"
                  << "Add a font at ./assets/Roboto-Regular.ttf or adjust the font paths.\n";
    }

    // Create initial score texture
    UpdateScoreTexture();

    // Seed random generator for ball direction
    std::srand(static_cast<unsigned>(time(nullptr)));

    // Place ball at center with initial velocity
    ResetBall();

    return true;
}

void Game::SetDifficulty(Difficulty level) {
    difficulty = level;
    // Adjust AI paddle speed and behavior based on difficulty
    switch (difficulty) {
        case Difficulty::Easy:
            paddleRight->speed = 400.0f;
            break;
        case Difficulty::Medium:
            paddleRight->speed = 640.0f;
            break;
        case Difficulty::Hard:
            paddleRight->speed = 900.0f;
            break;
    }
}

void Game::ResetBall() {
    // Reset ball to center of screen
    ball->rect.x = (windowWidth - ball->rect.w) / 2.0f;
    ball->rect.y = (windowHeight - ball->rect.h) / 2.0f;

    // Set initial speed and random direction
    float speed = 520.0f; // base speed in px/sec
    float angle = static_cast<float>((std::rand() % 50 - 25) * M_PI / 180.0);
    // Random angle between -25 and +25 degrees for some vertical component
    float vx_sign = (std::rand() % 2 == 0) ? 1.0f : -1.0f;
    ball->vx = vx_sign * speed * std::cos(angle);
    ball->vy = speed * std::sin(angle);
}

double Game::PredictBallImpactX(double targetX) const {
    // Predict the ball's y-coordinate when it reaches x = targetX (right paddle's x).
    // We'll simulate reflection using modular arithmetic for vertical movement.
    double dx = targetX - ball->rect.x;
    if (ball->vx == 0) {
        return ball->rect.y; // Ball not moving horizontally (shouldn't happen in Pong)
    }
    double time = dx / ball->vx; // time for the ball to reach targetX
    if (time < 0) {
        return ball->rect.y; // Ball is moving away from target, no prediction needed
    }
    double futureY = ball->rect.y + ball->vy * time;
    double h = static_cast<double>(windowHeight);

    // Reflect futureY within [0, h] using wrap and mirror technique
    double mod = fmod(fabs(futureY), 2 * h);
    double reflectedY = mod > h ? (2 * h - mod) : mod;
    return reflectedY;
}

void Game::UpdateAI(double dt) {
    // Compute target position for right paddle (center of paddle aligns with predicted impact point)
    double targetY = PredictBallImpactX(paddleRight->rect.x);
    targetY -= paddleRight->rect.h / 2.0; // adjust target to paddle top (so paddle center aligns)

    // Add some reaction imperfections for lower difficulties
    if (difficulty == Difficulty::Easy) {
        // On easy, ignore prediction if ball is far and add a random offset
        double distanceX = ball->rect.x;
        if (distanceX < windowWidth * 0.5) {
            // If ball is not past half field, don't move yet (limited reaction)
            return;
        }
        // Random offset jitter
        targetY += (std::rand() % 41 - 20); // +/-20 px
    } else if (difficulty == Difficulty::Medium) {
        // On medium, maybe wait a bit longer than hard
        double distanceX = ball->rect.x;
        if (distanceX < windowWidth * 0.3) {
            return;
        }
        // smaller random offset
        targetY += (std::rand() % 21 - 10);
    }

    // Clamp targetY within screen
    if (targetY < 0) targetY = 0;
    if (targetY > windowHeight - paddleRight->rect.h) targetY = windowHeight - paddleRight->rect.h;

    // Move paddle towards targetY at its max speed
    if (targetY > paddleRight->rect.y + 1) {
        paddleRight->rect.y += paddleRight->speed * dt;
        if (paddleRight->rect.y > targetY) paddleRight->rect.y = static_cast<float>(targetY);
    } else if (targetY < paddleRight->rect.y - 1) {
        paddleRight->rect.y -= paddleRight->speed * dt;
        if (paddleRight->rect.y < targetY) paddleRight->rect.y = static_cast<float>(targetY);
    }
}

void Game::UpdateScoreTexture() {
    if (!font) return;

    // Prepare score text (e.g., "X - Y")
    char scoreText[32];
    std::snprintf(scoreText, sizeof(scoreText), "%d - %d", scoreLeft, scoreRight);

    // Render blended text to a new surface
    SDL_Color color = {255, 255, 255, 255}; // white color
    SDL_Surface* surface = TTF_RenderText_Blended(font, scoreText, std::strlen(scoreText), color);
    if (!surface) {
        std::cerr << "TTF_RenderText_Blended Error: " << SDL_GetError() << std::endl;
        return;
    }

    // Create texture from surface
    SDL_Texture* newTexture = SDL_CreateTextureFromSurface(renderer, surface);
    if (!newTexture) {
        std::cerr << "SDL_CreateTextureFromSurface Error: " << SDL_GetError() << std::endl;
        SDL_DestroySurface(surface);
        return;
    }

    // Clean up old texture and surface
    if (scoreTexture) {
        SDL_DestroyTexture(scoreTexture);
    }
    scoreTexture = newTexture;
    scoreTexW = surface->w;
    scoreTexH = surface->h;
    SDL_DestroySurface(surface);
}

static void DrawCenteredLine(SDL_Renderer* r, int winW, int winH) {
    const int dashH = 18;
    const int gapH  = 14;
    int y = 0;
    int x = winW / 2;
    while (y < winH) {
        SDL_FRect seg{(float)x - 2.0f, (float)y, 4.0f, (float)dashH};
        SDL_RenderFillRect(r, &seg);
        y += dashH + gapH;
    }
}

void Game::Run() {
    bool running = true;
    bool moveUp = false;
    bool moveDown = false;

    // Use high-resolution time for delta
    Uint64 prevTicks = SDL_GetTicks(); // milliseconds since initialization

    while (running) {
        // Handle events
        SDL_Event event;
        while (SDL_PollEvent(&event)) { // returns true while events remain
            if (event.type == SDL_EVENT_QUIT) {
                running = false;
            } else if (event.type == SDL_EVENT_KEY_DOWN) {
                // Key pressed
                SDL_Keycode key = event.key.key; // virtual key code
                if (key == SDLK_ESCAPE) {
                    running = false;
                }
                if (key == SDLK_W || key == SDLK_UP) {
                    moveUp = true;
                }
                if (key == SDLK_S || key == SDLK_DOWN) {
                    moveDown = true;
                }
                if (key == SDLK_1) SetDifficulty(Difficulty::Easy);
                if (key == SDLK_2) SetDifficulty(Difficulty::Medium);
                if (key == SDLK_3) SetDifficulty(Difficulty::Hard);
            } else if (event.type == SDL_EVENT_KEY_UP) {
                SDL_Keycode key = event.key.key;
                if (key == SDLK_W || key == SDLK_UP) {
                    moveUp = false;
                }
                if (key == SDLK_S || key == SDLK_DOWN) {
                    moveDown = false;
                }
            }
        }

        // Calculate delta time (in seconds)
        Uint64 currentTicks = SDL_GetTicks();
        double dt = (currentTicks - prevTicks) / 1000.0;
        prevTicks = currentTicks;
        if (dt > 0.05) dt = 0.05; // clamp dt to avoid big jumps

        // Update player paddle
        if (moveUp) {
            paddleLeft->rect.y -= paddleLeft->speed * dt;
        }
        if (moveDown) {
            paddleLeft->rect.y += paddleLeft->speed * dt;
        }

        // Clamp player paddle within screen bounds
        if (paddleLeft->rect.y < 0) paddleLeft->rect.y = 0;
        if (paddleLeft->rect.y > windowHeight - paddleLeft->rect.h)
            paddleLeft->rect.y = windowHeight - paddleLeft->rect.h;

        // Update AI paddle
        UpdateAI(dt);
        
        // Clamp AI paddle within screen bounds
        if (paddleRight->rect.y < 0) paddleRight->rect.y = 0;
        if (paddleRight->rect.y > windowHeight - paddleRight->rect.h)
            paddleRight->rect.y = windowHeight - paddleRight->rect.h;

        // Update ball position
        ball->rect.x += ball->vx * dt;
        ball->rect.y += ball->vy * dt;

        // Ball collision with top/bottom walls
        if (ball->rect.y < 0) {
            ball->rect.y = 0;
            ball->vy = -ball->vy;
        } else if (ball->rect.y + ball->rect.h > windowHeight) {
            ball->rect.y = windowHeight - ball->rect.h;
            ball->vy = -ball->vy;
        }

        // Ball collision with paddles (simple AABB check)
        SDL_FRect& bl = ball->rect;
        SDL_FRect& pl = paddleLeft->rect;
        SDL_FRect& pr = paddleRight->rect;

        // Check left paddle
        if (bl.x < pl.x + pl.w && bl.x + bl.w > pl.x &&
            bl.y < pl.y + pl.h && bl.y + bl.h > pl.y && ball->vx < 0) {
            // Ball hit left paddle
            bl.x = pl.x + pl.w; // position ball to avoid sticking
            ball->vx = -ball->vx;
            // Add a bit of vertical change based on where it hit the paddle
            float paddleCenter = pl.y + pl.h / 2.0f;
            float impactDist = (bl.y + bl.h / 2.0f) - paddleCenter;
            ball->vy += impactDist * 5.0f; // impact factor to change angle
            // Increase speed slightly (up to max)
            float maxSpeed = 1100.0f;
            float currentSpeed = std::sqrt(ball->vx * ball->vx + ball->vy * ball->vy);
            if (currentSpeed < maxSpeed) {
                ball->vx *= 1.05f;
                ball->vy *= 1.05f;
            }
        }

        // Check right paddle
        if (bl.x + bl.w > pr.x && bl.x < pr.x + pr.w &&
            bl.y < pr.y + pr.h && bl.y + bl.h > pr.y && ball->vx > 0) {
            // Ball hit right paddle
            bl.x = pr.x - bl.w;
            ball->vx = -ball->vx;
            float paddleCenter = pr.y + pr.h / 2.0f;
            float impactDist = (bl.y + bl.h / 2.0f) - paddleCenter;
            ball->vy += impactDist * 5.0f;
            // Increase speed slightly
            float maxSpeed = 1100.0f;
            float currentSpeed = std::sqrt(ball->vx * ball->vx + ball->vy * ball->vy);
            if (currentSpeed < maxSpeed) {
                ball->vx *= 1.05f;
                ball->vy *= 1.05f;
            }
        }

        // Check if ball went out of bounds (score)
        if (bl.x + bl.w < 0) {
            // Ball went off left side -> right player (AI) scores
            scoreRight += 1;
            UpdateScoreTexture();
            ResetBall();
        } else if (bl.x > windowWidth) {
            // Ball went off right side -> left player scores
            scoreLeft += 1;
            UpdateScoreTexture();
            ResetBall();
        }

        // Rendering
        SDL_SetRenderDrawColor(renderer, 0, 0, 0, 255); // black background
        SDL_RenderClear(renderer);

        // Draw center line
        SDL_SetRenderDrawColor(renderer, 255, 255, 255, 255);
        DrawCenteredLine(renderer, windowWidth, windowHeight);

        // Draw paddles and ball (set draw color to white)
        SDL_SetRenderDrawColor(renderer, 255, 255, 255, 255);
        SDL_RenderFillRect(renderer, &pl);
        SDL_RenderFillRect(renderer, &pr);
        SDL_RenderFillRect(renderer, &bl);

        // Draw score text
        if (scoreTexture) {
            // Render texture at top-center
            SDL_FRect dstRect;
            dstRect.w = (float)scoreTexW;
            dstRect.h = (float)scoreTexH;
            dstRect.x = (windowWidth - dstRect.w) / 2.0f;
            dstRect.y = 30.0f;
            SDL_RenderTexture(renderer, scoreTexture, NULL, &dstRect);
        }

        SDL_RenderPresent(renderer); // present backbuffer
    }
}
