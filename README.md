# FlickrFindr
 
Hi!

## Dependencies
- TCA - Architecture, DI, tests
- SDWebImageSwiftUI - Image loading.
Indeed, there's AsyncImage but it's buggy (like cancel error in lists on iOS 16) and not so good with caching

## Implementation notes
* The project has the following structure:<br>
**Feature/** - directory contains features. Every feature has reducers (domain) and views. There's only the PhotoSearch feature.<br>
**Effect/** - directory contains different side effects like clients, repositories, storage, DB, and any other services. Also, effects contain data models (in some cases data models can be shared). Here, all models are related to services like **Effect/PhotoClient/Model**)
* Interface of every **effect** presented like **struct** and impelementation contained in a property with **AnyPublisher** type. Every effect contains live, preview, and test implementation. For example, interface - **HistoryStorage.swift**, live - **LiveHistoryStorage.swift**, preview and test - **StubHistoryStorage.swift** in **Effect/HistoryStorage**
* Also, every data model has a stub for preview and tests. For example, **HistoryStorage/Model/StubHistoryModel.swift**
* In perspective, every feature, effect, or module could be presented as an SPM module if we need modularization.

## Implemented functional requirements
* An interface for inputting search terms
* Display 25 results for the given search term, including a thumbnail of the image and the title
* Selecting a thumbnail or title displays the full photo
* Provide a way to return to the search results
* Provide a way to search for another term

## Implemented extra mile
* *Save prior search terms and present them as quick search options*<br>
I used files because saving data have a flat simple structure
* Page results (allowing more than the initial 25 to be displayed)
* *Sensible error handling and unit testing*<br>
Errors are handled and displayed as an overlay view.<br>
Unit tests cover only the domain. It's reducers in **Feature/PhotoSearch**.
* *Use only system frameworks for network requests and parsing*<br>
I used standard URLSession, JSONDecoder

Thanks!
