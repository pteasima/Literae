import Foundation
import AVFoundation

@Observable
final class Speaker: NSObject, AVSpeechSynthesizerDelegate {
    var text: String = ""
    var currentUtterance: AVSpeechUtterance?
    var highlightedRange: Range<String.Index>? {
        currentUtterance.flatMap { text.firstRange(of: $0.speechString) }
    }
    
    var lastWord: String = ""
    
    @ObservationIgnored lazy var synthesizer: AVSpeechSynthesizer = {
        $0.delegate = self
        return $0
    }(AVSpeechSynthesizer())
    @ObservationIgnored
    lazy var say: (String) -> Void = { [weak self] text in
        guard let self else { return }
        print(text)
        self.text.append(text)
        
        synthesizer.speak(makeUtterance(text))
    }
    @ObservationIgnored var makeUtterance: (String) -> AVSpeechUtterance = { text in
        let utterance = AVSpeechUtterance(string: text.lowercased())
        utterance.rate = 0.5
        utterance.voice = .init(language: "cs-CZ")
        return utterance
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeak marker: AVSpeechSynthesisMarker, utterance: AVSpeechUtterance) {
        currentUtterance = utterance
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        currentUtterance = nil
        let newText = text.dropFirst(utterance.speechString.count)
        lastWord += newText
        text = String(newText)
    }
    
    
}

extension Speaker {
    static let mock: Speaker = {
        $0.say = { print("mock \($0)")}
        return $0
    }(Speaker())
}
