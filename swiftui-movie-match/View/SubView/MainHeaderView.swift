import SwiftUI
import Observation
import ComposableArchitecture

//MARK: - REDUCER
@Reducer
struct MainHeaderFeature {

  //MARK: - STATE
  @ObservableState
  struct State: Equatable {
    @Presents var settingsView: SettingsFeature.State?

    @Shared(.appStorage(K.AppStorageKey.appearanceMode)) var appearanceMode : AppearanceMode = .system
    
    var colorScheme: ColorScheme {
      get {
        switch appearanceMode {
        case .light:
          return .light
        case .dark:
          return .dark
        default:
          return .light
        }
      }
    }
    
  }

  //MARK: - ACTION
  enum Action {
    case settingsView(PresentationAction<SettingsFeature.Action>) //present settingsView (child)
    case showSettingsView
  }

//MARK: - REDUCER
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
        
      case .settingsView:
        return .none
      case .showSettingsView:
        state.settingsView = SettingsFeature.State()
        return .none
        
      }
    }
    // child View
    .ifLet(\.$settingsView, action: \.settingsView) {  SettingsFeature() }
  }
}


//MARK: - VIEW
struct MainHeaderView: View {
  //MARK: - Navigation Stack
  @Binding var navStack: [Routes]
  
  //MARK: - TCA store
  @Bindable var store: StoreOf<MainHeaderFeature>

  //MARK: - AppStorage
  @AppStorage(K.AppStorageKey.localeIdentifier) private var localeIdentifier: LocaleIdentifier = .English
  
  //MARK: - PROPERTIES
  var movieManager: MovieManager
  @State var showSettingView: Bool = false
  let haptics = UINotificationFeedbackGenerator()
  
  //MARK: - BODY
  var body: some View {
    
      HStack {
        
        //REFRESH BUTTON
        Button(action: {
          self.haptics.notificationOccurred(.success)
          movieManager.refreshPopularMovieList()
        }) {
          Image(systemName: "arrow.clockwise")
            .font(.system(size: 24, weight: .regular))
        }
        .accentColor(Color(UIColor(store.colorScheme.getPrimaryColor())))
        
        Spacer()
        
        // LOGO
        Image(K.Image.Logo.altShort)
          .resizable()
          .scaledToFit()
          .frame(height: 28)
        
        Spacer()
        
        // SETTINGS BUTTON
        Button(action: {
          self.haptics.notificationOccurred(.success)
          navStack.append(.settingsView)
        }){
          Image(systemName: "gearshape")
            .font(.system(size: 24, weight: .regular))
        }
        .accentColor(Color(UIColor(store.colorScheme.getPrimaryColor())))
        
      }
      .padding()
      //present SettingsView (child)
      .sheet(
        item: $store.scope(state: \.settingsView, action: \.settingsView)
      ) { settingsStore in
        SettingsView(navStack:$navStack, store: settingsStore)
      }
    
  }
}

struct HeaderView_Previews: PreviewProvider {
  @State static var movieManager = MovieManager()
  @State static var colorScheme: ColorScheme = .light
  
  static var previews: some View {
    MainHeaderView(navStack: .constant([]),
                   store: Store(initialState: MainHeaderFeature.State()) {
      MainHeaderFeature()
        ._printChanges()
    },
                   movieManager: movieManager)
    .previewLayout(.fixed(width: 375, height: 80))
  }
}
