import SwiftUI

struct CardView: View, Identifiable {
  let id = UUID() //for Identifiable
  var movie: Movie = Movie()
  
  var body: some View {
    AsyncImage(
      url: URL(string: movie.posterPath!.toImageUrl())) { phase in
        switch phase {
        case .empty:
          // Placeholder view while loading
          Text("empty")
        case .success(let image):
          // Success: Show the image
          image
            .resizable()
            .cornerRadius(24)
            .scaledToFit()
            .frame(minWidth: 0, maxWidth: .infinity)
            .overlay(
              VStack(alignment: .center, spacing: 12) {
                Text(movie.title.uppercased()) //title
                  .foregroundColor(Color.white)
                  .font(.largeTitle)
                  .fontWeight(.bold)
                  .shadow(radius: 1)
                  .padding(.horizontal, 18)
                  .padding(.vertical, 4)
                  .overlay(
                    Rectangle()
                      .fill(Color.white)
                      .frame(height: 1),
                    alignment: .bottom
                  )
                Text(movie.overview) // overview
                  .foregroundColor(Color.black)
                  .font(.footnote)
                  .fontWeight(.bold)
                  .frame(minWidth: 85)
                  .padding(.horizontal, 10)
                  .padding(.vertical, 5)
                  .background(
                    Capsule().fill(Color.white)
                  )
              }
                .frame(minWidth: 280) //VStack frame
                .padding(.bottom, 50), //VStack padding
              alignment: .bottom //VStack alignment
            )
        case .failure:
          // Error: Show placeholder or error message
          Text("Failed to load image")
        @unknown default:
          // Placeholder view while loading
          Text("Placeholder")
        }
      }
  }
}

struct CardView_Previews: PreviewProvider{
  static var previews: some View {
    CardView(movie: Movie())
      .previewLayout(.fixed(width: 375, height: 600))
  }
}
