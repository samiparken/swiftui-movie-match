import SwiftUI

struct ButtonRemoveModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
      .font(.headline)
      .padding()
      .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: .infinity)
      .background(Capsule().fill(Color.pink))
      .foregroundColor(Color.white)
  }
}

struct ButtonCloseModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
      .font(.headline)
      .padding()
      .fontWeight(.heavy)
      .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: .infinity)
  }
}

struct ButtonSettingsModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
      .textCase(.uppercase)
      .font(.system(.subheadline, design:.rounded))
      .fontWeight(.semibold)
      .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: .infinity)
      .padding(.horizontal, 20)
      .padding(.vertical, 12)
  }
}
