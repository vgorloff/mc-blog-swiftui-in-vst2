//
//  AttenuatorEditor.hpp
//  AttenuatorVST2
//
//  Created by Vlad Gorlov on 30.03.20.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#ifndef AttenuatorEditor_hpp
#define AttenuatorEditor_hpp

#include "aeffeditor.h"

// Forward declarations.
#ifdef __OBJC__
@class MainView;
#else
typedef struct objc_object MainView;
#endif

class AttenuatorEditor : public AEffEditor
{
public:
   AttenuatorEditor (AudioEffect* ptr);
   virtual ~AttenuatorEditor();
   
   virtual bool open (void* ptr);
   virtual void close ();
   virtual bool getRect (ERect** rect);
   
   virtual void setParameter (VstInt32 index, float value);
   
private:
   
   ERect   rect;
   MainView* mView;
};

#endif /* AttenuatorEditor_hpp */
