#pragma once
#include <SDL3/SDL.h>

// Simple Paddle structure
struct Paddle {
    SDL_FRect rect; // (x, y, w, h) position and size of paddle
    float speed;    // movement speed (pixels per second)
};
