import SwiftUI

struct SettingsView: View {
  //MARK: - PROPERTIES
  @Environment(\.presentationMode) var presentationMode
  @AppStorage(K.AppStorageKey.localeIdentifier) private var localeIdentifier: LocaleIdentifier = .English
  @AppStorage(K.AppStorageKey.appearanceMode) private var appearanceMode: AppearanceMode = .system
  
  @Binding var colorScheme: ColorScheme?
  @State private var selectedLanguage: String?
  
  //MARK: - METHOD
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
  
  func onLanguageSelected(_ language: String) {
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
  
  //MARK: - BODY
  var body: some View {
    VStack (alignment:.center, spacing: 0) {
      HeaderSwipeBar()
      
      //MARK: - HEADER
      ZStack {
        // HEADER TITLE
        Text("settings-string")
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
              .foregroundColor(colorScheme == .dark
                               ? .tertiaryColor
                               : .primaryColor)
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
              }){
                Text("light-string")
                  .modifier(SettingsButtonModifier())
                  .background(
                    Capsule().fill(
                      colorScheme == .light ? Color(UIColor(.primaryColor)) : Color.clear
                    )
                  )
                  .overlay(
                    Capsule().stroke(
                      colorScheme == .light ? Color.clear : Color(UIColor(.tertiaryColor)),
                      lineWidth: 2
                    )
                  )
                  .foregroundColor(colorScheme == .light ? Color.white : Color(UIColor(.tertiaryColor)))
              }
              
              // DARK mode
              Button(action:{
                colorScheme = .dark
                appearanceMode = .dark
              }){
                Text("dark-string")
                  .modifier(SettingsButtonModifier())
                  .background(
                    Capsule().fill(
                      colorScheme == .light ? Color.clear : Color(UIColor(.tertiaryColor))
                    )
                  )
                  .overlay(
                    Capsule().stroke(
                      colorScheme == .light ? Color(UIColor(.primaryColor)) : Color.clear,
                      lineWidth: 2
                    )
                  )
                  .foregroundColor(colorScheme == .light ? Color(UIColor(.primaryColor)) : Color.black)
              }
            }
          }
        }
      }
      .padding(.horizontal)
                  
      
      //+TODO: add Language Change
      
      VStack(alignment:.leading, spacing: 10) {
        VStack {
          Divider()
          VStack {
            Text("Language")
              .foregroundColor(colorScheme == .dark
                               ? .tertiaryColor
                               : .primaryColor)
              .font(.title3)
              .fontWeight(.bold)
              .padding(.top, 10)
              .padding(.bottom, 20)
            
            HStack (alignment:.center, spacing: 40) {
              //+TODO: apply system colorScheme
              
              List(K.SettingsView.languageList, id: \.self, selection: $selectedLanguage) { language in
                HStack {
                  Text(language)
                  Spacer()
                  if language == selectedLanguage ?? "English" {
                      Image(systemName: "checkmark")
                          .foregroundColor(.blue)
                  }
                }
              }
              .onChange(of: selectedLanguage) {
                onLanguageSelected(selectedLanguage ?? "English")
              }
            }
          }
          .padding(.bottom, 10)
          Divider()
        }
      }
      .padding(.horizontal)
      .padding(.vertical,30)
            
      Spacer()

    }
    .preferredColorScheme(colorScheme)
    .environment(\.locale, Locale.init(identifier: localeIdentifier.rawValue))
    .onAppear {
      initLanguageSelector()
    }
  }
}

//MARK: - PREVIEW
struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    @State var colorScheme: ColorScheme? = .light
    
    SettingsView(colorScheme: $colorScheme)
  }
}
