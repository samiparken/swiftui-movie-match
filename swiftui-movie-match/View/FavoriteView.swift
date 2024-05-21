import SwiftUI

struct FavoriteView: View {
  //MARK: - PROPERTIES
  @Environment(\.presentationMode) var presentationMode
    
  var body: some View {

    VStack {
      HeaderSwipeBar()
      
      Spacer()
    }
  }
}

#Preview {
  FavoriteView()
}
