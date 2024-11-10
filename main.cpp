//
// Created by Willi on 11/10/2024.
//

#include <SDL.h>
#include <SDL_ttf.h>

int main(int argc, char* argv[]) {
    //test SDL
    SDL_Init(SDL_INIT_EVERYTHING);
    TTF_Init();
    SDL_Quit();
    TTF_Quit();

    return 0;
}