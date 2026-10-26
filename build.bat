@echo off
REM Windows (Visual Studio 2022 + CMake installed). Run from "x64 Native Tools Command Prompt".
cmake -B build -G "Visual Studio 17 2022" -A x64 -DMW_COPY_AFTER_BUILD=ON
cmake --build build --config Release --target MasteringWorkstation_VST3 MWTests
build\MWTests_artefacts\Release\MWTests.exe
echo Built: build\MasteringWorkstation_artefacts\Release\VST3\Mastering Workstation.vst3
echo (copied to C:\Program Files\Common Files\VST3 if run as Administrator)
