import Foundation
import Combine
import PlaygroundSupport
import SwiftUI

final class SliderData: ObservableObject {
   
   @Published var gain: Float = 100
}

@objc(MainView)
class MainView: NSView {
   
   private let sliderData = SliderData()
   
   @objc var onDidChange: ((Float) -> Void)?
   
   override init(frame frameRect: NSRect) {
      super.init(frame: frameRect)
      wantsLayer = true
      layer?.backgroundColor = NSColor.lightGray.cgColor
      let view = NSHostingView(rootView: MainUI { [weak self] in
         self?.onDidChange?($0)
      }.environmentObject(sliderData))
      view.translatesAutoresizingMaskIntoConstraints = false
      addSubview(view)
      leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
      trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
      topAnchor.constraint(equalTo: view.topAnchor).isActive = true
      bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
   }
   
   @objc required dynamic init?(coder aDecoder: NSCoder) {
      fatalError()
   }
   
   @objc func setGain(_ value: Float) {
      print("Value from Host: \(value)")
      sliderData.gain = value
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
            self.onChanged($0)
            self.gain = $0
         }), in: 0...100, step: 2).frame(minWidth: 240)
         Text("Gain: \(Int(gain))")
      }.background(Color.gray).onReceive(sliderData.$gain, perform: { self.gain = $0 })
   }
}

let view = MainView(frame: NSRect(x: 0, y: 0, width: 240, height: 120))
view.onDidChange = {
   print("Changed: \($0)")
}

DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
   view.setGain(50)
}

PlaygroundPage.current.setLiveView(view)
