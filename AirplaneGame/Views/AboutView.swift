//
//  AboutView.swift
//  AirplaneGame
//
//  Created by Pavlo Kostenko on 08/08/2024.
//
import SwiftUI

struct AboutView: View {
    var highScore: Int
    @EnvironmentObject var game: GameModel
    @Environment(\.presentationMode) var presentationMode
    
    private var longestPlayTime: TimeInterval {
        return UserDefaults.standard.double(forKey: "LongestPlayTime")
    }
    
    var body: some View {
        VStack {
            Text("About the Game")
                .font(Font.custom("MochiyPopOne-Regular", size: 30))
                .tracking(0.60)
                .foregroundColor(Color(red: 0.59, green: 0.19, blue: 0.19))
            
            Text("Collect fuel to earn additional points and avoid clouds to continue flying.")
                .font(.title)
                .padding()
            
            Text("Records")
                .font(Font.custom("MochiyPopOne-Regular", size: 30))
                .tracking(0.60)
                .foregroundColor(Color(red: 0.59, green: 0.19, blue: 0.19))
            
            Text("High Score: \(highScore)")
                .font(.title)
                .padding()
            
            Text("Longest Play Time: \(formattedTime(longestPlayTime))")
                .font(.title)
                .padding()
            
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                CustomButton(title: "Close") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .padding(.top, 30)
        }
        .padding()
    }
    
    private func formattedTime(_ timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView(highScore: 0).environmentObject(GameModel())
    }
}
