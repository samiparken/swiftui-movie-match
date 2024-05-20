import SwiftUI

struct FooterView: View {
  //MARK: - PROPERTIES
  
  @Binding var showFavoriteView: Bool
  let haptics = UINotificationFeedbackGenerator()
  
  var body: some View {
    HStack {
      Image(systemName: "xmark.circle")
        .font(.system(size:42, weight: .light))
        .foregroundColor(.primaryColor)
      
      Spacer()
      
      Button(action:{
        //ACTION
        self.haptics.notificationOccurred(.success)
        self.showFavoriteView.toggle()
      }) {
        Text("Show Favorites".uppercased())
          .font(.system(.subheadline, design:.rounded))
          .fontWeight(.heavy)
          .padding(.horizontal, 20)
          .padding(.vertical, 12)
          .accentColor(Color(UIColor(.primaryColor)))
          .background(
            Capsule().stroke(Color(UIColor(.primaryColor)), lineWidth: 2)
          )
      }
      
      Spacer()
      
      Image(systemName: "heart.circle")
        .font(.system(size: 42, weight: .light))
        .foregroundColor(.primaryColor)

    }
    .padding()
  }
}

struct FooterView_Previews: PreviewProvider {
  @State static var showAlert: Bool = false
  
  static var previews: some View {
    FooterView(showFavoriteView: $showAlert)
      .previewLayout(.fixed(width: 375, height: 80))
  }
}
