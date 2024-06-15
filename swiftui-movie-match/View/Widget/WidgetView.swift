//
//  WidgetView.swift
//  swiftui-movie-match
//
//  Created by Han-Saem Park on 2024-06-15.
//

import SwiftUI

enum WidgetSize {
  case small, medium, large
}

@Observable
class FavoriteMovieViewModel: ObservableObject {
  var favoriteMovie: FavoriteMovie
  
  init(favoriteMovie: FavoriteMovie) {
    self.favoriteMovie = favoriteMovie
  }
}

//MARK: - VIEW
struct WidgetView: View {
  @EnvironmentObject var movieViewModel: FavoriteMovieViewModel
  let widgetSize: WidgetSize
      
  //MARK: - BODY
  var body: some View {

    ZStack{
      switch widgetSize {
      case .small:
        WidgetImage(movie: movieViewModel.favoriteMovie)
      case .medium:
        WidgetImage(movie: movieViewModel.favoriteMovie)
      case .large:
        WidgetImage(movie: movieViewModel.favoriteMovie)
      }
            
    }

  }
}

//MARK: - PREVIEW
struct WidgetView_Previews: PreviewProvider {
  static var previews: some View {
    let sampleFavoriteMovie = FavoriteMovie(
      id: 1,
      posterPath: "/tMefBSflR6PGQLv7WvFPpKLZkyk.jpg",
      releaseDate: "2024-03-27",
      title: "Godzilla x Kong: The New Empire",
      originalTitle: "Godzilla x Kong: The New Empire",
      overview: "Following their explosive showdown, Godzilla and Kong must reunite against a colossal undiscovered threat hidden within our world, challenging their very existence – and our own.",
      voteAverage: 7.222,
      savedAt: Date(),
      language: "en"
    )
    
    let viewModel = FavoriteMovieViewModel(favoriteMovie: sampleFavoriteMovie)
    
    WidgetView(widgetSize: .small)
      .environment(viewModel)
  }
}
