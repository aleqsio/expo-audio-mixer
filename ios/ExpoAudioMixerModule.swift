import ExpoModulesCore
import AVFoundation

public class ExpoAudioMixerModule: Module {
  // Each module class must implement the definition function. The definition consists of components
  // that describes the module's functionality and behavior.
  // See https://docs.expo.dev/modules/module-api for more details about available components.
  
  var audioEngine:AVAudioEngine!
  var inputGuitarPlayerNode:AVAudioPlayerNode!
  var inputDrumsPlayerNode:AVAudioPlayerNode!
  
  public func definition() -> ModuleDefinition {
    // Sets the name of the module that JavaScript code will use to refer to the module. Takes a string as an argument.
    // Can be inferred from module's class name, but it's recommended to set it explicitly for clarity.
    // The module will be accessible from `requireNativeModule('ExpoAudioMixer')` in JavaScript.
    Name("ExpoAudioMixer")
    
    

//    // Sets constant properties on the module. Can take a dictionary or a closure that returns a dictionary.
//    Constants([
//      "PI": Double.pi
//    ])
//
//    // Defines event names that the module can send to JavaScript.
//    Events("onChange")
//
//    // Defines a JavaScript synchronous function that runs the native code on the JavaScript thread.
    Function("play") { (filename: String, filename2: String) in
      //Allocate the audio engine
      audioEngine = AVAudioEngine()

      //Create a player node for the guitar
      inputGuitarPlayerNode = AVAudioPlayerNode()
      inputDrumsPlayerNode = AVAudioPlayerNode()
      audioEngine.attach(inputGuitarPlayerNode)
      audioEngine.attach(inputDrumsPlayerNode)

      //Load the audio file
      let fileURL = try! FileManager.default
        .url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
          .appendingPathComponent(filename)
      
      let file2URL = try! FileManager.default
        .url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
          .appendingPathComponent(filename2)

      let file:AVAudioFile! = try AVAudioFile.init(forReading: fileURL, commonFormat: AVAudioCommonFormat.pcmFormatFloat32, interleaved: false)
      let buffer:AVAudioPCMBuffer! = AVAudioPCMBuffer.init(pcmFormat: file.processingFormat, frameCapacity:AVAudioFrameCount(file.length))
      buffer.frameLength = AVAudioFrameCount(file.length)
      try file.read(into: buffer)
      
     
      let file2:AVAudioFile! = try AVAudioFile.init(forReading: file2URL, commonFormat: AVAudioCommonFormat.pcmFormatFloat32, interleaved: false)
      let buffer2:AVAudioPCMBuffer! = AVAudioPCMBuffer.init(pcmFormat: file2.processingFormat, frameCapacity:AVAudioFrameCount(file2.length))
      buffer2.frameLength = AVAudioFrameCount(file2.length)
      try file2.read(into: buffer2)
      print(buffer.format)
      
//      //Load the audio file
//      let guitar2FileUrl:URL! =  URL(fileURLWithPath: uri)
//
//      let guitar2File:AVAudioFile! = try AVAudioFile.init(forReading: guitar2FileUrl)
//
//      let guitar2Buffer:AVAudioPCMBuffer! = AVAudioPCMBuffer.init(pcmFormat: guitar2File.processingFormat, frameCapacity:AVAudioFrameCount(guitar2File.length))
//      try guitar2File.read(into: guitarBuffer)
//
//
//
      let mainMixerNode:AVAudioMixerNode! = audioEngine.mainMixerNode
      
      audioEngine.connect(inputGuitarPlayerNode, to:mainMixerNode, format:buffer.format)
      audioEngine.connect(inputDrumsPlayerNode, to:mainMixerNode, format:buffer2.format)
//
      inputGuitarPlayerNode.scheduleBuffer(buffer, at:nil, options:AVAudioPlayerNodeBufferOptions.loops, completionHandler:nil)
      inputDrumsPlayerNode.scheduleBuffer(buffer2, at:nil, options:AVAudioPlayerNodeBufferOptions.loops, completionHandler:nil)

      inputGuitarPlayerNode.pan = 0.0    //Set guitar to the left
      inputDrumsPlayerNode.pan = 0.0      //Set drums to the right
      
      try audioEngine.start()
      inputGuitarPlayerNode.prepare(withFrameCount: buffer.frameLength)
      inputGuitarPlayerNode.prepare(withFrameCount: buffer2.frameLength)
    

      let renderTime:AVAudioTime = audioEngine.outputNode.lastRenderTime ?? AVAudioTime();
      let startSampleTime:AVAudioFramePosition = renderTime.sampleTime;

      let startTime: AVAudioTime = AVAudioTime(sampleTime: startSampleTime.advanced(by: (Int)(renderTime.sampleRate * 0.5)), atRate: renderTime.sampleRate);

      
      inputGuitarPlayerNode.play(at: startTime)
      inputDrumsPlayerNode.play(at: startTime)
    }
    Function("setPan") { (pan: Float) in
      print(pan)
      inputGuitarPlayerNode.volume = pan  //Set guitar to the left
      inputDrumsPlayerNode.volume = 1-pan
    }
//
//    // Defines a JavaScript function that always returns a Promise and whose native code
//    // is by default dispatched on the different thread than the JavaScript runtime runs on.
//    AsyncFunction("setValueAsync") { (value: String) in
//      // Send an event to JavaScript.
//      self.sendEvent("onChange", [
//        "value": value
//      ])
//    }

  }
}
