# PokeAPIExplorer

PokeAPIExplorer is a focused SwiftUI networking sample that demonstrates how to request data from a REST API, decode JSON into custom Swift models, paginate through results, and present API-driven content in a searchable user interface.

The project uses the public [PokeAPI](https://pokeapi.co/) and is intended as a technical portfolio sample rather than a full production application.

## Features

- Fetches Pokémon data from a REST API using `URLSession`
- Uses `async/await` for asynchronous networking
- Validates HTTP responses and status codes
- Decodes JSON into custom Swift models
- Demonstrates custom `CodingKeys`
- Handles nested JSON structures
- Loads paginated API results
- Supports incremental loading as the user scrolls
- Includes a "Load All" option
- Provides case-insensitive search
- Displays detail data for individual Pokémon
- Loads remote artwork with `AsyncImage`
- Uses observable state with Swift's Observation framework

## Screenshots

<p align="center">
  <img src="screenshots/PokeScreenshot1.png" width="300">
  <img src="screenshots/PokeScreenshot2.png" width="300">
</p>

## Technologies

- Swift
- SwiftUI
- Observation
- URLSession
- async/await
- Codable / Decodable
- CodingKeys
- HTTP networking
- REST APIs
- JSON decoding
- AsyncImage
- Xcode
- Git

## Architecture

The project uses a lightweight structure centered around API models, observable networking state, and SwiftUI views.

### `Creature`

`Creature` represents an individual Pokémon returned by the API.

The model conforms to `Decodable` and `Identifiable`, with stable identity derived from the Pokémon's API URL.

It also demonstrates custom decoding by defining explicit `CodingKeys` and a custom `init(from:)`.

### `Creatures`

`Creatures` manages the paginated Pokémon list.

Responsibilities include:

- Requesting the next API page
- Tracking loading state
- Decoding API responses
- Maintaining the loaded creature collection
- Updating pagination state
- Loading additional results as needed
- Loading the complete result set on request

The observable state is isolated to the main actor, while asynchronous networking suspends while requests are in progress.

### `CreatureDetail`

`CreatureDetail` loads detail information for a selected Pokémon.

The API response contains nested JSON structures, which are represented with nested `Decodable` types.

Custom `CodingKeys` map API keys such as:

```swift
case officialArtwork = "official-artwork"
case frontDefault = "front_default"
```

to Swift-style property names.

### Views

The primary views are:

- `CreaturesListView` — displays, searches, and paginates the Pokémon collection
- `DetailView` — presents data and artwork for a selected Pokémon

## Networking

API requests are performed using `URLSession` and Swift concurrency:

```swift
let (data, response) = try await URLSession.shared.data(from: url)
```

Responses are validated as `HTTPURLResponse` values before decoding:

```swift
guard let httpResponse = response as? HTTPURLResponse else {
    return
}

guard (200...299).contains(httpResponse.statusCode) else {
    return
}
```

This ensures that JSON decoding only occurs after a successful HTTP response.

## JSON Decoding

The project uses Swift's `Decodable` system to convert API JSON into strongly typed Swift models.

When JSON keys differ from Swift naming conventions, custom `CodingKeys` provide the mapping.

For example:

```json
{
  "front_default": "https://..."
}
```

is represented in Swift as:

```swift
let frontDefault: String?

enum CodingKeys: String, CodingKey {
    case frontDefault = "front_default"
}
```

The project also includes a custom decoder initializer for `Creature` so its stable identifier can be derived from decoded API data.

## Pagination

PokeAPI returns results in pages and provides the URL for the next page.

`PokeAPIExplorer` stores that next-page URL and continues loading while another page is available.

Additional results can be loaded automatically when the user reaches the end of the current list:

```swift
await creatures.loadNextIfNeeded(creature: creature)
```

The app also provides a "Load All" action that repeatedly requests pages until no next-page URL remains.

## Search

Loaded Pokémon can be filtered using case-insensitive search:

```swift
creatures.creaturesArray.filter {
    $0.name.localizedCaseInsensitiveContains(searchText)
}
```

Filtering happens against the locally loaded data and does not require an additional API request.

## Concurrency

The observable networking model is marked `@MainActor` because it owns state consumed directly by SwiftUI:

```swift
@Observable
@MainActor
class Creatures {
```

Properties such as the loaded creature array and loading state can be read by the UI while mutation remains controlled by the model.

The application uses `async/await` instead of callback-based networking.

## What This Project Demonstrates

PokeAPIExplorer demonstrates:

- REST API consumption in Swift
- URL construction and validation
- `URLSession`
- Swift concurrency with `async/await`
- HTTP response and status-code handling
- JSON decoding with `Decodable`
- Custom `CodingKeys`
- Custom `init(from:)` decoding
- Nested JSON modeling
- Stable identity for API models
- Pagination
- Infinite-style incremental loading
- Observable UI state
- `@MainActor` isolation
- Search and filtering
- Remote image loading
- Navigation between API-driven views
- Refactoring an earlier networking project into a cleaner portfolio sample

## Project Background

PokeAPIExplorer began as a small learning project focused on retrieving and decoding remote JSON data.

It was later revisited and refactored as a public portfolio sample with an emphasis on clearer networking practices and modern Swift conventions.

The refactor included:

- Improved model identity
- More deliberate use of `CodingKeys`
- Swift-style property naming
- `Decodable` response models
- HTTP response validation
- Status-code checking
- Improved error handling
- Main-actor isolation for observable UI state
- Cleaner pagination logic
- Removal of unnecessary recursive task creation
- Improved search behavior
- Simplified SwiftUI list and detail views

## Requirements

- Xcode 16 or later
- iOS 17 or later
- Swift 5.9 or later

## Running the Project

1. Clone the repository:

```bash
git clone https://github.com/Brett-Buchholz/PokeAPIExplorer.git
```

2. Open the Xcode project.

3. Select an iPhone simulator or connected iOS device.

4. Build and run the project.

An internet connection is required to retrieve data from PokeAPI.

No API key is required.

## API

This project uses the public [PokeAPI](https://pokeapi.co/).

PokeAPIExplorer is an unofficial educational and portfolio project and is not affiliated with or endorsed by The Pokémon Company, Nintendo, Game Freak, or Creatures Inc.

Pokémon names and related trademarks belong to their respective owners.

## Future Improvements

Potential future improvements include:

- Networking unit tests with mocked responses
- JSON decoding tests using local fixtures
- User-facing error states
- Retry behavior for failed requests
- Additional detail information
- Dependency injection for networking
- Improved accessibility

## Author

**Brett Buchholz**

iOS Developer focused on Swift, SwiftUI, and UIKit.

- [GitHub Profile](https://github.com/Brett-Buchholz)
- [LinkedIn](https://www.linkedin.com/in/brett-buchholz-448b38425)
