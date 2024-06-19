//
//  TextModifier.swift
//  WidgetsExtension
//
//  Created by Han-Saem Park on 2024-06-17.
//

import SwiftUI

struct WidgetTextLabelModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
      .foregroundColor(Color.gray)
      .font(.caption)
      .fontWeight(.bold)
  }
}

struct WidgetTextModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
      .foregroundColor(Color.white)
      .font(.caption)
      .fontWeight(.bold)
  }
}
