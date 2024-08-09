//
//  AboutView.swift
//  AirplaneGame
//
//  Created by Pavlo Kostenko on 07/08/2024.
//

import SwiftUI

struct AirplaneView: View {
    @Binding var position: CGPoint
    @Binding var isHit: Bool
    
    var body: some View {
        Image("airplane")
            .resizable()
            .frame(width: 100, height: 60)
            .position(position)
            .background(
                isHit ? Color.green.opacity(0.3) : Color.clear
            )
            .onChange(of: isHit) { newValue in
                if newValue {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        isHit = false
                    }
                }
            }
    }
}

struct AirplaneView_Previews: PreviewProvider {
    static var previews: some View {
        AirplaneView(position: .constant(CGPoint(x: 50, y: UIScreen.main.bounds.height / 2)), isHit: .constant(false))
    }
}




