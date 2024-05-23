import SwiftUI

struct FavoriteHeaderView: View {
  //MARK: - PROPERTIES
  @Environment(\.presentationMode) var presentationMode
  @Environment(\.colorScheme) var colorScheme
  var numOfFavorites: Int = 0
  
  //MARK: - BODY
  var body: some View {
    ZStack(alignment:.center) {

      // NUM OF FAVORITE MOVIES
      HStack{
        Text(String(numOfFavorites))
          .font(.title)
          .fontWeight(.heavy)
          .foregroundColor(Color.pink)
          .padding(.leading, 5)
        Spacer()
      }
      
      // TITLE
      HeaderTitleText(icon: "heart.circle", text: "favorites-string")
      
      // CLOSE Button
      HStack{
        Spacer()
        HeaderCloseButton()
      }
    }
    .padding(.horizontal)
  }
}

struct FavoriteHeaderView_Previews: PreviewProvider {
  static var previews: some View {
    FavoriteHeaderView(numOfFavorites: 10)
      .previewLayout(.sizeThatFits) //the views in it
  }
}
