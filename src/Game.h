#pragma once
#include <SDL3/SDL.h>
#include <SDL3_ttf/SDL_ttf.h>
#include <cmath>
#include <random>

// Enum for difficulty levels
enum class Difficulty { Easy, Medium, Hard };

// Forward declarations
struct Ball;
struct Paddle;

// Game class manages the main loop and game state
class Game {
public:
    Game(int w, int h);
    ~Game();

    bool Init();                       // Initialize SDL, window, renderer, etc.
    void Run();                        // Run the game loop
    void SetDifficulty(Difficulty level);

private:
    // Helper methods
    void ResetBall();                              // Reset ball to center after scoring
    void UpdateAI(double dt);                      // Update AI paddle movement based on difficulty
    double PredictBallImpactX(double targetX) const; // Predict Y position when ball reaches targetX

    // SDL objects
    SDL_Window* window;
    SDL_Renderer* renderer;

    // Game dimensions
    int windowWidth;
    int windowHeight;

    // Game objects and state
    Ball* ball;
    Paddle* paddleLeft;
    Paddle* paddleRight;
    int scoreLeft;
    int scoreRight;
    Difficulty difficulty;

    // Font and text rendering
    TTF_Font* font;
    SDL_Texture* scoreTexture;
    int scoreTexW, scoreTexH; // width and height of score texture (for rendering)

    void UpdateScoreTexture(); // renders scoreTexture with current scores
};
