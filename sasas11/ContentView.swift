//
//  ContentView.swift
//  sasas11
//
//  Created by halfTime on 21/11/25.
//

import SwiftUI

// ПРОБЛЕМА 1: Класс с потенциальной утечкой памяти (retain cycle)
class DataManager {
    var name: String
    var onUpdate: (() -> Void)?

    init(name: String) {
        self.name = name
    }

    func setupCallback() {
        // УТЕЧКА ПАМЯТИ: self захватывается в замыкании без [weak self]
        onUpdate = {
            print("Data updated for \(self.name)")
        }
    }
}

struct ContentView: View {
    @State private var items: [String] = []

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)

            // ПРОБЛЕМА 2: SwiftLint - очень длинная строка кода которая превышает лимит в 120 символов и должна вызвать предупреждение от SwiftLint
            Text("Hello, world!")

            // ПРОБЛЕМА 3: использование count вместо isEmpty
            if items.count == 0 {
                Text("No items")
            }
        }
        .padding()
        .onAppear {
            let manager = DataManager(name: "Test")
            manager.setupCallback()
        }
    }
}

#Preview {
    ContentView()
}
