//
//  TranslateView.swift
//  TranslateMe
//
//  Created by Rezwan Mahmud on 11/5/25.
//

import SwiftUI
import FirebaseAuth

struct TranslateView: View {
    @Environment(\.authManager) private var auth
    @Environment(\.translateManager) private var translator
    @Environment(\.historyManager) private var history

    @State private var sourceText = ""
    @State private var resultText = ""
    @State private var fromLang = "en"
    @State private var toLang = "es"
    @State private var isLoading = false
    private let langs = ["en","es","fr","de","it","pt","bn"]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Language pickers (stretch-ready)
                    HStack {
                        Picker("From", selection: $fromLang) {
                            ForEach(langs, id: \.self) { Text($0.uppercased()).tag($0) }
                        }.pickerStyle(.menu)
                        Image(systemName: "arrow.right")
                        Picker("To", selection: $toLang) {
                            ForEach(langs, id: \.self) { Text($0.uppercased()).tag($0) }
                        }.pickerStyle(.menu)
                    }

                    // Input
                    TextField("Enter text to translate…", text: $sourceText, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .padding(.top, 4)

                    // Translate button
                    Button {
                        Task { await doTranslate() }
                    } label: {
                        Label("Translate", systemImage: "textformat.alt")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(sourceText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isLoading)

                    // Output
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Result").font(.headline)
                        Text(resultText.isEmpty ? "—" : resultText)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(.thinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }

                    // History
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("History").font(.headline)
                            Spacer()
                            Button(role: .destructive) {
                                Task { if let uid = auth.user?.uid { await history.clear(uid: uid) } }
                            } label: { Label("Clear", systemImage: "trash") }
                            .disabled(history.items.isEmpty)
                        }

                        ForEach(history.items) { item in
                            HistoryRow(item: item)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("TranslateMe")
            .toolbar {
                if let email = auth.user?.email {
                    ToolbarItem(placement: .principal) {
                        Text(email).font(.caption)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Sign out") { auth.signOut() }
                }
            }
        }
    }

    private func doTranslate() async {
        guard let uid = auth.user?.uid else { return }
        let trimmed = sourceText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        isLoading = true
        defer { isLoading = false }

        do {
            let translated = try await translator.translate(text: trimmed, from: fromLang, to: toLang)
            resultText = translated

            let item = TranslationItem(
                id: nil,
                sourceText: trimmed,
                translatedText: translated,
                fromLang: fromLang,
                toLang: toLang,
                timestamp: Date(),
                uid: uid
            )
            history.save(uid: uid, item: item)
        } catch {
            resultText = "Translation failed: \(error.localizedDescription)"
        }
    }
}

struct HistoryRow: View {
    let item: TranslationItem
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("\(item.fromLang.uppercased()) → \(item.toLang.uppercased())")
                .font(.caption).foregroundStyle(.secondary)
            Text(item.sourceText).font(.callout)
            Text(item.translatedText).font(.body).bold()
            Text(item.timestamp.formatted(date: .abbreviated, time: .shortened))
                .font(.caption2).foregroundStyle(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
