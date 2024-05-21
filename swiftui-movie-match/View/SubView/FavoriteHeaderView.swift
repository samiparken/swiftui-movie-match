import SwiftUI

struct FavoriteHeaderView: View {
  //MARK: - PROPERTIES
  var numOfFavorites: Int = 10
  
  var body: some View {
    HStack(alignment:.center, spacing:20) {
      Image(systemName: "heart.circle")
        .font(.largeTitle)
        .foregroundColor(Color.pink)
      Spacer()
      
      Text("Favorites".uppercased())
        .font(.title)
        .fontWeight(.bold)
        .foregroundColor(.primaryColor)

      Spacer()
      Text(String(numOfFavorites))
        .font(.title2)
        .fontWeight(.heavy)
        .foregroundStyle(Color.pink)
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
