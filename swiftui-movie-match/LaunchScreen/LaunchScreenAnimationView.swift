//
//  LaunchScreen.swift
//  swiftui-movie-match
//
//  Created by Han-Saem Park on 2024-06-17.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct LaunchScreenAnimationFeature {
  //MARK: - State
  @ObservableState
  struct State: Equatable {
    var isPresented = true
  }

  //MARK: - Action
  enum Action {
    case onScreen
    case offScreen
    
    case delegate(Delegate)
    enum Delegate: Equatable {
      case offLaunchScreen
    }
  }
  
  //MARK: - Reducer
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
              
      case .delegate:
        return .none

      case .onScreen:
        return .none
        
      case .offScreen:
        state.isPresented = false
        return .send(.delegate(.offLaunchScreen))
      }
    }
  }
}

struct LaunchScreenAnimationView: View {
  //MARK: - Store
  @Bindable var store: StoreOf<LaunchScreenAnimationFeature>

//MARK: - PROPERTIES
  @Environment(\.colorScheme) var colorScheme
  //@Binding var isPresented: Bool
  @State private var scale = CGSize(width:0.8, height: 0.8)
  @State private var opacity = 1.0

  //MARK: - BODY
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
        store.send(.offScreen)
      })
      
    }
  }
}

#Preview {
  LaunchScreenAnimationView(
    store: Store(initialState: LaunchScreenAnimationFeature.State(
      isPresented: true
    )){
      LaunchScreenAnimationFeature()
    }
  )
}
