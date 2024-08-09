//
//  FuelView.swift
//  AirplaneGame
//
//  Created by Pavlo Kostenko on 07/08/2024.
//

import SwiftUI

struct FuelView: View {
    var position: CGPoint
    
    var body: some View {
        Image("fuel")
            .resizable()
            .frame(width: 70, height: 70)
            .position(position)
    }
}

struct FuelView_Previews: PreviewProvider {
    static var previews: some View {
        FuelView(position: CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2))
    }
}
