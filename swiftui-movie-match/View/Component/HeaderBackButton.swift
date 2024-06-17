import SwiftUI

struct HeaderBackButton: View {
  @Environment(\.colorScheme) var colorScheme
  let action: () -> Void

  var body: some View {
    Button(action:{
      action()
    }) {
      Image(systemName: "arrow.left")
        .font(.system(size: 30, weight: .light))
        .foregroundColor(colorScheme.getPrimaryColor())
    }
  }
}
