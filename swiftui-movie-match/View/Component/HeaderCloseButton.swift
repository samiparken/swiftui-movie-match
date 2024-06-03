import SwiftUI

struct HeaderCloseButton: View {
  @Environment(\.colorScheme) var colorScheme
  let action: () -> Void

  var body: some View {
    Button(action:{
      action()
    }) {
      Image(systemName: "xmark")
        .font(.system(size: 30, weight: .light))
        .foregroundColor(colorScheme.getPrimaryColor())
    }
  }
}
