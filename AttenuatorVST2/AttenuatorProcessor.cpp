//
//  AttenuatorProcessor.cpp
//  AttenuatorVST2
//
//  Created by Vlad Gorlov on 30.03.20.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#include "AttenuatorProcessor.hpp"

AudioEffect* createEffectInstance(audioMasterCallback audioMaster) {
   return new AttenuatorProcessor(audioMaster);
}

AttenuatorProcessor::AttenuatorProcessor(audioMasterCallback audioMaster)
: AudioEffectX(audioMaster, 1, 1) { // 1 program and 1 parameter only.
   setNumInputs (2);       // stereo in
   setNumOutputs (2);      // stereo out
   setUniqueID ('MyAg');   // identify. Kind of unique ID of plug-in.
   canProcessReplacing (); // supports replacing output
   canDoubleReplacing ();  // supports double precision processing
   
   mGain = 1.f;           // default to 0 dB
   vst_strncpy(programName, "Default", kVstMaxProgNameLen);   // default program name
}

AttenuatorProcessor::~AttenuatorProcessor() {
   // Nothing to do at the moment.
}

// MARK: - Processing

void AttenuatorProcessor::processReplacing (float** inputs, float** outputs, VstInt32 sampleFrames) {
   
   float* in1  =  inputs[0];
   float* in2  =  inputs[1];
   float* out1 = outputs[0];
   float* out2 = outputs[1];
   
   while (--sampleFrames >= 0) {
      (*out1++) = (*in1++) * mGain;
      (*out2++) = (*in2++) * mGain;
   }
}

void AttenuatorProcessor::processDoubleReplacing (double** inputs, double** outputs, VstInt32 sampleFrames) {
   
   double* in1  =  inputs[0];
   double* in2  =  inputs[1];
   double* out1 = outputs[0];
   double* out2 = outputs[1];
   double dGain = mGain;
   
   while (--sampleFrames >= 0) {
      (*out1++) = (*in1++) * dGain;
      (*out2++) = (*in2++) * dGain;
   }
}

// MARK: - Programs

void AttenuatorProcessor::setProgramName (char* name) {
   vst_strncpy(programName, name, kVstMaxProgNameLen);
}

void AttenuatorProcessor::getProgramName (char* name) {
   vst_strncpy(name, programName, kVstMaxProgNameLen);
}

// MARK: - Parameters

void AttenuatorProcessor::setParameter (VstInt32 index, float value) {
   mGain = value;
}

void AttenuatorProcessor::setParameterAutomated (VstInt32 index, float value) {
   AudioEffectX::setParameterAutomated(index, value);
}

float AttenuatorProcessor::getParameter (VstInt32 index) {
   return mGain;
}

void AttenuatorProcessor::getParameterName (VstInt32 index, char* label) {
   vst_strncpy(label, "Gain", kVstMaxParamStrLen);
}

void AttenuatorProcessor::getParameterDisplay (VstInt32 index, char* text) {
   dB2string(mGain, text, kVstMaxParamStrLen);
}

void AttenuatorProcessor::getParameterLabel (VstInt32 index, char* label) {
   vst_strncpy(label, "dB", kVstMaxParamStrLen);
}

// MARK: - Metadata

bool AttenuatorProcessor::getEffectName (char* name) {
   vst_strncpy(name, "Attenuator VST2", kVstMaxEffectNameLen);
   return true;
}

bool AttenuatorProcessor::getProductString (char* text) {
   vst_strncpy(text, "Examples", kVstMaxProductStrLen);
   return true;
}

bool AttenuatorProcessor::getVendorString (char* text) {
   vst_strncpy(text, "Vlad Gorlov", kVstMaxVendorStrLen);
   return true;
}
