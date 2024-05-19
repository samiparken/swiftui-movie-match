import Foundation
import SwiftUI

class MovieManager: ObservableObject {
    
    @Published var movieResponse: MovieResponse?
    @Published var result: String = ""
    @Published var hearts: String = ""
    @Published var buttonText: String = "TRY"
    
    init() {
        fetchPopularMovieList()
    }
    
    func fetchPopularMovieList() {
        Task {
            do {
                self.movieResponse = try await APIgetPopularMovieList(1)
            } catch {
                print("Failed to fetch popular movies: \(error)")
            }
        }
    }
}
