# Movies App
![Application version](https://img.shields.io/badge/application%20version-v1.0.0-blue)
![Swift version](https://img.shields.io/badge/Swift-%205.4-orange)
![Xcode version](https://img.shields.io/badge/Xcode-%2012.5-yellow)
![Platforms](https://img.shields.io/badge/platforms-iOS%20-lightgrey.svg)

MoviesApp is an application that shows movie details.

## Architecture

![Screenshot](https://github.com/liort2020/MoviesApp/blob/master/Assets/MoviesAppArchitecture.png)

This application is implemented in MVVM and Clean architecture with three layers:
- **Presentation layer**
  - Contains `Views` and cells.
  - `RealMoviesListViewModel` - Connect between presentation layer and data layer. `RealMoviesListViewModel` and `MockedMoviesListViewModel` (For Tests) - Implement `MoviesListViewModel` protocol (Strategy design pattern).
  - `RealMovieDetailsViewModel` - Connect between presentation layer and data layer. `RealMovieDetailsViewModel` and `MockedMovieDetailsViewModel` (For Tests) - Implement `MovieDetailsViewModel` protocol (Strategy design pattern).
  - `MoviesListViewRouting` and `MovieDetailsViewRouting` control navigation between views (ViewRouting contains them).
  
- **Domain layer**
  - `RealMoviesInteractor` - Connect between presentation layer and data layer. `RealMoviesInteractor` and `MockMoviesInteractor` (For Tests) - Implement `MoviesInteractor` protocol (Strategy design pattern).
  - `MoviesListWebModel`- Model that we got from the server, implements `MovieModel` and `Codable`.
  
- **Data Layer**
  - **WebRepositories**:
  - `WebRepository` - Retrieves data from the server using `dataTaskPublisher`.
  - `MoviesWebRepository` - Allow us to get all movies, implements `WebRepository` protocol. `RealMoviesWebRepository` and `MockMoviesWebRepository` (For Tests) - Implement `MoviesWebRepository` protocol (Strategy design pattern).
  - `RealMoviesWebRepository` - Allow us to communicate with the server using URLSession, implements `MoviesWebRepository` protocol.
  - `ImagesWebRepository` - Allow us to download the image. `RealImagesWebRepository` and `MockImagesWebRepository` (For Tests) - Implement `ImagesWebRepository` protocol (Strategy design pattern).
  - `RealImagesWebRepository` - Allow us to communicate with the server using URLSession, implements `ImagesWebRepository` protocol.
  - `WebError` - The error that `WebRepository` can throw.
  - `Endpoint` - Prepares the URLRequest to connect to the server (`MoviesEndpoint` and `ImagesEndpoint` implement this protocol).
  - `HTTPMethod` - The HTTP methods that allow in this application.
  - `MockMoviesWebRepository` (For Tests) - Allow us to communicate with fake server, implements `MoviesWebRepository` and `TestWebRepository`.
  - `MockImagesWebRepository` (For Tests) - Allow us to communicate with fake server, implements `ImagesWebRepository` and `TestWebRepository`.
  - `TestWebRepository` (For Tests) - Retrieves data from fake server using mocked session, implements `WebRepository`.
  - `MockURLProtocol` (For Tests) - Get request and return mock response, implements `URLProtocol`.
  - `MockWebError` (For Tests) - The error that `TestWebRepository` can throw.
  
   - **DBRepositories**:
  - `PersistentStore` - Allow us to fetch, update, add image and delete items from `CoreData` database. `CoreDataStack` and `MockPersistentStore` (For Tests) - Implement `PersistentStore` protocol (Strategy design pattern).
  - `CoreDataStack` - Allow access to `CoreData` storage, implements `PersistentStore`.
  - `MockPersistenceController` (For Tests) - Allow access to in-memory storage for testing, implements `PersistentStore`.
  - `MoviesDBRepository` - Allow us to fetch, save, update and delete movies. `RealMoviesDBRepository` and `MockMoviesDBRepository` (For Tests) - Implement `MoviesDBRepository` protocol (Strategy design pattern).
  - `RealMoviesDBRepository` - Allow us to use `CoreDataStack` to get all items from `CoreData`, implements `MoviesDBRepository`.
  -  `MockMoviesDBRepository` (For Tests) - Allow us to use `MockPersistenceController` to get all items from in-memory storage, implements `MoviesDBRepository`.
  - `Movie` - Model that we save in `CoreData` database, this model is shown in `Views`. `Movie` model inherit from `NSManagedObject` class and implements `Identifiable` protocol.
  
- **System**
  - `MoviesApp` - An entry point to this application.
  - `DIContainer` – Help us to inject the dependencies (Dependency injection design patterns) holds the `Interactors`, `DBRepositories`, `WebRepositories` and  `AppState`.
  - `AppState` - Contains `ViewRouting` that control navigation between views.
  
  
## Server API
- Get a list of upcoming movies
  - HTTP Method: `GET`
  - URL: [`https://developers.themoviedb.org/3/movie/upcoming?api_key={api_key}&page={page}`](https://api.themoviedb.org/3/movie/upcoming?api_key=2578a81bfe04d4856dfe3525aab74e17&page=1)
  
- Get a list of top rated movies
  - HTTP Method: `GET`
  - URL: [`https://developers.themoviedb.org/3/movie/top_rated?api_key={api_key}&page={page}`](https://api.themoviedb.org/3/movie/top_rated?api_key=2578a81bfe04d4856dfe3525aab74e17&page=1)

- Get a list of now playing movies
  - HTTP Method: `GET`
  - URL: [`https://developers.themoviedb.org/3/movie/now_playing?api_key={api_key}&page={page}`](https://api.themoviedb.org/3/movie/now_playing?api_key=2578a81bfe04d4856dfe3525aab74e17&page=1)
  
  - Get a movie poster
    - HTTP Method: `GET`
    - URL: [`https://image.tmdb.org/t/p/original/{poster_path}`](https://image.tmdb.org/t/p/original/cycDz68DtTjJrDJ1fV8EBq2Xdpb.jpg)
  
  
## Dependencies - Pods
  - We use [`URLImage`](https://cocoapods.org/pods/URLImage#download-an-image-in-ios-14-widget) SwiftUI view that displays an image downloaded from provided URL.
  
  
## Installation
### System requirement
- iOS 14.0 or later

### Install and Run the MoviesApp applciation
1. Install [`CocoaPods`](https://cocoapods.org) - This is a dependency manager for Swift and Objective-C projects for Apple's platforms. 
You can install it with the following command:

```bash
$ gem install cocoapods
```

2. Navigate to the project directory and install pods from `Podfile` with the following command:

```bash
$ pod install
```

3. Open the `MoviesApp.xcworkspace` file that was created and run it in Xcode
    
    
## Tests

### Unit Tests
Run unit tests:
1. Navigate to `MoviesAppTests` target

2. Run the test from `Product` ➞ `Test` or use `⌘U` shortcuts

### Performance Tests
Run performance tests:
1. Navigate to `MoviesAppPerformanceTests` target

2. Run the test from `Product` ➞ `Test` or use `⌘U` shortcuts

### UI Tests
Run UI tests:
1. Navigate to `MoviesAppUITests` target

2. Run the test from `Product` ➞ `Test` or use `⌘U` shortcuts
