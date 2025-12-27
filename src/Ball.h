#pragma once
#include <SDL3/SDL.h>

// Simple Ball structure with position, velocity, and size
struct Ball {
    SDL_FRect rect; // (x, y, w, h) position and size of the ball
    float vx;       // velocity in x direction (pixels per second)
    float vy;       // velocity in y direction (pixels per second)
};
