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
      HStack{
        Image(systemName: "heart.circle")
          .font(.title2)
          .foregroundColor(colorScheme.getPrimaryColor())
        Text("favorites-string")
          .textCase(.uppercase)
          .font(.title2)
          .fontWeight(.bold)
          .foregroundColor(colorScheme.getPrimaryColor())
      }
      
      // CLOSE Button
      HStack{
        Spacer()
        Button(action:{
          self.presentationMode.wrappedValue.dismiss()
        }) {
          Image(systemName: "xmark")
            .font(.system(size: 30, weight: .light))
            .foregroundColor(colorScheme.getPrimaryColor())
        }
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
