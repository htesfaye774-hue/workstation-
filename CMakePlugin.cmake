juce_add_plugin(MasteringWorkstation
    COMPANY_NAME "MW Audio"
    PLUGIN_MANUFACTURER_CODE MwAu
    PLUGIN_CODE MwWs
    FORMATS VST3
    PRODUCT_NAME "Mastering Workstation"
    IS_SYNTH FALSE
    NEEDS_MIDI_INPUT FALSE
    NEEDS_MIDI_OUTPUT FALSE
    VST3_CATEGORIES Fx Dynamics EQ
    COPY_PLUGIN_AFTER_BUILD ${MW_COPY_AFTER_BUILD})

target_sources(MasteringWorkstation PRIVATE
    Source/PluginEntry.cpp Source/PluginProcessor.cpp Source/UI/PluginEditor.cpp)

target_compile_definitions(MasteringWorkstation PUBLIC
    JUCE_WEB_BROWSER=0 JUCE_USE_CURL=0 JUCE_VST3_CAN_REPLACE_VST2=0 JUCE_DISPLAY_SPLASH_SCREEN=0)

target_link_libraries(MasteringWorkstation PRIVATE
    juce::juce_audio_utils juce::juce_audio_formats juce::juce_dsp
    PUBLIC juce::juce_recommended_config_flags)

# --- host-side verification tool: loads the *built* VST3 binary like a DAW would
if(MW_BUILD_TESTS)
  juce_add_console_app(MWHostTest PRODUCT_NAME "MWHostTest")
  target_sources(MWHostTest PRIVATE Tests/HostTest.cpp Source/PluginProcessor.cpp Source/UI/PluginEditor.cpp)
  target_compile_definitions(MWHostTest PRIVATE JUCE_WEB_BROWSER=0 JUCE_USE_CURL=0 JUCE_PLUGINHOST_VST3=1 JUCE_MODAL_LOOPS_PERMITTED=1 JUCE_PLUGINHOST_LV2=0 JUCE_PLUGINHOST_LADSPA=0)
  target_link_libraries(MWHostTest PRIVATE juce::juce_audio_utils juce::juce_audio_formats juce::juce_dsp juce::juce_recommended_config_flags)
  add_dependencies(MWHostTest MasteringWorkstation_VST3)
endif()
