import SwiftUI

extension ColorScheme {
  func getPrimaryColor() -> Color {
    return self == .dark ? .tertiaryColor : .primaryColor
  }
}
