//
//  PolarisApp.swift
//  POLARIS ARENA
//
//  Main app entry point
//

import SwiftUI

// ПРОБЛЕМА 1: Класс с утечкой памяти (retain cycle)
class TestManager {
    var name: String
    var delegate: TestDelegate?  // ПРОБЛЕМА: delegate без weak!

    // ПРОБЛЕМА: stored closure без capture list
    var onUpdate: (() -> Void)? = {
        print("Update called")
    }

    init(name: String) {
        self.name = name
    }

    func setupCallback(_ callback: @escaping () -> Void) {
        // ПРОБЛЕМА: @escaping closure использует self без [weak self]
        onUpdate = {
            print("Data updated for \(self.name)")
            callback()
        }
    }
}

protocol TestDelegate {
    func didUpdate()
}

@main
struct PolarisApp: App {
    @State private var testItems: [String] = []

    init() {
        // Setup
        setupAppearance()

        // Инициализируем тестовый менеджер (с утечкой памяти)
        let manager = TestManager(name: "Test")
        manager.setupCallback {
            print("Callback")
        }
    }

    var body: some Scene {
        WindowGroup {
            MenuView()
                .preferredColorScheme(.dark)  // Default to dark mode
                .onAppear {
                    // ПРОБЛЕМА 2: использование count вместо isEmpty
                    if testItems.count == 0 {
                        print("No items")
                    }

                    // ПРОБЛЕМА 3: очень длинная строка
                    let veryLongVariableNameThatExceedsTheLineLength = "This is a very long string that should trigger a line length warning from SwiftLint"
                    print(veryLongVariableNameThatExceedsTheLineLength)
                }
        }
    }

    private func setupAppearance() {
        // Configure navigation bar appearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white.withAlphaComponent(0.95)
        ]
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white.withAlphaComponent(0.95)
        ]

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}
