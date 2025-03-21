cmake_minimum_required(VERSION 3.27)

project(astar)

set(CMAKE_STATIC_LIBRARY_PREFIX "")

add_compile_definitions(AM_IMPLEMENTATION)

add_library(astar STATIC ${CMAKE_SOURCE_DIR}/AStar/AStar.c)

set_target_properties(astar PROPERTIES OUTPUT_NAME "astar")
