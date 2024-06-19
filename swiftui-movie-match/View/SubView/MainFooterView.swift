import SwiftUI
import SwiftData
import ComposableArchitecture

//MARK: - REDUCER
@Reducer
struct MainFooterFeature {
  //MARK: - STATE
  @ObservableState
  struct State: Equatable {
    var isFavoriteViewOn: Bool = false
  }
  //MARK: - ACTION
  enum Action {
    case showFavoriteView(Bool)
  }
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .showFavoriteView(isOn):
        state.isFavoriteViewOn = isOn
        return .none
      }
    }
  }
}

//MARK: - VIEW
struct MainFooterView: View {
  //MARK: - TCA store
  @Bindable var store: StoreOf<MainFooterFeature>
  
  //MARK: - Navigation Stack
  @Binding var navStack: [NavRoute]
  
  //MARK: - PROPERTIES
  @Environment(\.colorScheme) var colorScheme
  @Environment(\.modelContext) private var context
  @Query private var favoriteMovies: [FavoriteMovie]
  
  let haptics = UINotificationFeedbackGenerator()
  
  //MARK: - INIT
  init(store: StoreOf<MainFooterFeature>, navStack: Binding<[NavRoute]>) {
    self.store = store
    self._navStack = navStack
  }
  
  //MARK: - BODY
  var body: some View {
    HStack {
      Image(systemName: "xmark.circle")
        .font(.system(size:42, weight: .light))
        .foregroundColor(colorScheme.getPrimaryColor())
      
      Spacer()
      
      ZStack {
        Button(action:{
          // ACTION
          self.haptics.notificationOccurred(.success)
          navStack.append(.favoriteView)
        }) {
          Text("showFavorite-string")
            .textCase(.uppercase)
            .font(.system(.subheadline, design:.rounded))
            .fontWeight(.heavy)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .accentColor(Color(UIColor(colorScheme.getPrimaryColor())))
            .background(
              Capsule().stroke(Color(UIColor(colorScheme.getPrimaryColor())), lineWidth: 2)
            )
        }
        .accessibility(identifier: K.UITests.Identifier.showFavoriteButton)
        
        // Badge
        if favoriteMovies.count > 0 {
          Text("\(favoriteMovies.count)")
            .font(.caption)
            .foregroundColor(.white)
            .padding(favoriteMovies.count >= 10 ? 6 : 8)
            .background(Color.pink)
            .clipShape(Circle())
            .offset(x: 80, y: -20)
        }
      }
      
      Spacer()
      
      Image(systemName: "heart.circle")
        .font(.system(size: 42, weight: .light))
        .foregroundColor(colorScheme.getPrimaryColor())
      
    }
    .padding()
  }
}

#Preview {
  MainFooterView(store: Store(initialState: MainFooterFeature.State()) {
    MainFooterFeature()
  }, navStack: .constant([]))
}

