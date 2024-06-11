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
    
    var colorScheme: ColorScheme = .light
  }

  //MARK: - Action
  enum Action {
    // Init
    case initColorScheme

    case closeSettingsView
    case selectAppearanceMode(AppearanceMode)
    case changeLanguage(String?)
  }
  @Dependency(\.dismiss) var dismiss //dismiss effect for child
  
  //MARK: - Reducer
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
        
      case .initColorScheme:
        switch state.appearanceMode {
        case .system:
          state.colorScheme = .light //+TODO: get system colorScheme
        case .light:
          state.colorScheme = .light
        case .dark:
          state.colorScheme = .dark
        }
        return .none
        
      case .closeSettingsView:
        return .run { _ in await self.dismiss() } //dismiss
        
      case let .selectAppearanceMode(selectedMode):
        state.appearanceMode = selectedMode
        return .none
      
      case let .changeLanguage(selectedLanguage):
        if let language = selectedLanguage {
          state.localeIdentifier = language.toLocaleIdentifier()
        }
        return .none
        
      }
    }
  }
}

struct SettingsView: View {
  //MARK: - Store
  @Bindable var store: StoreOf<SettingsFeature>
  
  //MARK: - PROPERTIES
  @Environment(\.presentationMode) var presentationMode
  @State private var selectedLanguage: String?
  @State private var selectedColor: Color = .primaryColor
  @State private var backgroundColor: Color = Color.white
  
  //MARK: - METHOD
  func initColorSet() {
    switch store.appearanceMode {
    case .light:
      selectedColor = .primaryColor
      backgroundColor = Color.white
    case .dark:
      selectedColor = .tertiaryColor
      backgroundColor = Color.black
    default:
      selectedColor = .primaryColor
      backgroundColor = Color.white
    }
  }
  
  func initLanguageSelector() {
    switch store.localeIdentifier {
    case .English:
      selectedLanguage = "English"
    case .Swedish:
      selectedLanguage = "Svenska"
    case .Korean:
      selectedLanguage = "한국어"
    }
  }
  
  
  func isSelectedLanguage(_ language: String?) -> Bool {
    return language == selectedLanguage
  }
  
  //MARK: - BODY
  var body: some View {
    VStack (alignment:.center, spacing: 0) {
      HeaderSwipeBar()
      
      //MARK: - HEADER
      ZStack {
        // HEADER TITLE
        HeaderTitleText(icon: "gearshape", text: "settings-string")
        
        // CLOSE Button
        HStack{
          Spacer()
          HeaderCloseButton(){
            store.send(.closeSettingsView)
          }
        }
      }
      .padding(.horizontal)
      
      
      //MARK: - APPEARANCE
      VStack(alignment:.leading, spacing: 10) {
        VStack {
          Divider()
            .padding(.top,20)
          VStack {
            Text("appearance-string")
              .foregroundColor(selectedColor)
              .font(.title3)
              .fontWeight(.bold)
              .padding(.top, 10)
              .padding(.bottom, 20)
            
            HStack (alignment:.center, spacing: 40) {
              //+TODO: apply system colorScheme
              
              //LIGHT mode
              Button(action:{
                store.send(.selectAppearanceMode(.light))
                store.send(.initColorScheme)
                initColorSet()
              }){
                Text("light-string")
                  .modifier(ButtonSettingsModifier())
                  .background(
                    Capsule().fill(
                      store.colorScheme == .light ? selectedColor : Color.clear
                    )
                  )
                  .overlay(
                    Capsule().stroke(
                      store.colorScheme == .light ? Color.clear : selectedColor,
                      lineWidth: 2
                    )
                  )
                  .foregroundColor(store.colorScheme == .light ? Color.white : selectedColor)
              }
              
              // DARK mode
              Button(action:{
                store.send(.selectAppearanceMode(.dark))
                store.send(.initColorScheme)
                initColorSet()
              }){
                Text("dark-string")
                  .textCase(.uppercase)
                  .modifier(ButtonSettingsModifier())
                  .background(
                    Capsule().fill(
                      store.colorScheme == .light ? Color.clear : selectedColor
                    )
                  )
                  .overlay(
                    Capsule().stroke(store.colorScheme == .light ? selectedColor : Color.clear, lineWidth: 2)
                  )
                  .foregroundColor(store.colorScheme == .light ? selectedColor : Color.black)
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
          .foregroundColor(selectedColor)
          .font(.title3)
          .fontWeight(.bold)
          .padding(.top, 10)
          .padding(.bottom, 20)
        
        List(K.SettingsView.languageList, id: \.self, selection: $selectedLanguage) { language in
          HStack {
            Text(language)
              .foregroundColor( isSelectedLanguage(language)
                                ? backgroundColor
                                : selectedColor)
              .fontWeight(.semibold)
              .padding(.leading, 10)
            Spacer()
            if isSelectedLanguage(language) {
              Image(systemName: "checkmark")
                .foregroundColor(backgroundColor)
                .fontWeight(.semibold)
                .padding(.trailing, 10)
            }
          }
          .listRowBackground(
            Capsule()
              .fill(isSelectedLanguage(language) ? selectedColor : Color.clear))
        }
        .environment(\.defaultMinListRowHeight, 45)
        .listStyle(PlainListStyle())
        .listRowBackground(Color.blue)
        .onChange(of: selectedLanguage) {
          store.send(.changeLanguage(selectedLanguage))
        }
        
      }
      .padding(.horizontal)
      .padding(.top, 30)
      
      Spacer()
    }
    .preferredColorScheme(store.colorScheme)
    .environment(\.locale, Locale.init(identifier: store.localeIdentifier.rawValue))
    .onAppear {
      initLanguageSelector()
      initColorSet()
    }
  }
}

//MARK: - PREVIEW
struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    @State var colorScheme: ColorScheme = .dark
    
    SettingsView(store: Store(initialState: SettingsFeature.State()) { SettingsFeature() })
  }
}

