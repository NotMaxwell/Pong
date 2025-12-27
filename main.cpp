// Pong Clone with SDL3 on macOS
// Enhanced Pong clone using modern C++17 and SDL3/SDL3_ttf
// 
// Controls:
// - Left paddle: W/S or Up/Down arrow keys
// - Difficulty: Press 1 (Easy), 2 (Medium), 3 (Hard)
// - ESC quits
//
// Features:
// - Smooth ball physics with subpixel movement
// - AI-controlled right paddle with predictive trajectory tracking
// - Adjustable difficulty levels
// - On-screen scoring with SDL3_ttf

#include "src/Game.h"

int main(int argc, char* argv[]) {
    Game pongGame(800, 600);
    if (!pongGame.Init()) {
        return 1; // Initialization failed (error already logged)
    }
    pongGame.Run();
    // Game destructor will handle cleanup
    return 0;
}
