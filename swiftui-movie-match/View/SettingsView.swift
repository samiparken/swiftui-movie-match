import SwiftUI

struct SettingsView: View {
  //MARK: - PROPERTIES
  @Environment(\.colorScheme) var colorScheme
  @Environment(\.presentationMode) var presentationMode
  @AppStorage(K.AppStorageKey.language) private var selectedLanguage = "English"
  @AppStorage(K.AppStorageKey.isDarkMode) private var isDarkMode = false
  
  let languages = ["English", "Svenska", "한국어"]
  
  //MARK: - BODY
  var body: some View {
    VStack (alignment:.center, spacing: 0) {
      HeaderSwipeBar()
      
      // HEADER
      ZStack {
        // HEADER TITLE
        Text("Settings".uppercased())
          .font(.title2)
          .fontWeight(.bold)
          .foregroundColor(colorScheme.isDarkMode()
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
              .foregroundColor(colorScheme.isDarkMode()
                               ? .tertiaryColor
                               : .primaryColor)
          }
        }
      }
      .padding(.horizontal)
      
      // CONTENT
      Form {
        Picker("Language", selection: $selectedLanguage) {
          ForEach(languages, id: \.self) { language in
            Text(language)
          }
        }
        .pickerStyle(MenuPickerStyle())
        
        // Light/Dark Mode Switch
        Toggle(isOn: $isDarkMode) {
          Text("Dark Mode")
        }
        
      }
      
      
      Spacer()
    }
  }
}

#Preview {
  SettingsView()
}
