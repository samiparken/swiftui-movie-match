import SwiftUI

struct FooterView: View {
  //MARK: - PROPERTIES
  
  @Binding var showFavoriteView: Bool
  @Binding var showMovieDetailView: Bool
  @Binding var numOfFavoriteMovies: Int
  
  let haptics = UINotificationFeedbackGenerator()
  
  var body: some View {
    HStack {
      Image(systemName: "xmark.circle")
        .font(.system(size:42, weight: .light))
        .foregroundColor(.primaryColor)
      
      Spacer()
      
      ZStack {
        Button(action:{
          // ACTION
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
            .sheet(isPresented: $showFavoriteView) {
              FavoriteView(showMovieDetailView: $showMovieDetailView)
            }
        }
        // Badge
        if numOfFavoriteMovies > 0 {
            Text("\(numOfFavoriteMovies)")
                .font(.caption)
                .foregroundColor(.white)
                .padding(6)
                .background(Color.red)
                .clipShape(Circle())
                .offset(x: 80, y: -20)
        }
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
  @State static var showFavoriteView: Bool = false
  @State static var showMovieDetailView: Bool = false
  @State static var numOfFavoriteMovies: Int = 10
  
  static var previews: some View {
    FooterView(
      showFavoriteView: $showFavoriteView,
      showMovieDetailView: $showMovieDetailView,
      numOfFavoriteMovies: $numOfFavoriteMovies)
    .previewLayout(.fixed(width: 375, height: 80))
  }
}
