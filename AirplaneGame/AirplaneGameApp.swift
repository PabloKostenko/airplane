//
//  ContentView.swift
//  AirplaneGame
//
//  Created by Pavlo Kostenko on 07/08/2024.
//
import SwiftUI

@main
struct AirplaneGameApp: App {
    @StateObject private var gameModel = GameModel()
    
    var body: some Scene {
        WindowGroup {
            MainMenuView()
                .environmentObject(gameModel)
        }
    }
}
