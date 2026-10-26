#!/usr/bin/env bash
# Linux / macOS: configure, build, run DSP tests, install the VST3 into the user VST3 folder.
set -e
cmake -B build -DCMAKE_BUILD_TYPE=Release -DMW_COPY_AFTER_BUILD=ON
cmake --build build --config Release --target MasteringWorkstation_VST3 MWTests --parallel
./build/MWTests_artefacts/Release/MWTests
echo "Built: build/MasteringWorkstation_artefacts/Release/VST3/"
