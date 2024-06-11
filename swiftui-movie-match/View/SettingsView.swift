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
    var selectedLanguage: String?
    var selectedColor: Color = .primaryColor
    var backgroundColor: Color = Color.white
  }

  //MARK: - Action
  enum Action {
    // Init
    case initColorScheme
    case initLanguage

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
        
      case .initLanguage:
        state.selectedLanguage = state.localeIdentifier.toLanguageString()
        return .none
                
      case let .selectAppearanceMode(selectedMode):
        state.appearanceMode = selectedMode
        switch selectedMode {
        case .light:
          state.selectedColor = .primaryColor
          state.backgroundColor = Color.white
        case .dark:
          state.selectedColor = .tertiaryColor
          state.backgroundColor = Color.black
        default:
          state.selectedColor = .primaryColor
          state.backgroundColor = Color.white
        }
        return .none
      
      case let .changeLanguage(selectedLanguage):
        if let language = selectedLanguage {
          state.localeIdentifier = language.toLocaleIdentifier()
          state.selectedLanguage = language
        }
        return .none
        
      case .closeSettingsView:
        return .run { _ in await self.dismiss() } //dismiss
        
      }
    }
  }
}

struct SettingsView: View {
  //MARK: - Store
  @Bindable var store: StoreOf<SettingsFeature>
  
  //MARK: - PROPERTIES
  @Environment(\.presentationMode) var presentationMode
  
  //MARK: - METHOD
  func initColorSet() {
      }
  
  func isSelectedLanguage(_ language: String?) -> Bool {
    return language == store.selectedLanguage
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
              .foregroundColor(store.selectedColor)
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
                      store.colorScheme == .light ? store.selectedColor : Color.clear
                    )
                  )
                  .overlay(
                    Capsule().stroke(
                      store.colorScheme == .light ? Color.clear : store.selectedColor,
                      lineWidth: 2
                    )
                  )
                  .foregroundColor(store.colorScheme == .light ? Color.white : store.selectedColor)
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
                      store.colorScheme == .light ? Color.clear : store.selectedColor
                    )
                  )
                  .overlay(
                    Capsule().stroke(store.colorScheme == .light ? store.selectedColor : Color.clear, lineWidth: 2)
                  )
                  .foregroundColor(store.colorScheme == .light ? store.selectedColor : Color.black)
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
              .foregroundColor( isSelectedLanguage(language)
                                ? store.backgroundColor
                                : store.selectedColor)
              .fontWeight(.semibold)
              .padding(.leading, 10)
            Spacer()
            if isSelectedLanguage(language) {
              Image(systemName: "checkmark")
                .foregroundColor(store.backgroundColor)
                .fontWeight(.semibold)
                .padding(.trailing, 10)
            }
          }
          .listRowBackground(
            Capsule()
              .fill(isSelectedLanguage(language) ? store.selectedColor : Color.clear))
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
      store.send(.initLanguage)
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

