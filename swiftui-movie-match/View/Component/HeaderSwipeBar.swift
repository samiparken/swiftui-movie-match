import SwiftUI

struct HeaderSwipeBar: View {
  @Environment(\.colorScheme) var colorScheme

  var body: some View {
    Capsule()
      .frame(width:120, height:6)
      .foregroundColor(colorScheme == .dark
                       ? Color.white
                       : Color.secondary)
      .opacity(0.3)
      .padding(.vertical, 20)
  }
}

struct HeaderBar_Previews: PreviewProvider {
  static var previews: some View {
    HeaderSwipeBar()
      .previewLayout(.fixed(width: 375, height: 50))
  }
}
