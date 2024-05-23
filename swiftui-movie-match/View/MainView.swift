import SwiftUI
import SwiftData

struct MainView: View {
  
  // MARK: - SwiftData
  @Environment(\.modelContext) private var context
  @Query private var favoriteMovies: [FavoriteMovie]
  @AppStorage(K.AppStorageKey.appearanceMode) private var storedAppearanceMode: AppearanceMode = .system
  @AppStorage(K.AppStorageKey.localeIdentifier) private var localeIdentifier: LocaleIdentifier = .English
  
  //MARK: - PROPERTIES
  @StateObject var movieManager = MovieManager()
  @State var showSettingView: Bool = false
  @State var showFavoriteView: Bool = false
  @State var showMovieDetailView: Bool = false
  @State var colorScheme: ColorScheme?
  
  //MARK: - PRIVATE PROPERTIES
  @GestureState private var dragState = DragState.inactive
  private var dragAreaThreshold: CGFloat = 65.0 // if it's less than 65 points, the card snaps back to its origianl place.
  @State private var lastCardIndex: Int = 1
  @State private var cardRemovalTransition = AnyTransition.trailingBottom
  @State private var isClicked: [Int: Bool] = [:]
  
  //MARK: - METHOD
  private func updateColorScheme(for mode: AppearanceMode) {
    switch mode {
    case .system:
      colorScheme = .light //+TODO: get system colorScheme
    case .light:
      colorScheme = .light
    case .dark:
      colorScheme = .dark
    }
  }
  
  //MARK: - BODY
  var body: some View {
    
    VStack {
      Spacer()
      
      //MARK: - HEADER VIEW
      MainHeaderView(
        movieManager: movieManager,
        showSettingView: $showSettingView,
        colorScheme: $colorScheme)
      .opacity(dragState.isDragging ? 0.0 : 1.0)
      .animation(.default, value: dragState.isDragging)
      
      Spacer()
      
      //MARK: - MOVIE CARD VIEW
      ZStack{
        if movieManager.movieCardsToShow.isEmpty {
          VStack {
            Spacer()
            ProgressView() // A spinner or loading indicator
              .frame(minWidth: 20, maxWidth: .infinity)
            Spacer()
          }
        } else {
          
          ForEach(movieManager.movieCardsToShow) { movie in
            MainCardView(
              movie: movie,
              isClicked: Binding(
                get: { isClicked[movie.id] ?? false },
                set: { isClicked[movie.id] = $0 }
              )
            )
            //zIndex
            .zIndex(movieManager.isTopMovieCard(movie) ? 1 : 0)
            // Show Symbol
            .overlay(
              ZStack {
                // X-MARK SYMBOL
                Image(systemName: "x.circle")
                  .modifier(SymbolModifier())
                  .opacity(self.dragState.translation.width < -self.dragAreaThreshold
                           && movieManager.isTopMovieCard(movie) ? 1.0 : 0.0)
                // HEART SYMBOL
                Image(systemName: "heart.circle")
                  .modifier(SymbolModifier())
                  .opacity(self.dragState.translation.width > self.dragAreaThreshold
                           && movieManager.isTopMovieCard(movie) ? 1.0 : 0.0)
              }
            )
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
            })
                     // While doing gesture
              .onChanged({(value) in
                guard case .second(true, let drag?) = value else { return }
                if drag.translation.width < -self.dragAreaThreshold {
                  self.cardRemovalTransition = .leadingBottom
                } else if drag.translation.width > self.dragAreaThreshold {
                  self.cardRemovalTransition = .trailingBottom
                }
              })
                     // End of Gesture - Action
              .onEnded({ (value) in
                guard case .second(true, let drag?) = value else { return }
                if drag.translation.width < -self.dragAreaThreshold {
                  movieManager.removeTopMovieCardAndReload()
                } else if drag.translation.width > self.dragAreaThreshold {
                  movieManager.addMovieCardToFavorite(movie)
                }
              })
            )
            // transition after the gesture
            .transition(self.cardRemovalTransition)
            
          }
        }
      }
      .padding(.horizontal, 13)
      
      Spacer()
      
      //MARK: - FOOTER VIEW
      MainFooterView(
        showFavoriteView: $showFavoriteView,
        showMovieDetailView: $showMovieDetailView)
      .opacity(dragState.isDragging ? 0.0 : 1.0)
      .animation(.default, value: dragState.isDragging)
      
      Spacer()
      
    }
    .preferredColorScheme(colorScheme)
    .onAppear {
      // for SwiftData in MovieManager
      movieManager.context = context
      movieManager.fetchFavoriteMovies()
      movieManager.getPopularMovieList(localeIdentifier: localeIdentifier)
      // apply appearanceMode
      updateColorScheme(for: storedAppearanceMode)
      // apply localization
    }
    .environment(\.locale, Locale.init(identifier: localeIdentifier.rawValue))
  }
}

#Preview {
  MainView()
    .modelContainer(for: FavoriteMovie.self, inMemory: true)
}
