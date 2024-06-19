//
//  WidgetLarge.swift
//  WidgetsExtension
//
//  Created by Han-Saem Park on 2024-06-19.
//

import SwiftUI

struct WidgetLarge: View {
  var entry: Provider.Entry
  
  var body: some View {
    
    if let uiImage = entry.moviePosterImage {
      
      ZStack {
        // Background
        Image(uiImage: uiImage)
          .resizable()
          .scaledToFill()
          .blur(radius: 10)
          .frame(width: 345, height: 355) //large
          .clipped()
          .overlay(
            Color.black.opacity(0.4) // dark layer
          )
        
        VStack (alignment: .center, spacing: 5) {
          // Movie Title
          Text(entry.latestFavoriteMovie?.title ?? "Movie Title")
            .foregroundColor(Color.white)
            .font(.title)
            .fontWeight(.heavy)
            .shadow(radius: 2)
          
          HStack {
            Spacer()
            
            // Average Rate
            Text("rate-label-string")
              .modifier(WidgetTextLabelModifier())
            Text(String(entry.latestFavoriteMovie?.voteAverage.rounded(toPlaces: 1) ?? 7.1) + " / 10")
              .modifier(WidgetTextModifier())
            
            Spacer()
            
            // Release Date
            Text("released-label-string")
              .modifier(WidgetTextLabelModifier())
            Text(entry.latestFavoriteMovie?.releaseDate ?? "2024-05-30")
              .modifier(WidgetTextModifier())
            
            Spacer()
          }
          
          HStack (alignment: .top, spacing: 17) {
            // Movie poster
            Image(uiImage: uiImage)
              .resizable()
              .scaledToFit()
              .cornerRadius(10)
              .frame(width: 140, height: 230)
            
            // Movie Description
            Text(entry.latestFavoriteMovie?.overview ?? "Movie description")
              .foregroundColor(Color.white)
              .font(.footnote)
              .fontWeight(.medium)
              .multilineTextAlignment(.leading)
              .frame(width: 160, height: 230)
          }
        }
        .padding(.top, 10)
        .padding(.bottom, 10)
        
        
      }
      .widgetURL(URL(string: "moviematch://moviedetail/\(entry.latestFavoriteMovie?.id ?? 0)"))
      
    } else {
      ZStack {
        Image(K.Image.Logo.primaryFull)
          .resizable()
          .scaledToFit()
          .blur(radius: 7)
          .frame(width: 345, height: 355)
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
