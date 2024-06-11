import SwiftUI
import ComposableArchitecture

@Reducer
struct SettingsFeature {
  
  //MARK: - State
  @ObservableState
  struct State: Equatable {
    var appearanceMode: AppearanceMode {
      get {
        AppearanceMode(rawValue: UserDefaults.standard.string(forKey: K.AppStorageKey.appearanceMode) ?? AppearanceMode.system.rawValue) ?? .system
      }
      set {
        UserDefaults.standard.set(newValue.rawValue, forKey: K.AppStorageKey.appearanceMode)
      }
    }
    
  }

  //MARK: - Action
  enum Action {
    case closeSettingsView
    case selectAppearanceMode(AppearanceMode)
  }
  
  @Dependency(\.dismiss) var dismiss //dismiss effect for child

  //MARK: - Reducer
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .closeSettingsView:
        return .run { _ in await self.dismiss() } //dismiss
        
      case let .selectAppearanceMode(selectedMode):
        state.appearanceMode = selectedMode
        return .none
        
      }
    }
  }
}


struct SettingsView: View {
  //MARK: - Store
  @Bindable var store: StoreOf<SettingsFeature>
  
  //MARK: - AppStorage
  @AppStorage(K.AppStorageKey.localeIdentifier) private var localeIdentifier: LocaleIdentifier = .English
  
  //MARK: - PROPERTIES
  @Environment(\.presentationMode) var presentationMode
  @Binding var colorScheme: ColorScheme
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
    switch localeIdentifier {
    case .English:
      selectedLanguage = "English"
    case .Swedish:
      selectedLanguage = "Svenska"
    case .Korean:
      selectedLanguage = "한국어"
    }
  }
  
  func onLanguageSelected(_ language: String?) {
    switch language {
    case "English":
      localeIdentifier = .English
    case "Svenska":
      localeIdentifier = .Swedish
    case "한국어":
      localeIdentifier = .Korean
    default:
      localeIdentifier = .English
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
                colorScheme = .light
                store.send(.selectAppearanceMode(.light))
                initColorSet()
              }){
                Text("light-string")
                  .modifier(ButtonSettingsModifier())
                  .background(
                    Capsule().fill(
                      colorScheme == .light ? selectedColor : Color.clear
                    )
                  )
                  .overlay(
                    Capsule().stroke(
                      colorScheme == .light ? Color.clear : selectedColor,
                      lineWidth: 2
                    )
                  )
                  .foregroundColor(colorScheme == .light ? Color.white : selectedColor)
              }
              
              // DARK mode
              Button(action:{
                colorScheme = .dark
                store.send(.selectAppearanceMode(.dark))
                initColorSet()
              }){
                Text("dark-string")
                  .textCase(.uppercase)
                  .modifier(ButtonSettingsModifier())
                  .background(
                    Capsule().fill(
                      colorScheme == .light ? Color.clear : selectedColor
                    )
                  )
                  .overlay(
                    Capsule().stroke(colorScheme == .light ? selectedColor : Color.clear, lineWidth: 2)
                  )
                  .foregroundColor(colorScheme == .light ? selectedColor : Color.black)
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
          onLanguageSelected(selectedLanguage)
        }
        
      }
      .padding(.horizontal)
      .padding(.top, 30)
      
      Spacer()
    }
    .preferredColorScheme(colorScheme)
    .environment(\.locale, Locale.init(identifier: localeIdentifier.rawValue))
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
    
    SettingsView(store: Store(initialState: SettingsFeature.State()) { SettingsFeature() },
                 colorScheme: $colorScheme)
  }
}

