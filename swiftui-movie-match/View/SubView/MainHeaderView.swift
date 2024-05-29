import SwiftUI

struct MainHeaderView: View {
  //MARK: - AppStorage
  @AppStorage(K.AppStorageKey.localeIdentifier) private var localeIdentifier: LocaleIdentifier = .English
  
  //MARK: - PROPERTIES
  @StateObject var movieManager: MovieManager
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
        self.showSettingView.toggle()
      }){
        Image(systemName: "gearshape")
          .font(.system(size: 24, weight: .regular))
      }
      .accentColor(Color(UIColor(colorScheme.getPrimaryColor())))
      .sheet(isPresented: $showSettingView) {
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
      movieManager: movieManager,
      colorScheme: $colorScheme)
    .previewLayout(.fixed(width: 375, height: 80))
  }
}
