import SwiftUI

struct HeaderTitleText: View {
  @Environment(\.colorScheme) var colorScheme

  let icon: String
  let text: LocalizedStringKey
  
  var body: some View {
    HStack{
      Image(systemName: icon)
        .font(.title2)
        .foregroundColor(colorScheme.getPrimaryColor())
      Text(text)
        .textCase(.uppercase)
        .font(.title2)
        .fontWeight(.bold)
        .foregroundColor(colorScheme.getPrimaryColor())
    }
  }
}
