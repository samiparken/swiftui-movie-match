//
//  ContentView.swift
//  swiftui-movie-match
//
//  Created by Han-Saem Park on 2024-05-19.
//

import SwiftUI
import SwiftData

struct ContentView: View {
  
  //MARK: - SwiftUIData
  @Environment(\.modelContext) private var modelContext
  @Query private var items: [Item]

  //MARK: - PROPERTIES
  @StateObject var movieManager = MovieManager()
  
  var body: some View {
    
    VStack {
      
      Spacer()
      
      ZStack{
        ForEach(movieManager.movieList) { cardView in
          cardView
            .zIndex(self.isTopCard(cardView: cardView) ? 1 : 0)
          // Show Symbol
            .overlay(
              ZStack {
                // X-MARK SYMBOL
                Image(systemName: "x.circle")
                  .modifier(SymbolModifier())
                  .opacity(self.dragState.translation.width < -self.dragAreaThreshold
                           && self.isTopCard(cardView: cardView) ? 1.0 : 0.0)
                                
                // HEART SYMBOL
                Image(systemName: "heart.circle")
                  .modifier(SymbolModifier())
                  .opacity(self.dragState.translation.width > self.dragAreaThreshold
                           && self.isTopCard(cardView: cardView) ? 1.0 : 0.0)
              }
            )
          // Drag offset
            .offset(x: self.isTopCard(cardView: cardView)
                    ? self.dragState.translation.width : 0,
                    y: self.isTopCard(cardView: cardView)
                    ? self.dragState.translation.height : 0)
          // Scale (before animation)
            .scaleEffect(self.isTopCard(cardView: cardView)
                         && self.dragState.isDragging ? 0.85 : 1.0)
          //Rotation (before animation)
            .rotationEffect(Angle(degrees:
                                    self.isTopCard(cardView: cardView)
                                  ? Double(self.dragState.translation.width / 12)
                                  : 0))
          //Animation (spring effect)
            .animation(.interpolatingSpring(stiffness: 120, damping: 120), value: dragState.isDragging)
          //Gesture
            .gesture(LongPressGesture(minimumDuration: 0.01)
              .sequenced(before: DragGesture())
              .updating(self.$dragState,
                        body: { (value, state, transaction) in
              switch value {
              case .first(true):
                state = .pressing
              case .second(true, let drag):
                state = .dragging(transition: drag?.translation ?? .zero)
              default:
                break
              }
            })
                // While doing gesture
                .onChanged({(value) in
                  guard case .second(true, let drag?) = value else { return }
                  if drag.translation.width < -self.dragAreaThreshold {
                    self.cardRemovalTransition = .leadingBottom
                  } else if drag.translation.width > self.dragAreaThreshold {
                    self.cardRemovalTransition = .trailingBottom
                  }
                })
                // End of Gesture - action
                .onEnded({ (value) in
                  guard case .second(true, let drag?) = value else { return }
                  if drag.translation.width < -self.dragAreaThreshold
                      || drag.translation.width > self.dragAreaThreshold {
                    self.moveCards()
                  }
                })
            )
            // transition after the gesture
            .transition(self.cardRemovalTransition)
        }
      }
      .padding(.horizontal)
      
      Spacer()

      
      
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
