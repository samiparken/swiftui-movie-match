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
      WidgetSmall(entry: entry)
      
      //MARK: - MEDIUM SIZE
    case .systemMedium:
      WidgetMedium(entry: entry)
      
      //MARK: - LARGE SIZE
    case .systemLarge:
      WidgetLarge(entry: entry)
      
      //MARK: - DEFAULT
    default:
      VStack {
        Spacer()
        Text("No support Extra Large")
          .foregroundColor(Color.black)
          .font(.title3)
          .fontWeight(.heavy)
          .shadow(radius: 2)
        Spacer()
      }
    }
    
  }
}

//MARK: - WIDGETS
struct Widgets: Widget {
  let kind: String = "Widgets"
  
  var body: some WidgetConfiguration {
    AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
      WidgetsEntryView(entry: entry)
        .containerBackground(.background, for: .widget)
    }
    .configurationDisplayName("Latest Favorite Movie")
    .description("This widget shows your latest favorite movie.")
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
#Preview(as: .systemSmall) {
  Widgets()
} timeline: {
  SimpleEntry(date: .now,
              configuration: .withHeart,
              latestFavoriteMovie: nil,
              moviePosterImage: nil)
}
