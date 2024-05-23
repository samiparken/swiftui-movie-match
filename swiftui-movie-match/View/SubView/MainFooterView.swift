import SwiftUI
import SwiftData

struct MainFooterView: View {
  //MARK: - PROPERTIES
  @Environment(\.colorScheme) var colorScheme
  @Environment(\.modelContext) private var context
  @Query private var favoriteMovies: [FavoriteMovie]
  
  @Binding var showFavoriteView: Bool
  @Binding var showMovieDetailView: Bool
  
  let haptics = UINotificationFeedbackGenerator()
  
  //MARK: - BODY
  var body: some View {
    HStack {
      Image(systemName: "xmark.circle")
        .font(.system(size:42, weight: .light))
        .foregroundColor(colorScheme.getPrimaryColor())
      
      Spacer()
      
      ZStack {
        Button(action:{
          // ACTION
          self.haptics.notificationOccurred(.success)
          self.showFavoriteView.toggle()
        }) {
          Text("showFavorite-string")
            .textCase(.uppercase)
            .font(.system(.subheadline, design:.rounded))
            .fontWeight(.heavy)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .accentColor(Color(UIColor(colorScheme.getPrimaryColor())))
            .background(
              Capsule().stroke(Color(UIColor(colorScheme.getPrimaryColor())), lineWidth: 2)
            )
            .sheet(isPresented: $showFavoriteView) {
              FavoriteView(showMovieDetailView: $showMovieDetailView)
            }
        }
        // Badge
        if favoriteMovies.count > 0 {
          Text("\(favoriteMovies.count)")
            .font(.caption)
            .foregroundColor(.white)
            .padding(favoriteMovies.count >= 10 ? 6 : 8)
            .background(Color.pink)
            .clipShape(Circle())
            .offset(x: 80, y: -20)
        }
      }
      
      Spacer()
      
      Image(systemName: "heart.circle")
        .font(.system(size: 42, weight: .light))
        .foregroundColor(colorScheme.getPrimaryColor())
      
    }
    .padding()
  }
}

struct FooterView_Previews: PreviewProvider {
  @State static var showFavoriteView: Bool = false
  @State static var showMovieDetailView: Bool = false
  
  static var previews: some View {
    MainFooterView(
      showFavoriteView: $showFavoriteView,
      showMovieDetailView: $showMovieDetailView)
    .previewLayout(.fixed(width: 375, height: 80))
  }
}
