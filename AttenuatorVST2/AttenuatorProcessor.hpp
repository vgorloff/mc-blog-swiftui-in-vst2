//
//  AttenuatorProcessor.hpp
//  AttenuatorVST2
//
//  Created by Vlad Gorlov on 30.03.20.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#ifndef AttenuatorProcessor_hpp
#define AttenuatorProcessor_hpp

#include "audioeffectx.h"

class AttenuatorProcessor : public AudioEffectX {
public:
   
   AttenuatorProcessor(audioMasterCallback audioMaster);
   virtual ~AttenuatorProcessor();
   
   // MARK: - Processing
   virtual void processReplacing(float **inputs, float **outputs, VstInt32 sampleFrames);
   virtual void processDoubleReplacing (double** inputs, double** outputs, VstInt32 sampleFrames);
   
   // MARK: - Programs
   virtual void setProgramName (char* name);
   virtual void getProgramName (char* name);

   // MARK: - Parameters
   virtual void setParameterAutomated (VstInt32 index, float value);
   virtual void setParameter (VstInt32 index, float value);
   virtual float getParameter (VstInt32 index);
   virtual void getParameterLabel (VstInt32 index, char* label);
   virtual void getParameterDisplay (VstInt32 index, char* text);
   virtual void getParameterName (VstInt32 index, char* text);
   
   // MARK: - Metadata
   virtual bool getEffectName (char* name);
   virtual bool getVendorString (char* text);
   virtual bool getProductString (char* text);
   
   virtual VstInt32 getVendorVersion () { return 1000; }
   virtual VstPlugCategory getPlugCategory () { return kPlugCategEffect; }
   
private:
   float mGain;
   char programName[kVstMaxProgNameLen + 1];
};

#endif /* AttenuatorProcessor_hpp */
