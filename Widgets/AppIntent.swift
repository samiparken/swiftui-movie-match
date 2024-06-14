//
//  AppIntent.swift
//  Widgets
//
//  Created by Han-Saem Park on 2024-05-23.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Configuration"
    static var description = IntentDescription("This is an example widget.")

    // An example configurable parameter.
    @Parameter(title: "Favorite Symbol", default: "❤️")
    var favoriteSymbol: String
}
