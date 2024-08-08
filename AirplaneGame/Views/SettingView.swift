//
//  SettingView.swift
//  AirplaneGame
//
//  Created by Pavlo Kostenko on 08/08/2024.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var game: GameModel
    @State private var musicOn: Bool {
        didSet {
            UserDefaults.standard.set(musicOn, forKey: "MusicOn")
            game.updateBackgroundMusic(musicOn)
        }
    }
    @State private var soundOn: Bool {
        didSet {
            UserDefaults.standard.set(soundOn, forKey: "SoundOn")
            game.updateSoundEffects(soundOn)
        }
    }
    
    @Environment(\.presentationMode) var presentationMode
    
    init() {
        _musicOn = State(initialValue: UserDefaults.standard.bool(forKey: "MusicOn"))
        _soundOn = State(initialValue: UserDefaults.standard.bool(forKey: "SoundOn"))
    }
    
    var body: some View {
        VStack {
            Toggle(isOn: $musicOn) {
                Text("Music")
                    .font(Font.custom("MochiyPopOne-Regular", size: 24))
                    .foregroundColor(Color(red: 0.59, green: 0.19, blue: 0.19))
            }
            .padding()
            
            Toggle(isOn: $soundOn) {
                Text("Sound Effects")
                    .font(Font.custom("MochiyPopOne-Regular", size: 24))
                    .foregroundColor(Color(red: 0.59, green: 0.19, blue: 0.19))
            }
            .padding()

            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                CustomButton(title: "Close") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .padding(.bottom)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView().environmentObject(GameModel())
    }
}
