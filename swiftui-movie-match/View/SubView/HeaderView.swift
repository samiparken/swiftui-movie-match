import SwiftUI

struct HeaderView: View {
  //MARK: - PROPERTIES
  @StateObject var movieManager = MovieManager()
  @Binding var showSettingView: Bool
  
  let haptics = UINotificationFeedbackGenerator()
  
  var body: some View {
    HStack {
      
      //REFRESH BUTTON
      Button(action: {
        self.haptics.notificationOccurred(.success)
        movieManager.refreshMovieCardsToShow()
      }) {
        Image(systemName: "arrow.clockwise")
          .font(.system(size: 24, weight: .regular))
      }
      .accentColor(Color(UIColor(.primaryColor)))
      
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
      .accentColor(Color(UIColor(.primaryColor)))
    }
    .padding()
  }
}

struct HeaderView_Previews: PreviewProvider {
  @State static var showSettingView: Bool = false
  
  static var previews: some View {
    HeaderView(showSettingView: $showSettingView)
      .previewLayout(.fixed(width: 375, height: 80))
  }
}
