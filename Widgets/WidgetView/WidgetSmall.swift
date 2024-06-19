//
//  WidgetSmall.swift
//  WidgetsExtension
//
//  Created by Han-Saem Park on 2024-06-19.
//

import SwiftUI

struct WidgetSmall: View {
  var entry: Provider.Entry
  
  var body: some View {
    
    if let uiImage = entry.moviePosterImage {
      ZStack {
        // Background
        Image(uiImage: uiImage)
          .resizable()
          .scaledToFill()
          .blur(radius: 10)
          .frame(width: 165, height: 165) //small
          .clipped()
          .overlay(
            Color.black.opacity(0.3) // dark layer
          )
        
        VStack (alignment:.center, spacing: 5) {
          // Movie Title
          Text(entry.latestFavoriteMovie?.title ?? "Movie Title")
            .foregroundColor(Color.white)
            .font(.footnote)
            .fontWeight(.bold)
            .shadow(radius: 1)
            .lineLimit(2)
            .truncationMode(.tail)
            .frame(width: 145)
            .lineSpacing(-7)
          
          // Movie poster
          Image(uiImage: uiImage)
            .resizable()
            .scaledToFit()
            .cornerRadius(10)
            .frame(height: 115)
        }
      }
      .widgetURL(URL(string: "moviematch://moviedetail/\(entry.latestFavoriteMovie?.id ?? 0)"))
      
    } else {
      ZStack {
        Image(K.Image.Logo.primaryFull)
          .resizable()
          .scaledToFill()
          .blur(radius: 7)
          .frame(width: 165, height: 165) // small
          .clipped()
          .overlay(
            Color.black.opacity(0.3) // dark layer
          )
        
        Text("Tap to find favorite movies")
          .foregroundColor(Color.white)
          .font(.subheadline)
          .fontWeight(.heavy)
          .shadow(radius: 2)
          .multilineTextAlignment(.center)
      }
      .widgetURL(URL(string: "moviematch://mainview"))
    }
    
  }
}
