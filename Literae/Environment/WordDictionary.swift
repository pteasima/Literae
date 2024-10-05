import Foundation

struct WordDictionary {
    let words = ["máma", "táta", "bába", "děda", "tom"]
    
    func detectWord(in text: String) -> String? {
        return words.first {
            let suffix = String(text.suffix($0.count))
            return NSString(string: suffix).compare($0, options: [.caseInsensitive, .diacriticInsensitive]) == .orderedSame
        }
    }    
}
