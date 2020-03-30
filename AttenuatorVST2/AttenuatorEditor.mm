//
//  AttenuatorEditor.mm
//  AttenuatorVST2
//
//  Created by Vlad Gorlov on 30.03.20.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#include "AttenuatorEditor.hpp"
#import <Cocoa/Cocoa.h>
#import <AttenuatorVST2UI/AttenuatorVST2UI-Swift.h>

AttenuatorEditor::AttenuatorEditor(AudioEffect *effect) : AEffEditor (effect)  {
   mView = nil;
   effect->setEditor(this);
   this->rect.top = 0;
   this->rect.left = 0;
   this->rect.right = 200;
   this->rect.bottom = 100;
}

AttenuatorEditor::~AttenuatorEditor() {
   mView = nil;
}

bool AttenuatorEditor::open (void* ptr) {
   AEffEditor::open(ptr);

   NSView * parent = (__bridge NSView*)ptr;
   // Should be same dimensions as in `rect` property.
   NSRect proxyRect = NSMakeRect(0, 0, parent.bounds.size.width, parent.bounds.size.height);
   MainView * plugInView = [ [MainView alloc] initWithFrame: proxyRect];
   plugInView.translatesAutoresizingMaskIntoConstraints = true;
   plugInView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
   [parent addSubview: plugInView];
   [plugInView setNeedsDisplay:true];
   mView = plugInView;
   plugInView.onDidChange = ^(float gain) {
      effect->setParameterAutomated(0, gain); // We have only one parameter. Passing `0` as index.
   };
   [plugInView setGain: effect->getParameter(0)];
   return true;
}

void AttenuatorEditor::close() {
   [mView removeFromSuperview];
   mView = nil;
}

bool AttenuatorEditor::getRect(ERect** inRect) {
   *inRect = &rect;
   return true;
}

void AttenuatorEditor::setParameter(VstInt32 index, float value) {
   // Ignoring `index`. We have only one parameter.
   dispatch_async(dispatch_get_main_queue(), ^{
      [mView setGain: value];
   });
}
