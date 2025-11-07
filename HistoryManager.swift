//
//  HistoryManager.swift
//  TranslateMe
//
//  Created by Rezwan Mahmud on 11/5/25.
//

import Foundation
import FirebaseFirestore


struct TranslationItem: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    let sourceText: String
    let translatedText: String
    let fromLang: String
    let toLang: String
    let timestamp: Date
    let uid: String
}

@Observable
class HistoryManager {
    private let db = Firestore.firestore()
    var items: [TranslationItem] = []

    func startListening(uid: String) {
        db.collection("users")
          .document(uid)
          .collection("translations")
          .order(by: "timestamp", descending: true)
          .addSnapshotListener { [weak self] snap, err in
              guard let docs = snap?.documents else { return }
              self?.items = docs.compactMap { try? $0.data(as: TranslationItem.self) }
          }
    }

    func save(uid: String, item: TranslationItem) {
        do {
            _ = try db.collection("users")
                .document(uid)
                .collection("translations")
                .addDocument(from: item)
        } catch {
            print("Save error:", error)
        }
    }

    func clear(uid: String) async {
        let ref = db.collection("users").document(uid).collection("translations")
        do {
            let batch = db.batch()
            let snap = try await ref.getDocuments()
            for doc in snap.documents { batch.deleteDocument(doc.reference) }
            try await batch.commit()
        } catch { print("Clear error:", error) }
    }
}
