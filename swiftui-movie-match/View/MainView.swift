//
//  ContentView.swift
//  swiftui-movie-match
//
//  Created by Han-Saem Park on 2024-05-19.
//

import SwiftUI
import SwiftData

struct MainView: View {
  
  //MARK: - SwiftUIData
  //@Environment(\.modelContext) private var modelContext
  //@Query private var items: [Item]

  //MARK: - PROPERTIES
  @StateObject var movieManager = MovieManager()
  @GestureState private var dragState = DragState.inactive
  private var dragAreaThreshold: CGFloat = 65.0 // if it's less than 65 points, the card snaps back to its origianl place.
  @State private var lastCardIndex: Int = 1
  @State private var cardRemovalTransition = AnyTransition.trailingBottom
  
  //MARK: - BODY
  var body: some View {
    
    VStack {
      
      Spacer()
      
      ZStack{
        if movieManager.movieList.isEmpty {
          Text("Loading...")
        } else {
          ForEach(movieManager.movieList) { movie in
            MovieCardView(movie: movie)
            //zIndex
              .zIndex(movieManager.isTopMovieCard(movie) ? 1 : 0)
            // Drag offset
              .offset(x: movieManager.isTopMovieCard(movie)
                      ? self.dragState.translation.width : 0,
                      y: movieManager.isTopMovieCard(movie)
                      ? self.dragState.translation.height : 0)
            // Scale (before animation)
              .scaleEffect(movieManager.isTopMovieCard(movie)
                           && self.dragState.isDragging ? 0.85 : 1.0)
            //Rotation (before animation)
              .rotationEffect(Angle(degrees:
                                      movieManager.isTopMovieCard(movie)
                                    ? Double(self.dragState.translation.width / 12)
                                    : 0))
            //Animation (spring effect)
              .animation(.interpolatingSpring(stiffness: 120, damping: 120), value: dragState.isDragging)
            //Gesture
              .gesture(LongPressGesture(minimumDuration: 0.01)
                .sequenced(before: DragGesture())
                .updating(self.$dragState,
                          body: { (value, state, transaction) in
                switch value {
                case .first(true):
                  state = .pressing
                case .second(true, let drag):
                  state = .dragging(transition: drag?.translation ?? .zero)
                default:
                  break
                }
              }))
            
            
            
          }
        }
      }
      .padding(.horizontal)
      
      Spacer()
    }

  }
}

#Preview {
  MainView()
}
