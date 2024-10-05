//
//  LiteraeTests.swift
//  LiteraeTests
//
//  Created by Petr Šíma on 9/28/24.
//

import Testing
import Foundation

struct LiteraeTests {

    @Test func wordDetectionTest() async throws {
        let langCultureCode: String = "cs"
        let defaults = UserDefaults.standard
        defaults.set([langCultureCode], forKey: "AppleLanguages")
        defaults.synchronize()
//        #expect(Locale.current.identifier == "cs_CZ")
        let result = NSString(string: "bába").compare("baba", options: [.caseInsensitive, .diacriticInsensitive]) == .orderedSame
        #expect(result)
    }

}
