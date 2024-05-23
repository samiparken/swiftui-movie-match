import SwiftUI

struct SettingsView: View {
  //MARK: - PROPERTIES
  @Environment(\.presentationMode) var presentationMode
  @AppStorage(K.AppStorageKey.localeIdentifier) private var localeIdentifier: LocaleIdentifier = .English
  @AppStorage(K.AppStorageKey.appearanceMode) private var appearanceMode: AppearanceMode = .system
  
  @Binding var colorScheme: ColorScheme?
  @State private var selectedLanguage: String?
  @State private var selectedColor: Color = .primaryColor
  @State private var backgroundColor: Color = Color.white
    
  //MARK: - METHOD
  func initColorSet() {
    switch colorScheme {
    case .light:
      selectedColor = .primaryColor
      backgroundColor = Color.white
    case .dark:
      selectedColor = .tertiaryColor
      backgroundColor = Color.black
    case nil:
      selectedColor = .primaryColor
      backgroundColor = Color.white
    case .some(_):
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
        Text("settings-string")
          .textCase(.uppercase)
          .font(.title2)
          .fontWeight(.bold)
          .foregroundColor(colorScheme == .dark
                           ? .tertiaryColor
                           : .primaryColor)
        // CLOSE Button
        HStack{
          Spacer()
          Button(action:{
            self.presentationMode.wrappedValue.dismiss()
          }) {
            Image(systemName: "xmark")
              .font(.system(size: 30, weight: .light))
              .foregroundColor(colorScheme == .dark
                               ? .tertiaryColor
                               : .primaryColor)
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
                appearanceMode = .light
                initColorSet()
              }){
                Text("light-string")
                  .modifier(SettingsButtonModifier())
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
                appearanceMode = .dark
                initColorSet()
              }){
                Text("dark-string")
                  .textCase(.uppercase)
                  .modifier(SettingsButtonModifier())
                  .background(
                    Capsule().fill(
                      colorScheme == .light ? Color.clear : selectedColor                    )
                  )
                  .overlay(
                    Capsule().stroke(
                      colorScheme == .light ? selectedColor : Color.clear,
                      lineWidth: 2
                    )
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
    @State var colorScheme: ColorScheme? = .dark
    
    SettingsView(colorScheme: $colorScheme)
  }
}
