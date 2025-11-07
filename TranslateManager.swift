//
//  TranslateManager.swift
//  TranslateMe
//
//  Created by Rezwan Mahmud on 11/5/25.
//

import Foundation

struct TranslationResponse: Codable {
    struct Data: Codable {
        let translatedText: String
    }
    let responseData: Data
}

@Observable
class TranslateManager {
    func translate(text: String, from: String, to: String) async throws -> String {
        let q = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://api.mymemory.translated.net/get?q=\(q)&langpair=\(from)|\(to)"
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }

        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode(TranslationResponse.self, from: data)
        return decoded.responseData.translatedText
    }
}
