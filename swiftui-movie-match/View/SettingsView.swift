import SwiftUI
import ComposableArchitecture

@Reducer
struct SettingsFeature {
  
  //MARK: - State
  @ObservableState
  struct State: Equatable {
    //MARK: - AppStorage
    @Shared(.appStorage(K.AppStorageKey.appearanceMode)) var appearanceMode : AppearanceMode = .system
    @Shared(.appStorage(K.AppStorageKey.localeIdentifier)) var localeIdentifier: LocaleIdentifier = .English
    
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
    var selectedLanguage: String?
    var selectedColor: Color = .primaryColor
    var backgroundColor: Color = Color.white
  }

  //MARK: - Action
  enum Action {
    case refreshAppearanceMode
    case refreshLanguage
    
    case changeAppearanceMode(AppearanceMode)
    case changeLanguage(String?)
    case closeSettingsView
  }
  
  //MARK: - Reducer
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .refreshAppearanceMode:
        switch state.appearanceMode {
        case .light:
          //state.colorScheme = .light
          state.selectedColor = .primaryColor
          state.backgroundColor = Color.white
        case .dark:
          //state.colorScheme = .dark
          state.selectedColor = .tertiaryColor
          state.backgroundColor = Color.black
        default:
          //state.colorScheme = .light
          state.selectedColor = .primaryColor
          state.backgroundColor = Color.white
        }
        return .none
        
      case .refreshLanguage:
        switch state.localeIdentifier {
        case .English:
          state.selectedLanguage = K.SettingsView.Language.english
        case .Swedish:
          state.selectedLanguage = K.SettingsView.Language.swedish
        case .Korean:
          state.selectedLanguage = K.SettingsView.Language.korean
        }
        return .none
        
      case let .changeAppearanceMode(selectedMode):
        state.appearanceMode = selectedMode
        return .none
      
      case let .changeLanguage(selectedLanguage):
        state.selectedLanguage = selectedLanguage
        switch selectedLanguage {
        case K.SettingsView.Language.english:
          state.localeIdentifier = .English
        case K.SettingsView.Language.swedish:
          state.localeIdentifier = .Swedish
        case K.SettingsView.Language.korean:
          state.localeIdentifier = .Korean
        default:
          state.localeIdentifier = .English
        }
        return .none
                
      case .closeSettingsView:

        return .none
        
      }
    }
  }
}

struct SettingsView: View {
  //MARK: - Navigation Stack
  @Binding var navStack: [NavRoute]

  //MARK: - TCA store
  @Bindable var store: StoreOf<SettingsFeature>
    
  //MARK: - BODY
  var body: some View {
    VStack (alignment:.center, spacing: 0) {
      //HeaderSwipeBar()
      
      //MARK: - HEADER
      ZStack {
        // BACK Button
        HStack{
          HeaderBackButton(){
            navStack.removeLast()
          }
          Spacer()
        }
        
        // HEADER TITLE
        HeaderTitleText(icon: "gearshape", text: "settings-string")
      }
      .padding()
            
      //MARK: - APPEARANCE
      VStack(alignment:.leading, spacing: 10) {
        VStack {
          Divider()
            .padding(.top,20)
          VStack {
            Text("appearance-string")
              .foregroundColor(store.selectedColor)
              .font(.title3)
              .fontWeight(.bold)
              .padding(.top, 10)
              .padding(.bottom, 20)
            
            HStack (alignment:.center, spacing: 40) {
              //+TODO: apply system colorScheme
              
              //LIGHT mode
              Button(action:{
                store.send(.changeAppearanceMode(.light))
                store.send(.refreshAppearanceMode)
              }){
                Text("light-string")
                  .modifier(ButtonSettingsModifier())
                  .background(
                    Capsule().fill(
                      store.colorScheme == .light
                      ? store.selectedColor
                      : Color.clear
                    )
                  )
                  .overlay(
                    Capsule().stroke(
                      store.colorScheme == .light
                      ? Color.clear
                      : store.selectedColor,
                      lineWidth: 2
                    )
                  )
                  .foregroundColor(store.colorScheme == .light ? Color.white : store.selectedColor)
              }
              
              // DARK mode
              Button(action:{
                store.send(.changeAppearanceMode(.dark))
                store.send(.refreshAppearanceMode)
              }){
                Text("dark-string")
                  .textCase(.uppercase)
                  .modifier(ButtonSettingsModifier())
                  .background(
                    Capsule().fill(
                      store.colorScheme == .light
                      ? Color.clear
                      : store.selectedColor
                    )
                  )
                  .overlay(
                    Capsule().stroke(store.colorScheme == .light
                                     ? store.selectedColor
                                     : Color.clear, lineWidth: 2)
                  )
                  .foregroundColor(store.colorScheme == .light
                                   ? store.selectedColor
                                   : Color.black)
              }
            }
          }
        }
      }
      .padding(.horizontal)
      
      //MARK: - LANGUAGE SELECTOR
      VStack(alignment:.center, spacing: 10) {
        Divider()
        Text("Language")
          .foregroundColor(store.selectedColor)
          .font(.title3)
          .fontWeight(.bold)
          .padding(.top, 10)
          .padding(.bottom, 20)
        
        List(K.SettingsView.languageList, 
             id: \.self,
             selection: $store.selectedLanguage.sending(\.changeLanguage)) { language in
          HStack {
            Text(language)
              .foregroundColor( language == store.selectedLanguage
                                ? store.backgroundColor
                                : store.selectedColor)
              .fontWeight(.semibold)
              .padding(.leading, 10)
            Spacer()
            if language == store.selectedLanguage {
              Image(systemName: "checkmark")
                .foregroundColor(store.backgroundColor)
                .fontWeight(.semibold)
                .padding(.trailing, 10)
            }
          }
          .listRowBackground(
            Capsule()
              .fill( language == store.selectedLanguage
                    ? store.selectedColor
                    : Color.clear))
        }
        .environment(\.defaultMinListRowHeight, 45)
        .listStyle(PlainListStyle())
        .listRowBackground(Color.blue)
      }
      .padding(.horizontal)
      .padding(.top, 30)
      
      Spacer()
    }
    .preferredColorScheme(store.colorScheme)
    .environment(\.locale, Locale.init(identifier: store.localeIdentifier.rawValue))
    .onAppear {
      store.send(.refreshAppearanceMode)
      store.send(.refreshLanguage)
    }
  }
}

//MARK: - PREVIEW
struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView(
      navStack: .constant([]),
      store: Store(initialState: SettingsFeature.State()) { SettingsFeature() })
  }
}

