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
              .zIndex(movieManager.isTopMovieCard(movie) ? 1 : 0)
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
