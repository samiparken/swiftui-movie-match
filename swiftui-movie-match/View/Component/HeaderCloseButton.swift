import SwiftUI

struct HeaderCloseButton: View {
  @Environment(\.presentationMode) var presentationMode
  @Environment(\.colorScheme) var colorScheme
  var body: some View {
    Button(action:{
      self.presentationMode.wrappedValue.dismiss()
    }) {
      Image(systemName: "xmark")
        .font(.system(size: 30, weight: .light))
        .foregroundColor(colorScheme.getPrimaryColor())
    }
  }
}
