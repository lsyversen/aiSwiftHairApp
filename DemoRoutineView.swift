//
//  DemoRoutineView.swift
//  hairapp
//
//  Created by Liam Syversen on 10/13/24.
//

import SwiftUI

struct DemoRoutineView: View {
    var body: some View {
       Text("Hello")
        }
    }
    

struct RoutineItemViewDemo: View {
    var title: String
    var emoji: String
    var description: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(emoji)
                    .font(.largeTitle)
                    .padding(.trailing, 10)
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.white)
            }
            Text(description)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
                .padding(.horizontal, 2)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.gray.opacity(0.3))
        .cornerRadius(30)
        .padding(.horizontal, 2)
    }
}
