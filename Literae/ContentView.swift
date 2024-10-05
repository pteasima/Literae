import SwiftUI

struct ContentView: View {
    
    @FocusState var focus: Bool
    
    @Environment(\.speaker) var speaker
    @Environment(\.dictionary) var dictionary
    @State private var text: String = ""
    @State private var detectedWord: String?
    var body: some View {
        VStack(spacing: 40) {
            HStack(spacing: 40) {
                ForEach(dictionary.words, id: \.self) { word in
                    Button {
                        text += word
                    } label: {
                        Text(word)
                            .foregroundStyle(word == detectedWord ? Color.red : .primary)
                    }
                }
            }
            Text(
                {
                    var string = AttributedString(speaker.text)
                    if let highlightedRange = speaker.highlightedRange.flatMap({ Range($0, in: string)}) {
                        string[highlightedRange].foregroundColor = .red
                    }
                    return string
                }()
            )
            .contentTransition(.numericText())
            .animation(.easeOut(duration: 1), value: speaker.text)
            TextEditor(text: $text)
                .onAppear { focus = true }
                .focused($focus)
                .keyboardType(.asciiCapable)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.characters)
                .overlay {
                    Color.white
                        .allowsHitTesting(false)
                }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .font(.largeTitle)
        .onChange(of: text) { oldValue, newValue in
            if let index = newValue.firstRange(of: oldValue)?.upperBound,
               let appendedString = .some(String(newValue.suffix(from: index))),
                !appendedString.isEmpty {
                
                speaker.say(appendedString)
            }
            detectedWord = dictionary.detectWord(in: newValue)
        }
        .onChange(of: detectedWord) {
            if let detectedWord {
                Task {
                    try await Task.sleep(for: .seconds(1))
                    text = ""
                    speaker.say(detectedWord)
                    self.detectedWord = nil
                }
            }
        }
        .textCase(.uppercase)
    }
}

#Preview {
    ContentView()
}
