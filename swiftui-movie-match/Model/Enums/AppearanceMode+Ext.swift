import Foundation
import SwiftUI

enum AppearanceMode: String, Equatable, CaseIterable {
    case system = "System"
    case light = "Light"
    case dark = "Dark"
}

extension AppearanceMode {
  func toColorScheme() -> ColorScheme {
    switch self {
    case .light :
      return .light
    case .dark:
      return .dark
    default:
      return .light
    }
  } 
}
