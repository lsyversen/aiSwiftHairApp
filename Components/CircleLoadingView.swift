//
//  CircleLoadingView.swift
//  hairapp
//
//  Created by Liam Syversen on 10/11/24.
//

import SwiftUI

struct CircleFlip: View {
    
    @State private var flipAnimation = 25
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(Color(#colorLiteral(red: 0, green: 0.5, blue: 0.3, alpha: 1)))
                .frame(width: 50, height: 50, alignment: .center)
                .offset(x: CGFloat(-flipAnimation))
                .zIndex(flipAnimation == 25 ? 1 : 0)
                .animation(.linear(duration: 0.5), value: flipAnimation)
            
            Circle()
                .foregroundColor(Color(#colorLiteral(red: 0, green: 0.9, blue: 0.6588235294, alpha: 1)))
                .frame(width: 50, height: 50, alignment: .center)
                .offset(x: CGFloat(flipAnimation))
                .zIndex(flipAnimation == 25 ? 0 : 1)
                .animation(.linear(duration: 0.5), value: flipAnimation)
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                withAnimation {
                    flipAnimation = flipAnimation == 25 ? -25 : 25
                }
            }
        }
    }
}

struct CircleFlip_Previews: PreviewProvider {
    static var previews: some View {
        CircleFlip()
            .preferredColorScheme(.dark)
    }
}
