//
//  WidgetMedium.swift
//  WidgetsExtension
//
//  Created by Han-Saem Park on 2024-06-19.
//

import SwiftUI

struct WidgetMedium: View {
  var entry: Provider.Entry
  
  var body: some View {
    
    if let uiImage = entry.moviePosterImage {
      
      ZStack {
        // Background
        Image(uiImage: uiImage)
          .resizable()
          .scaledToFill()
          .blur(radius: 10)
          .frame(width: 345, height: 165) //medium
          .clipped()
          .overlay(
            Color.black.opacity(0.3) // dark layer
          )
        
        HStack (spacing: 17) {
          // Movie poster
          Image(uiImage: uiImage)
            .resizable()
            .scaledToFit()
            .cornerRadius(10)
            .frame(height: 125)
          
          VStack (alignment: .leading, spacing: 6) {
            // Movie Title
            Text(entry.latestFavoriteMovie?.title ?? "Movie Title")
              .foregroundColor(Color.white)
              .font(.title3)
              .fontWeight(.heavy)
              .shadow(radius: 2)
            
            // Movie Description
            Text(entry.latestFavoriteMovie?.overview ?? "Movie description")
              .foregroundColor(Color.white)
              .font(.footnote)
              .fontWeight(.medium)
              .multilineTextAlignment(.leading)
          }
          .frame(width: 205)
          .padding(.top, 18)
          .padding(.bottom, 18)
          
        }
      }
      .widgetURL(URL(string: "moviematch://moviedetail/\(entry.latestFavoriteMovie?.id ?? 0)"))
      
    } else {
      ZStack {
        Image(K.Image.Logo.primaryFull)
          .resizable()
          .scaledToFill()
          .blur(radius: 7)
          .frame(width: 345, height: 165)
          .clipped()
          .overlay(
            Color.black.opacity(0.3) // dark layer
          )
        
        Text("Tap to find favorite movies")
          .foregroundColor(Color.white)
          .font(.title3)
          .fontWeight(.heavy)
          .shadow(radius: 2)
      }
      .widgetURL(URL(string: "moviematch://mainview"))
    }
  }
}
