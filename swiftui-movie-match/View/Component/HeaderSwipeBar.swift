
import SwiftUI

struct HeaderSwipeBar: View {
  var body: some View {
    Capsule()
      .frame(width:120, height:6)
      .foregroundColor(Color.secondary)
      .opacity(0.2)
      .padding(.top, 20)
  }
}

struct HeaderBar_Previews: PreviewProvider {
  static var previews: some View {
    HeaderSwipeBar()
      .previewLayout(.fixed(width: 375, height: 50))
  }
}
