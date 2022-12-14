# This is a very simple example of using SOCI in a CMake-based project
# when placing SOCI in a subdirectory lib/soci/ of your project.
# For this example, the SOCI backend called Empty is used.

cmake_minimum_required(VERSION 2.8 FATAL_ERROR)

project(SOCIExampleSubdirectoryInclude)

set(SOCI_BINARY_DIR ${CMAKE_CURRENT_BINARY_DIR}/soci)

# All compile options need to be set before the SOCI directory gets included.
# The backend you want to use needs to be enabled here.
option(SOCI_CXX11 "Build to the C++11 standard" ON)
option(SOCI_EMPTY "Build the sample backend called Empty" ON)

# This line needs to be changed to include the directory you placed SOCI in, e.g.
#  add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/lib/soci ${SOCI_BINARY_DIR})
add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/../.. ${SOCI_BINARY_DIR})

add_executable(subdir_include subdir-include.cpp)

# SOCI's built include/ directory has to be added to the project explicitly.
# This is needed so that SOCI can find the file soci/soci-config.h that gets generated by CMake.
target_include_directories(subdir_include
    PRIVATE
        ${SOCI_BINARY_DIR}/include
)

# Link the soci_<backend> libraries you want to use here.
target_link_libraries(subdir_include
    PRIVATE
        soci_core
        soci_empty
)
