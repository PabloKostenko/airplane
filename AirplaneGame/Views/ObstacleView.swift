//
//  ObstacleView.swift
//  AirplaneGame
//
//  Created by Pavlo Kostenko on 07/08/2024.
//

import SwiftUI

struct ObstacleView: View {
    var position: CGPoint
    
    var body: some View {
        Image("cloud")
            .resizable()
            .frame(width: 90, height: 90)
            .position(position)
    }
}

struct ObstacleView_Previews: PreviewProvider {
    static var previews: some View {
        ObstacleView(position: CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2))
    }
}


