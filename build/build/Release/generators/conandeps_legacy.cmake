message(STATUS "Conan: Using CMakeDeps conandeps_legacy.cmake aggregator via include()")
message(STATUS "Conan: It is recommended to use explicit find_package() per dependency instead")

find_package(SDL3_ttf)
find_package(SDL3)

set(CONANDEPS_LEGACY  SDL3_ttf::SDL3_ttf-static  sdl::sdl )