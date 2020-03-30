//
//  MainUI.swift
//  AttenuatorVST2UI
//
//  Created by Vlad Gorlov on 30.03.20.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

final class SliderData: ObservableObject {
   
   @Published var gain: Float = 100
}

@objc(MainView)
public class MainView: NSView {
   
   private let sliderData = SliderData()
   
   @objc public var onDidChange: ((Float) -> Void)?
   
   public override init(frame frameRect: NSRect) {
      super.init(frame: frameRect)
      wantsLayer = true
      layer?.backgroundColor = NSColor.lightGray.cgColor
      let view = NSHostingView(rootView: MainUI { [weak self] in
         let value = $0 / 100
         print("MainView> Value to Host: \(value)")
         self?.onDidChange?(value)
      }.environmentObject(sliderData))
      view.translatesAutoresizingMaskIntoConstraints = false
      addSubview(view)
      leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
      trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
      topAnchor.constraint(equalTo: view.topAnchor).isActive = true
      bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
   }
   
   public required dynamic init?(coder aDecoder: NSCoder) {
      fatalError()
   }
   
   @objc public func setGain(_ value: Float) {
      print("MainView> Value from Host: \(value)")
      sliderData.gain = 100 * value
   }
}

struct MainUI: View {
   
   @EnvironmentObject var sliderData: SliderData
   @State var gain: Float = 100
   
   private var onChanged: (Float) -> Void
   
   init(onChanged: @escaping (Float) -> Void) {
      self.onChanged = onChanged
   }
   
   var body: some View {
      VStack {
         Slider(value: Binding<Float>(get: { self.gain }, set: {
            self.gain = $0
            self.onChanged($0)
         }), in: 0...100, step: 2)
         Text("Gain: \(Int(gain))")
      }.onReceive(sliderData.$gain, perform: { self.gain = $0 })
   }
}

/*
 
 Previews not yet working in Xcode 11.4 on macOS 10.15.4 when SwiftUI view inside Framework.
 Use Playground to preview.
 
 ~~~~~~~~~~~~~~~>

 GenericHumanReadableError: unexpected error occurred

 messageRepliedWithError("Connecting to launched interactive agent 11092", Optional(Error Domain=com.apple.dt.xcodepreviews.service Code=17 "connectToPreviewHost: Failed to connect to 11092: (null)" UserInfo={NSLocalizedDescription=connectToPreviewHost: Failed to connect to 11092: (null)}))
 
 <~~~~~~~~~~~~~~~
*/
