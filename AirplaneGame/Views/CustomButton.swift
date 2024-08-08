//
//  CustomButton.swift
//  AirplaneGame
//
//  Created by Pavlo Kostenko on 07/08/2024.
//

import SwiftUI

struct CustomButton: View {
    var title: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 260, height: 80)
                    .background(Color(red: 1, green: 0.81, blue: 0.39))
                    .cornerRadius(61)
                Text(title)
                    .font(Font.custom("MochiyPopOne-Regular", size: 30))
                    .tracking(0.60)
                    .foregroundColor(Color(red: 0.59, green: 0.19, blue: 0.19))
            }
            .frame(width: 260, height: 80)
        }
    }
}

struct CustomButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomButton(title: "PLAY") { }
    }
}
