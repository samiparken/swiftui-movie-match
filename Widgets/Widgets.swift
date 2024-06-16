import WidgetKit
import SwiftUI
import SwiftData

struct Provider: AppIntentTimelineProvider {
  // MARK: - SwiftData
  // +TODO: remove if not needed
  //@Environment(\.modelContext) private var context
  
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
                moviePosterImage: nil)
  }
  
  //MARK: - SNAPSHOT
  // quick preview when browsing widget to add to the home screen
  func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
    SimpleEntry(date: Date(),
                configuration: configuration,
                moviePosterImage: nil)
  }
  
  //MARK: - TIMELINE
  // a sequence of entries that defines the data for widget over time
  func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
    
    // Get Latest Favorite Movie Image
    async let url = getLatestFavoriteMovie()?.posterPath?.toImageUrl() ?? ""
    let uiImage = await fetchImage(imageUrl: url)
    
    // Organize Timeline
    var entries: [SimpleEntry] = []
    let entry = SimpleEntry(date: Date(),
                            configuration: configuration,
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
  let moviePosterImage: UIImage?
}

//MARK: - VIEW
struct WidgetsEntryView : View {
  @Environment(\.widgetFamily) var widgetSize
  var entry: Provider.Entry
  
  var body: some View {
    switch widgetSize {
      
    case .systemSmall:
      VStack (spacing: 5) {
        Text("Small")
        Text(entry.configuration.favoriteSymbol)
        //Text(entry.favoriteMovie?.title ?? "Movie Title")
      }
      
    case .systemMedium:
      ZStack {
        
        if let uiImage = entry.moviePosterImage {
          Image(uiImage: uiImage)
            .resizable()
            .cornerRadius(24)
            .scaledToFill()
            .frame(width: UIScreen.main.bounds.width)
        } else {
          Image(K.Image.Logo.primaryFull)
            .resizable()
            .scaledToFit()
        }
        
        Text(entry.configuration.favoriteSymbol)
      }
      
    case .systemLarge:
      ZStack {
        
        if let uiImage = entry.moviePosterImage {
          Image(uiImage: uiImage)
            .resizable()
            .cornerRadius(24)
            .scaledToFill()
        } else {
          Image(K.Image.Logo.primaryFull)
            .resizable()
            .scaledToFit()
        }
        
        Text(entry.configuration.favoriteSymbol)
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
              moviePosterImage: nil)
}
