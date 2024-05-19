//
//  ContentView.swift
//  swiftui-movie-match
//
//  Created by Han-Saem Park on 2024-05-19.
//

import SwiftUI
import SwiftData

struct ContentView: View {
  
  //MARK: - PROPERTIES
  
  @Environment(\.modelContext) private var modelContext
  @Query private var items: [Item]
  @StateObject var movieManager = MovieManager()
  
  var body: some View {
    NavigationSplitView {
      List {
        
        if let movieResponse = movieManager.movieResponse {
          ForEach(movieResponse.results) { item in
            Text(item.title)
          }
        } else {
          
        }
        
      }
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          EditButton()
        }
        ToolbarItem {
          Button(action: addItem) {
            Label("Add Item", systemImage: "plus")
          }
        }
      }
    } detail: {
      Text("Select an item")
    }
  }
  
  private func addItem() {
    withAnimation {
      let newItem = Item(timestamp: Date())
      modelContext.insert(newItem)
    }
  }
  
  private func deleteItems(offsets: IndexSet) {
    withAnimation {
      for index in offsets {
        modelContext.delete(items[index])
      }
    }
  }
}

#Preview {
  ContentView()
    .modelContainer(for: Item.self, inMemory: true)
}
