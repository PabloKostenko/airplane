//
//  GameView.swift
//  AirplaneGame
//
//  Created by Pavlo Kostenko on 07/08/2024.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var game: GameModel
    @State private var timer: Timer?
    @State private var showingMainMenu: Bool = false

    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .edgesIgnoringSafeArea(.all)

            VStack {
                HStack {
                    Text("Time: \(Int(game.timeElapsed))s")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding()

                    Text("Score: \(game.score)")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding()
                }
                .padding(.top, 10)

                Spacer()
            }

            AirplaneView(position: $game.airplanePosition, isHit: $game.isAirplaneHit)

            ForEach(game.obstacles.indices, id: \.self) { index in
                if game.obstacles[index].isVisible {
                    ObstacleView(position: game.obstacles[index].position)
                }
            }

            ForEach(game.fuels.indices, id: \.self) { index in
                if game.fuels[index].isVisible {
                    FuelView(position: game.fuels[index].position)
                }
            }

            if game.isGameOver {
                VStack {
                    Text("Game Over")
                        .font(.largeTitle)
                        .foregroundColor(.red)

                    Text("Score: \(game.score)")
                        .font(.title)
                        .foregroundColor(.white)

                    Text("Time: \(Int(game.timeElapsed))s")
                        .font(.title)
                        .foregroundColor(.white)

                    HStack {
                        Button(action: {
                            game.resetGame()
                        }) {
                            Text("Restart")
                                .font(Font.custom("MochiyPopOne-Regular", size: 24))
                                .padding()
                                .background(Color(red: 1, green: 0.81, blue: 0.39))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }

                        Button(action: {
                            showingMainMenu = true
                        }) {
                            Text("Menu")
                                .font(Font.custom("MochiyPopOne-Regular", size: 24))
                                .padding()
                                .background(Color(red: 1, green: 0.81, blue: 0.39))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                }
                .padding()
                .background(Color.black.opacity(0.7))
                .cornerRadius(20)
                .fullScreenCover(isPresented: $showingMainMenu, content: {
                    MainMenuView().environmentObject(game)
                })
            }
        }
        .contentShape(Rectangle())
        .gesture(DragGesture()
            .onChanged { value in
                let newY = min(max(value.location.y, 50), UIScreen.main.bounds.height - 50)
                game.airplanePosition.y = newY
            })
        .onAppear {
            startGame()
        }
        .onDisappear {
            stopGame()
        }
        .navigationBarBackButtonHidden(true)
    }

    func startGame() {
        stopGame()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            game.updateGame()
        }
    }

    func stopGame() {
        timer?.invalidate()
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView().environmentObject(GameModel())
    }
}

