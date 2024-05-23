import SwiftUI

struct TextTitleModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
      .foregroundColor(Color.white)
      .font(.title)
      .fontWeight(.bold)
      .shadow(radius: 1)
      .overlay(
        Rectangle()
          .fill(Color.white)
          .frame(height: 1),
        alignment: .bottom
      )
  }
}

struct TextLabelModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
      .foregroundColor(Color.gray)
      .font(.subheadline)
      .fontWeight(.bold)
  }
}

struct TextContentModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
      .foregroundColor(Color.white)
      .font(.subheadline)
      .fontWeight(.bold)
  }
}

struct TextDescriptionModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
      .foregroundColor(Color.white)
      .font(.subheadline)
      .fontWeight(.bold)
      .frame(minWidth: 85, alignment: .leading)
      .multilineTextAlignment(.leading)
  }
}
