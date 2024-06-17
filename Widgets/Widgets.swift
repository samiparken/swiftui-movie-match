import WidgetKit
import SwiftUI
import SwiftData

struct Provider: AppIntentTimelineProvider {
  //MARK: - METHOD
  @MainActor //main thread
  private func getLatestFavoriteMovie() -> FavoriteMovie? {
    guard let modelContainer = try? ModelContainer(for: FavoriteMovie.self) else { return nil }
    let fetchDescriptor = FetchDescriptor<FavoriteMovie>()
    let latestFavoriteMovie = try? modelContainer.mainContext.fetch(fetchDescriptor).last
    return latestFavoriteMovie ?? nil
  }
  
  func fetchImage(imageUrl: String) async -> UIImage? {
    guard let imageUrl = URL(string: imageUrl) else { return nil }
    do {
      async let (data, _) = URLSession.shared.data(from: imageUrl)
      return try await UIImage(data: data)
    } catch {
      print("Error fetching Widget Image data: \(error)")
      return nil
    }
  }
  
  //MARK: - PLACEHOLDER
  // when data is not available
  // first added to the home screen or during widget reloading.
  @MainActor
  func placeholder(in context: Context) -> SimpleEntry {
    SimpleEntry(date: Date(),
                configuration: ConfigurationAppIntent(),
                latestFavoriteMovie: nil,
                moviePosterImage: nil)
  }
  
  //MARK: - SNAPSHOT
  // quick preview when browsing widget to add to the home screen
  func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
    SimpleEntry(date: Date(),
                configuration: configuration,
                latestFavoriteMovie: SampleData.favoriteMovie,
                moviePosterImage: UIImage(named: "sampleData_movie_poster")!)
  }
  
  //MARK: - TIMELINE
  // a sequence of entries that defines the data for widget over time
  func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
    
    // Get Latest Favorite Movie Image
    async let movie = getLatestFavoriteMovie()
    let url = await movie?.posterPath?.toImageUrl() ?? ""
    async let uiImage = fetchImage(imageUrl: url)
    
    // Organize Timeline
    var entries: [SimpleEntry] = []
    let entry = await SimpleEntry(date: Date(),
                                  configuration: configuration,
                                  latestFavoriteMovie: movie,
                                  moviePosterImage: uiImage)
    entries.append(entry)
    return Timeline(entries: entries, policy: .never)
  }
}

//MARK: - ENTRY
// for data
struct SimpleEntry: TimelineEntry {
  let date: Date
  let configuration: ConfigurationAppIntent
  let latestFavoriteMovie: FavoriteMovie?
  let moviePosterImage: UIImage?
}

//MARK: - VIEW
struct WidgetsEntryView : View {
  @Environment(\.widgetFamily) var widgetSize
  var entry: Provider.Entry
    
  //MARK: - BODY
  var body: some View {
    switch widgetSize {
      
    //MARK: - SMALL SIZE
    case .systemSmall:
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
              .frame(height: 115) // Set the desired frame size
          }
        }
        .widgetURL(URL(string: "moviematch://moviedetail/\(entry.latestFavoriteMovie?.id ?? 0)"))

      } else {
        ZStack {
          Image(K.Image.Logo.primaryFull)
            .resizable()
            .scaledToFill()
            .blur(radius: 7) // Adjust the radius to control the blur intensity
            .frame(width: 165, height: 165) // Set the desired frame size
            .clipped() // Ensure the image doesn't overflow its frame
            .overlay(
              Color.black.opacity(0.3) // dark layer
            )

          Text("Tap to refresh")
            .foregroundColor(Color.white)
            .font(.title3)
            .fontWeight(.heavy)
            .shadow(radius: 2)
        }
      }
      
      
      
      //MARK: - MEDIUM SIZE
    case .systemMedium:
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
              .frame(height: 125) // Set the desired frame size
            
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
            .blur(radius: 7) // Adjust the radius to control the blur intensity
            .frame(width: 345, height: 165) // Set the desired frame size
            .clipped() // Ensure the image doesn't overflow its frame
            .overlay(
              Color.black.opacity(0.3) // dark layer
            )

          Text("Tap to refresh")
            .foregroundColor(Color.white)
            .font(.title3)
            .fontWeight(.heavy)
            .shadow(radius: 2)
        }
      }
      

//MARK: - LARGE SIZE
    case .systemLarge:
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
            .blur(radius: 7) // Adjust the radius to control the blur intensity
            .frame(width: 345, height: 355) // large
            .clipped() // Ensure the image doesn't overflow its frame
            .overlay(
              Color.black.opacity(0.3) // dark layer
            )

          Text("Tap to refresh")
            .foregroundColor(Color.white)
            .font(.title3)
            .fontWeight(.heavy)
            .shadow(radius: 2)
        }
      }
      
      
      
      
    default:
      VStack {
        Text(entry.configuration.favoriteSymbol)
        //Text(entry.favoriteMovie?.title ?? "Movie Title")
      }
      
    }
  }
}



//MARK: - WIDGET
struct Widgets: Widget {
  let kind: String = "Widgets"
  
  var body: some WidgetConfiguration {
    AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
      WidgetsEntryView(entry: entry)
        .containerBackground(.background, for: .widget)
    }
    .configurationDisplayName("Movie Match Widget")
    .description("Movie Match Widget")
  }
}

extension ConfigurationAppIntent {
  fileprivate static var withHeart: ConfigurationAppIntent {
    let intent = ConfigurationAppIntent()
    intent.favoriteSymbol = "❤️"
    return intent
  }
}

//MARK: - PREVIEW
#Preview(as: .systemLarge) {
  Widgets()
} timeline: {
  SimpleEntry(date: .now,
              configuration: .withHeart,
              latestFavoriteMovie: nil,
              moviePosterImage: nil)
}
