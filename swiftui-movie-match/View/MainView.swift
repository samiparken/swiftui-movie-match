import SwiftUI
import SwiftData
import Observation
import ComposableArchitecture

@Reducer
struct MainFeature {
  
  //MARK: - State
  @ObservableState
  struct State: Equatable {
    
    //MARK: - AppStorage
    @Shared(.appStorage(K.AppStorageKey.appearanceMode)) var appearanceMode : AppearanceMode = .system
    @Shared(.appStorage(K.AppStorageKey.localeIdentifier)) var localeIdentifier: LocaleIdentifier = .English
    
    var colorScheme: ColorScheme {
      get {
        switch appearanceMode {
        case .dark:
          return .dark
        default:
          return .light
        }
      }
    }
    
    var numOfFavoriteMovies = 0
    var isLaunchScreenPresented = true
  }
  
  //MARK: - Action
  enum Action {
    case saveMovieToFavorite
    case passMovie
    case offLaunchScreen
  }
  
  //MARK: - Reducer
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
        
      case .saveMovieToFavorite:
        state.numOfFavoriteMovies += 1
        return .none
        
      case .passMovie:
        return .none
        
      case .offLaunchScreen:
        state.isLaunchScreenPresented = false
        return .none
              
      }
    }
  }
}

struct MainView: View {
  //MARK: - TCA store
  @Bindable var store: StoreOf<MainFeature>
  
  //MARK: - Navigation Stack
  @Binding var navStack: [NavRoute]
  
  // MARK: - SwiftData
  @Environment(\.modelContext) private var context
  
  //MARK: - PROPERTIES
  var movieManager = MovieManager()
  @GestureState private var dragState = DragState.inactive
  @State private var cardRemovalTransition = AnyTransition.trailingBottom
  @State private var isClicked: [Int: Bool] = [:]
  private let dragAreaThreshold: CGFloat = 65.0 // if it's less than 65 points, the card snaps back to its origianl place.
  @State private var isLaunchScreenPresented = true
  
  //MARK: - INIT
  init(store: StoreOf<MainFeature>,
       navStack: Binding<[NavRoute]>,
       movieManager: MovieManager) {
    self.store = store
    self._navStack = navStack
    self.movieManager = movieManager
  }
  
  //MARK: - BODY
  var body: some View {
        
    ZStack {
    
      //MARK: - MAIN VIEW
      VStack {
        Spacer()
        
        //MARK: - HEADER VIEW
        MainHeaderView(navStack: $navStack,
                       store: Store(initialState: MainHeaderFeature.State()){
          MainHeaderFeature()
        },
                       movieManager: movieManager)
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
              .accessibility(identifier: "movieCard_\(movieManager.isTopMovieCard(movie) ? 1 : 0)")
              
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
        MainFooterView(store: Store(initialState: MainFooterFeature.State()){
          MainFooterFeature()
        }, navStack: $navStack)
        .opacity(dragState.isDragging ? 0.0 : 1.0)
        .animation(.default, value: dragState.isDragging)
        
        Spacer()
        
      }
      .preferredColorScheme(store.colorScheme)
      .environment(\.locale, Locale.init(identifier: store.localeIdentifier.rawValue))
      .onAppear {
        // for SwiftData in MovieManager
        movieManager.context = context
        movieManager.fetchFavoriteMovies()
        movieManager.getPopularMovieList(languageCode: store.localeIdentifier.rawValue)
      }
            
      //MARK: - LAUNCH SCREEN ANIMATION
      if store.isLaunchScreenPresented {
        LaunchScreenAnimationView(
          store: Store(initialState: LaunchScreenAnimationFeature.State(
          isPresented: store.isLaunchScreenPresented
        )){
         LaunchScreenAnimationFeature()
        })
      }
    }

  }
}

//MARK: - PREVIEW
#Preview {
  MainView(store: Store(initialState: MainFeature.State()) {
    MainFeature()._printChanges()
  },
           navStack: .constant([]),
           movieManager: MovieManager())
}
