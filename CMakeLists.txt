cmake_minimum_required(VERSION 3.27)

project(astar)

# remove "lib" prefix on unix systems
set(CMAKE_STATIC_LIBRARY_PREFIX "")

add_library(astar STATIC AStar/AStar.c)

if (WIN32)
    set(OUTPUT_DIR "windows" CACHE STRING "")
elseif(APPLE)
    set(OUTPUT_DIR "macos" CACHE STRING "")
elseif(UNIX)
    set(OUTPUT_DIR "linux" CACHE STRING "")
endif ()

set_target_properties(astar PROPERTIES ARCHIVE_OUTPUT_DIRECTORY $<LOWER_CASE:../../libs/${OUTPUT_DIR}>) 
set_target_properties(astar PROPERTIES OUTPUT_NAME_DEBUG "astard")
set_target_properties(astar PROPERTIES OUTPUT_NAME_RELEASE "astar")