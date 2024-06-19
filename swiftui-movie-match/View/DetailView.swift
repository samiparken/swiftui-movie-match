import SwiftUI
import SwiftData
import Observation
import ComposableArchitecture

@Reducer
struct DetailFeature {
  //MARK: - State
  @ObservableState
  struct State: Equatable {

  }
  
  //MARK: - Action
  enum Action {
    
  }
  
  //MARK: - Reducer
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      default:
        return .none
      }
    }
  }
}

struct DetailView: View {
  //MARK: - TCA store
  @Bindable var store: StoreOf<DetailFeature>

  //MARK: - Navigation Stack
  @Binding var navStack: [NavRoute]
  
  // MARK: - SwiftData
  @Environment(\.modelContext) private var context
  @Query private var favoriteMovies: [FavoriteMovie]
  
  //MARK: - PROPERTIES
  @Environment(\.colorScheme) var colorScheme
  @State private var movieDetail: MovieDetail?
  @State private var isLoading = true
  @State private var isError = false
  @State private var isClicked = false
  var movieManager = MovieManager()
  let favoriteMovie: FavoriteMovie
  
  //MARK: - METHOD
  private func getMovieDetail() async {
    if let movieDetail = await movieManager.getMovieDetail(
      id: favoriteMovie.id,
      languageCode: favoriteMovie.language ) {
      self.movieDetail = movieDetail
      isLoading = false
    } else {
      isError = true
      isLoading = false
    }
  }
  
  //MARK: - INIT
  init(store: StoreOf<DetailFeature>,
       navStack: Binding<[NavRoute]>,
       movieManager: MovieManager,
       favoriteMovie: FavoriteMovie) {
    self.store = store
    self._navStack = navStack
    self.movieManager = movieManager
    self.favoriteMovie = favoriteMovie
  }
  
  //MARK: - BODY
  var body: some View {
    
    //MARK: - HEADER
    ZStack(alignment: .center) {
      
      // BACK Button
      HStack{
        HeaderBackButton(){
          navStack.removeLast()
        }
        Spacer()
      }
      
      // TITLE
      HeaderTitleText(icon: "", text: "details-string")
    }
    .padding()
    
    VStack {
      if isLoading {
        VStack {
          Spacer()
          ProgressView() // A spinner or loading indicator
            .frame(minWidth: 20, maxWidth: .infinity)
          Spacer()
        }
      } else if isError {
        VStack {
          Spacer()
          Text("Failed to load movie detail")
          Spacer()
        }
      } else if let movieDetail = movieDetail {
        
        //MARK: - DETAILED CARD VIEW
        DetailCardView(movieDetail: movieDetail, isClicked: $isClicked)
        
        Spacer()
        
        //MARK: - REMOVE BUTTON
        Button(action:{
          if let indexToDelete = favoriteMovies.firstIndex(where: {$0.id == favoriteMovie.id}) {
            context.delete(favoriteMovies[indexToDelete])
          }
          movieManager.refreshWidget()
          navStack.removeLast()
        }) {
          Text("remove-string")
            .textCase(.uppercase)
            .modifier(ButtonRemoveModifier())
            .padding(.top, 5)
            .padding(.horizontal, 20)
        }
        
        //MARK: - CLOSE BUTTON
        Button(action:{
          navStack.removeLast()
        }) {
          Text("close-string")
            .textCase(.uppercase)
            .modifier(ButtonCloseModifier())
            .accentColor(Color(UIColor(colorScheme == .dark
                                       ? .tertiaryColor
                                       : .primaryColor)))
            .background(
              Capsule().stroke(Color(UIColor(colorScheme == .dark
                                             ? .tertiaryColor
                                             : .primaryColor)), lineWidth: 2)
            )
            .padding(.top, 5)
            .padding(.horizontal, 20)
        }
        
        Spacer()
      }
    }
    .task {
      await getMovieDetail()
    }
    
    Spacer()
  }
}

//MARK: - PREVIEW
struct DetailView_Previews: PreviewProvider {
  static var previews: some View {
    DetailView(
      store: Store(initialState: DetailFeature.State()){
        DetailFeature()
      },
       navStack: .constant([]),
       movieManager: MovieManager(),
       favoriteMovie: SampleData.favoriteMovie)
  }
}
