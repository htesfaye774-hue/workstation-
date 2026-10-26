cmake_minimum_required(VERSION 3.22)
project(MasteringWorkstation VERSION 1.0.0 LANGUAGES C CXX)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  set(CMAKE_BUILD_TYPE Release)
endif()

# JUCE: use ./JUCE if present, otherwise fetch the pinned release
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/JUCE/CMakeLists.txt")
  add_subdirectory(JUCE)
elseif(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/../JUCE/CMakeLists.txt")
  add_subdirectory(../JUCE JUCE)
else()
  include(FetchContent)
  FetchContent_Declare(JUCE GIT_REPOSITORY https://github.com/juce-framework/JUCE.git GIT_TAG 8.0.15 GIT_SHALLOW TRUE)
  FetchContent_MakeAvailable(JUCE)
endif()

option(MW_BUILD_TESTS "Build DSP test executable" ON)
option(MW_BUILD_PLUGIN "Build the VST3 plugin" ON)
option(MW_COPY_AFTER_BUILD "Copy plugin into the system VST3 folder after build" ON)

if(MW_BUILD_TESTS)
  juce_add_console_app(MWTests PRODUCT_NAME "MWTests")
  target_sources(MWTests PRIVATE Tests/EngineTests.cpp)
  target_compile_definitions(MWTests PRIVATE JUCE_WEB_BROWSER=0 JUCE_USE_CURL=0)
  target_link_libraries(MWTests PRIVATE juce::juce_dsp juce::juce_recommended_config_flags
                        juce::juce_recommended_warning_flags)
endif()

if(MW_BUILD_PLUGIN AND EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/CMakePlugin.cmake")
  include(CMakePlugin.cmake)
endif()
