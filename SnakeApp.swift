//
//  SnakeApp.swift
//  Snake
//
//  Created by Михаил Баранов on 06.07.2023.
//

import SwiftUI

@main
struct SnakeApp: App {
    @StateObject var appState = AppState.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView().id(appState.gameID)
        }
    }
}

class AppState: ObservableObject {
    static let shared = AppState()
    
    @Published var gameID = UUID()
}
