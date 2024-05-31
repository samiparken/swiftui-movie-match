import SwiftUI
import Observation
import ComposableArchitecture

//MARK: - REDUCER
@Reducer
struct MainHeader {
  //MARK: - STATE
  @ObservableState
  struct State: Equatable {
    var isSettingsViewOn : Bool = false
  }
  //MARK: - ACTION
  enum Action {
    case refreshCardsToShow
    case showSettingsView(Bool)
  }
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .showSettingsView(isOn):
        state.isSettingsViewOn = isOn
        return .none
      case .refreshCardsToShow:
        return .none
      }
    }
  }
}


struct MainHeaderView: View {
  @Bindable var store: StoreOf<MainHeader>

  //MARK: - AppStorage
  @AppStorage(K.AppStorageKey.localeIdentifier) private var localeIdentifier: LocaleIdentifier = .English
  
  //MARK: - PROPERTIES
  var movieManager: MovieManager
  @Binding var colorScheme: ColorScheme
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
      .accentColor(Color(UIColor(colorScheme.getPrimaryColor())))
      
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
        //self.showSettingView.toggle()
        store.send(.showSettingsView(true))
      }){
        Image(systemName: "gearshape")
          .font(.system(size: 24, weight: .regular))
      }
      .accentColor(Color(UIColor(colorScheme.getPrimaryColor())))
      .sheet(isPresented: $store.isSettingsViewOn.sending(\.showSettingsView)) {
        SettingsView(colorScheme: $colorScheme)
      }
      
    }
    .padding()
  }
}

struct HeaderView_Previews: PreviewProvider {
  @State static var movieManager = MovieManager()
  @State static var colorScheme: ColorScheme = .light
  
  static var previews: some View {
    MainHeaderView(
      store: Store(initialState: MainHeader.State()) {
        MainHeader()
      }, movieManager: movieManager,
      colorScheme: $colorScheme)
    .previewLayout(.fixed(width: 375, height: 80))
  }
}
