import ExpoModulesCore
import AVFoundation

public class ExpoAudioMixerModule: Module {
  var audioEngine:AVAudioEngine!
  var firstNode:AVAudioPlayerNode!
  var secondNode:AVAudioPlayerNode!
  
  public func definition() -> ModuleDefinition {

    Name("ExpoAudioMixer")

    Function("play") { (filename: String, filename2: String) in
      audioEngine = AVAudioEngine()

      firstNode = AVAudioPlayerNode()
      secondNode = AVAudioPlayerNode()
      audioEngine.attach(firstNode)
      audioEngine.attach(secondNode)

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

      let mainMixerNode:AVAudioMixerNode! = audioEngine.mainMixerNode
      
      audioEngine.connect(firstNode, to:mainMixerNode, format:buffer.format)
      audioEngine.connect(secondNode, to:mainMixerNode, format:buffer2.format)

      firstNode.scheduleBuffer(buffer, at:nil, options:AVAudioPlayerNodeBufferOptions.loops, completionHandler:nil)
      secondNode.scheduleBuffer(buffer2, at:nil, options:AVAudioPlayerNodeBufferOptions.loops, completionHandler:nil)

      firstNode.pan = 0.0
      secondNode.pan = 0.0
      
      try audioEngine.start()
      firstNode.prepare(withFrameCount: buffer.frameLength)
      firstNode.prepare(withFrameCount: buffer2.frameLength)
    

      let renderTime:AVAudioTime = audioEngine.outputNode.lastRenderTime ?? AVAudioTime();
      let startSampleTime:AVAudioFramePosition = renderTime.sampleTime;

      let startTime: AVAudioTime = AVAudioTime(sampleTime: startSampleTime.advanced(by: (Int)(renderTime.sampleRate * 0.5)), atRate: renderTime.sampleRate);

      
      firstNode.play(at: startTime)
      secondNode.play(at: startTime)
    }

    Function("setVolume") { (firstTrackVolume: Float, secondTrackVolume: Float) in
      firstNode.volume = firstTrackVolume
      secondNode.volume = secondTrackVolume
    }

    Function("setPan") { (firstTrackPan: Float, secondTrackPan: Float) in
      firstNode.pan = firstTrackPan
      secondNode.pan = secondTrackPan
    }

    Function("pause") {
      firstNode.pause()
      secondNode.pause()
    }

    Function("resume") {
      firstNode.play()
      secondNode.play()
    }

    Function("stop") {
      firstNode.stop()
      secondNode.stop()
    }

  }
}
