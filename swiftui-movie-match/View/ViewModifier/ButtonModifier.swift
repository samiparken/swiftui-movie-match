
import SwiftUI

struct RemoveButtonModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
      .font(.headline)
      .padding()
      .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: .infinity)
      .background(Capsule().fill(Color.pink))
      .foregroundColor(Color.white)
  }
}

struct CloseButtonModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
      .font(.headline)
      .padding()
      .fontWeight(.heavy)
      .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: .infinity)
      .accentColor(Color(UIColor(.primaryColor)))
      .background(
        Capsule().stroke(Color(UIColor(.primaryColor)), lineWidth: 2)
      )
    
  }
}
