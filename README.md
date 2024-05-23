# Tinder-like Movie Match iOS Demo App

Discover and organize your favorite movies effortlessly. Swipe right to save a movie, swipe left to pass. Access detailed movie information with a simple tap. Enjoy support for 3 languages (English, Swedish, and Korean) and a sleek dark mode.

## DEMO

## Specification
SwiftUI, iOS 17.0 or later
all the movie data from TMDB Open Source API (https://developer.themoviedb.org/docs/getting-started)

## Installation
1. Clone the repository
   ```sh
   git clone https://github.com/samiparken/swiftui-movie-match.git
   ```
2. Build and Run
- Just build and run! It doesn't require any 3rd party libraries and dependencies.

## Usage
###  Main View
- Swipe Right: Save a movie to your favorites.
- Swipe Left: Pass on a movie.
- Tap the Refresh Button: Reload the movie cards.

### Movie Details
- Tap on a Movie Card: View detailed information about the movie.

### Favorites
- Navigate the Movies: Browse through your list of favorite movies.
- Remove Favorites: Remove a movie from your favorites list by tapping the button.

### Settings
- Change Language: Select from 3 supported languages: English, Swedish, and Korean.
- Change Appearance: Toggle between light and dark mode for a personalized viewing experience.

## Implementation
### MVVM design pattern
This app is developed using the Model-View-ViewModel (MVVM) design pattern, leveraging SwiftUI for a modern and reactive user interface. One of the key design decisions was to avoid having many controllers, which are common in the Model-View-Controller (MVC) pattern. Instead, MVVM allows for better separation of concerns and more manageable code

### API
The app utilizes 2 endpoints to organize views.
- https://api.themoviedb.org/3/movie/popular
- https://api.themoviedb.org/3/movie/movie_id
