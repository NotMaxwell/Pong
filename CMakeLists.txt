cmake_minimum_required(VERSION 3.29)

project(Pong LANGUAGES CXX)

# --- C++ standard ---
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# --- Find dependencies via Conan-generated config files ---
# Conan CMakeDeps provides CONFIG packages, not Find*.cmake
find_package(SDL3 REQUIRED CONFIG)
find_package(SDL3_ttf REQUIRED CONFIG)

# Use the normal C/C++ main() entry point (we don't want SDL_main.cpp added automatically)
add_compile_definitions(SDL_MAIN_HANDLED)

# --- Your executable ---
add_executable(Pong
        main.cpp
        src/Game.h
        src/Game.cpp
        src/Ball.h
        src/Paddle.h
)

# --- Link libraries ---
# These targets are exactly what Conan told you to use
target_link_libraries(Pong PRIVATE
        sdl::sdl
        SDL3_ttf::SDL3_ttf-static
)
