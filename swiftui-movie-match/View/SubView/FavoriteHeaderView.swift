import SwiftUI

struct FavoriteHeaderView: View {
  //MARK: - PROPERTIES
  @Environment(\.colorScheme) var colorScheme
  var numOfFavorites: Int = 0
  
  var body: some View {
    ZStack(alignment:.center) {
      HStack{
        Image(systemName: "heart.circle")
          .font(.largeTitle)
          .foregroundColor(Color.pink)
        Spacer()
      }
      
      Text("favorites-string")
        .textCase(.uppercase)
        .font(.title2)
        .fontWeight(.bold)
        .foregroundColor(colorScheme == .dark
                         ? .tertiaryColor
                         : .primaryColor)

      HStack{
        Spacer()
        Text(String(numOfFavorites))
          .font(.title2)
          .fontWeight(.heavy)
          .foregroundStyle(Color.pink)
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
