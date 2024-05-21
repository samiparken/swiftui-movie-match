import SwiftUI

struct MainHeaderView: View {

  //MARK: - PROPERTIES
  @Environment(\.colorScheme) var colorScheme
  @ObservedObject var movieManager: MovieManager
  @Binding var showSettingView: Bool
  
  let haptics = UINotificationFeedbackGenerator()
  
  var body: some View {
    HStack {
      
      //REFRESH BUTTON
      Button(action: {
        //self.haptics.notificationOccurred(.success)
        movieManager.refreshPopularMovieList()
      }) {
        Image(systemName: "arrow.clockwise")
          .font(.system(size: 24, weight: .regular))
      }
      .accentColor(Color(UIColor(colorScheme.isDarkMode()
                                 ? .tertiaryColor
                                 : .primaryColor)))
      
      Spacer()
      
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
      .accentColor(Color(UIColor(colorScheme.isDarkMode()
                                 ?.tertiaryColor
                                 : .primaryColor)))
    }
    .padding()
  }
}

struct HeaderView_Previews: PreviewProvider {
  @State static var movieManager = MovieManager()
  @State static var showSettingView: Bool = false
  
  static var previews: some View {
    MainHeaderView(movieManager: movieManager, showSettingView: $showSettingView)
      .previewLayout(.fixed(width: 375, height: 80))
  }
}
