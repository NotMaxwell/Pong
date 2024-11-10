cmake_minimum_required(VERSION 3.29)
project(Pong)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake_modules)

set(SDL2_PATH "${CMAKE_SOURCE_DIR}/libs/SDL2")
set(SDL2_TTF_PATH "${CMAKE_SOURCE_DIR}/libs/SDL2_TTF")

find_package(SDL2 REQUIRED)
include_directories(${SDL2_INCLUDE_DIR})

find_package(SDL2_TTF REQUIRED)
include_directories(${SDL2_TTF_INCLUDE_DIR})

add_executable(Pong main.cpp)

target_link_libraries(${PROJECT_NAME} ${SDL2_LIBRARY})
target_link_libraries(${PROJECT_NAME} ${SDL2_TTF_LIBRARY})