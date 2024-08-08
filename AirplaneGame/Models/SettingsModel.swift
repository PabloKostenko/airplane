//
//  SettingsModel.swift
//  AirplaneGame
//
//  Created by Pavlo Kostenko on 07/08/2024.
//

import Foundation

class SettingsModel: ObservableObject {
    @Published var isMusicOn: Bool
    @Published var isSoundOn: Bool
    
    init(isMusicOn: Bool = true, isSoundOn: Bool = true) {
        self.isMusicOn = isMusicOn
        self.isSoundOn = isSoundOn
    }
}
