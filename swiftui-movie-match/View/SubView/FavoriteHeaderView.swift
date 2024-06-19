import SwiftUI

struct FavoriteHeaderView: View {
  //MARK: - Navigation Stack
  @Binding var navStack: [NavRoute]
  
  //MARK: - PROPERTIES
  @Environment(\.colorScheme) var colorScheme
  var numOfFavorites: Int = 0
  
  //MARK: - BODY
  var body: some View {
    ZStack(alignment: .center) {

      // BACK Button
      HStack{
        HeaderBackButton(){
          navStack.removeLast()
        }
        Spacer()
      }
      
      // TITLE
      HeaderTitleText(icon: "heart.circle", text: "favorites-string")

      // NUM OF FAVORITE MOVIES
      HStack{
        Spacer()
        Text(String(numOfFavorites))
          .font(.title)
          .fontWeight(.heavy)
          .foregroundColor(Color.pink)
          .padding(.leading, 5)
      }
    }
    .padding()
  }
}

struct FavoriteHeaderView_Previews: PreviewProvider {
  static var previews: some View {
    FavoriteHeaderView(navStack:.constant([]),
                       numOfFavorites: 10)
      .previewLayout(.sizeThatFits) //the views in it
  }
}
