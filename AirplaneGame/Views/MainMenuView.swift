//
//  MainMenuView.swift
//  AirplaneGame
//
//  Created by Pavlo Kostenko on 07/08/2024.
//

import SwiftUI

struct MainMenuView: View {
    @EnvironmentObject var game: GameModel
    @State private var showingSettings = false
    @State private var showingAbout = false
    @State private var showingGame = false
    
    var body: some View {
        NavigationView {
            VStack {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .padding(.trailing, 60)
                
                CustomButton(title: "Play") {
                    showingSettings = false
                    showingAbout = false
                    game.resetGame()
                    showingGame = true
                }
                .background(NavigationLink(destination: GameView().environmentObject(game), isActive: $showingGame) { EmptyView() })
                .padding(.bottom, 30)
                
                CustomButton(title: "Settings") {
                    showingSettings.toggle()
                }
                .sheet(isPresented: $showingSettings) {
                    SettingsView()
                }
                .padding(.bottom, 30)
                
                CustomButton(title: "About") {
                    showingAbout.toggle()
                }
                .sheet(isPresented: $showingAbout) {
                    AboutView(highScore: game.highScore)
                }
            }
            .background(Image("background"))
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView().environmentObject(GameModel())
    }
}
