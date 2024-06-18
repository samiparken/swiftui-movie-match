//
//  LaunchScreen.swift
//  swiftui-movie-match
//
//  Created by Han-Saem Park on 2024-06-17.
//

import SwiftUI

struct LaunchScreenAnimationView: View {
  @Environment(\.colorScheme) var colorScheme
  @Binding var isPresented: Bool
  @State private var scale = CGSize(width:0.8, height: 0.8)
  @State private var opacity = 1.0
  
  var body: some View {
    ZStack {
      
      // background color
      switch(colorScheme) {
      case .dark:
        Color.black.ignoresSafeArea()
      default:
        Color.white.ignoresSafeArea()
      }
      
      // Logo
      Image(K.Image.Logo.primaryFull)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 200, height: 133)
        .scaleEffect(scale)
            
    }
    .opacity(opacity)
    .onAppear {
            
      // Animation
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
        withAnimation (.easeInOut(duration: 1.5)) {
          scale = CGSize(width: 50, height: 50)
          opacity = 0.0
        }
      })
                                    
      // Off LaunchScreenAnimation
      DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: {
        isPresented.toggle()
      })
      
    }
  }
}

#Preview {
  LaunchScreenAnimationView(isPresented: .constant(true))
}
