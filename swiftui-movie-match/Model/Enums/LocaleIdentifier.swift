import Foundation

enum LocaleIdentifier: String, CaseIterable, Equatable {
    case English = "en"
    case Swedish = "sv"
    case Korean = "ko"
}

extension LocaleIdentifier {
  func toLanguageString() -> String {
    switch self {
    case .English :
      return "English"
    case .Swedish:
      return "Svenska"
    case .Korean:
      return "한국어"
    }
  }
}
