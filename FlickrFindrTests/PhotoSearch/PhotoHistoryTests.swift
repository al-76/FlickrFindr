//
//  PhotoHistoryTests.swift
//  FlickrFindrTests
//
//  Created by Vyacheslav Konopkin on 21.01.2023.
//

import Combine
import ComposableArchitecture
import XCTest

@testable import FlickrFindr

@MainActor
final class PhotoHistoryTests: XCTestCase {
    private var store: TestStore<PhotoHistory.State,
                                 PhotoHistory.Action,
                                 PhotoHistory.State,
                                 PhotoHistory.Action, ()>!

    override func setUp() {
        store = TestStore(initialState: .init(),
                          reducer: PhotoHistory())
    }

    func testLoad() async throws {
        // Arrange
        store.dependencies.historyStorage.load = { Answer.success(.stub) }

        // Act
        await store.send(.load)

        // Assert
        await store.receive(.loadResult(.success(.stub))) {
            $0.history = .stub
        }
    }

    func testLoadError() async throws {
        // Arrange
        store.dependencies.historyStorage.load = { Answer.fail() }

        // Act
        await store.send(.load)

        // Assert
        await store.receive(.loadResult(.failure(TestError.someError))) {
            $0.error = StateError(error: TestError.someError)
        }
    }

    func testLoadSkipTwice() async throws {
        // Arrange
        store = TestStore(initialState: .init(history: .stub),
                          reducer: PhotoHistory())
        store.dependencies.historyStorage.load = { Answer.success(.stub) }

        // Act, Assert
        await store.send(.load)
    }

    func testLoadQueryChanged() async throws {
        // Arrange
        let query = "test"

        // Act, Assert
        await store.send(.queryChanged(query)) {
            $0.query = query
        }
    }

    func testSave() async throws {
        // Arrange
        let query = "test"
        let historyId = UUID()
        store = TestStore(initialState: .init(query: query),
                          reducer: PhotoHistory())
        store.dependencies.historyStorage.save = { _ in Answer.success(true) }
        store.dependencies.photoClient.fetch = { _, _ in Answer.success(.stub) }
        store.dependencies.uuid = .constant(historyId)

        // Act
        await store.send(.save) {
            $0.history = [History(id: historyId, text: query)]
        }

        // Assert
        await store.receive(.saveResult(.success(true)))
        await store.receive(.searchAction(.fetch(query))) {
            $0.search.isLoading = true
            $0.search.query = query
        }
    }

    func testSaveSkipEmptyQuery() async throws {
        // Arrange
        store = TestStore(initialState: .init(query: ""),
                          reducer: PhotoHistory())

        // Act, Assert
        await store.send(.save)
    }

    func testSaveSkipDuplicate() async throws {
        // Arrange
        let history = [History].stub.first!
        store = TestStore(initialState: .init(query: history.text,
                                              history: .stub),
                          reducer: PhotoHistory())
        store.dependencies.historyStorage.save = { _ in Answer.success(true) }
        store.dependencies.photoClient.fetch = { _, _ in Answer.success(.stub) }

        // Act
        await store.send(.save)

        // Assert
        await store.receive(.saveResult(.success(false)))
        await store.receive(.searchAction(.fetch(history.text))) {
            $0.search.isLoading = true
            $0.search.query = history.text
        }
    }

    func testSaveError() async throws {
        // Arrange
        let query = "test"
        let historyId = UUID()
        store = TestStore(initialState: .init(query: "test"),
                          reducer: PhotoHistory())
        store.dependencies.historyStorage.save = { _ in Answer.fail() }
        store.dependencies.photoClient.fetch = { _, _ in Answer.success(.stub) }
        store.dependencies.uuid = .constant(historyId)

        // Act
        await store.send(.save) {
            $0.history = [History(id: historyId, text: query)]
        }

        // Assert
        await store.receive(.saveResult(.failure(TestError.someError))) {
            $0.error = StateError(error: TestError.someError)
        }
        await store.receive(.searchAction(.fetch(query))) {
            $0.search.isLoading = true
            $0.search.query = query
        }
    }

    func testFilteredHistory() async throws {
        // Arrange
        let query = "D"
        let expectedHistory: [History] = .stub
            .filter { $0.text.lowercased()
                    .contains(query.lowercased()) }
            .reversed()
        store = TestStore(initialState: .init(query: query,
                                              history: .stub),
                          reducer: PhotoHistory())

        // Act, Assert
        XCTAssertEqual(store.state.filteredHistory, expectedHistory)
    }
}
