import SwiftUI

struct SettingsView: View {
  //MARK: - PROPERTIES
  @Environment(\.presentationMode) var presentationMode
  @AppStorage(K.AppStorageKey.localeIdentifier) private var localeIdentifier: LocaleIdentifier = .English
  @AppStorage(K.AppStorageKey.appearanceMode) private var appearanceMode: AppearanceMode = .system
  
  @Binding var colorScheme: ColorScheme?
  
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
          .padding(.bottom, 10)
          Divider()
        }
      }
      .padding(.horizontal)
      .padding(.vertical,30)
                  
      Spacer()
      
      //+TODO: add Language Change
      
      
      
      
      
    }
    .preferredColorScheme(colorScheme)
    .environment(\.locale, Locale.init(identifier: localeIdentifier.rawValue))
  }
}

//MARK: - PREVIEW
struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    @State var colorScheme: ColorScheme? = .light
    
    SettingsView(colorScheme: $colorScheme)
  }
}
