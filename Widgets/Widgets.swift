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
  
  //MARK: - PLACEHOLDER
  // when data is not available
  // first added to the home screen or during widget reloading.
  @MainActor 
  func placeholder(in context: Context) -> SimpleEntry {
    SimpleEntry(date: Date(),
                configuration: ConfigurationAppIntent(),
          favoriteMovie: getLatestFavoriteMovie())
  }
  
  //MARK: - SNAPSHOT
  // quick preview when browsing widget to add to the home screen
  func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
    await SimpleEntry(date: Date(),
                configuration: configuration,
                favoriteMovie: getLatestFavoriteMovie())
  }
  
  //MARK: - TIMELINE
  // a sequence of entries that defines the data for widget over time
  func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
    var entries: [SimpleEntry] = []
    let entry = await SimpleEntry(date: Date(),
                            configuration: configuration,
                            favoriteMovie: getLatestFavoriteMovie())
    entries.append(entry)
    
    return Timeline(entries: entries, policy: .never)
  }
}

//MARK: - ENTRY
// for data
struct SimpleEntry: TimelineEntry {
  let date: Date
  let configuration: ConfigurationAppIntent
  let favoriteMovie: FavoriteMovie?
}

//MARK: - VIEW
struct WidgetsEntryView : View {
  @Environment(\.widgetFamily) var widgetSize
  var entry: Provider.Entry
  
  var body: some View {
    switch widgetSize {
      
      //+TODO: create a widget view for each size
      
    case .systemSmall:
      VStack (spacing: 5) {
        Text("Small")
        Text(entry.configuration.favoriteSymbol)
        Text(entry.favoriteMovie?.title ?? "Movie Title")
      }

    case .systemMedium:
      VStack (spacing: 5) {
        Text("Medium")
        Text(entry.configuration.favoriteSymbol)
        Text(entry.favoriteMovie?.title ?? "Movie Title")
      }

    case .systemLarge:
      WidgetView(widgetSize: .large)
        .environment(FavoriteMovieViewModel(favoriteMovie: entry.favoriteMovie!))
      
//      VStack (spacing: 5) {
//        Text("Large")
//        Text(entry.configuration.favoriteSymbol)
//        Text(entry.favoriteMovie?.title ?? "Movie Title")
//      }

    default:
      VStack {
        Text(entry.configuration.favoriteSymbol)
        Text(entry.favoriteMovie?.title ?? "Movie Title")
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
              favoriteMovie: nil)
}
