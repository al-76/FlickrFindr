//
//  PhotoSearchTests.swift
//  FlickrFindrTests
//
//  Created by Vyacheslav Konopkin on 20.01.2023.
//

import Combine
import ComposableArchitecture
import XCTest

@testable import FlickrFindr

@MainActor
final class PhotoSearchTests: XCTestCase {
    private var store: TestStore<PhotoSearch.State,
                                 PhotoSearch.Action,
                                 PhotoSearch.State,
                                 PhotoSearch.Action, ()>!

    override func setUp() {
        store = TestStore(initialState: .init(),
                          reducer: PhotoSearch())
    }

    func testFetch() async {
        // Arrange
        let query = "test"
        store.dependencies.photoClient.fetch = { _, _ in Answer.success(.stub) }

        // Act
        await store.send(.fetch(query)) {
            $0.isLoading = true
            $0.query = query
        }

        // Assert
        await store.receive(.fetchResult(.success(.stub))) {
            $0.isLoading = false
            $0.photos = .stub
        }
    }

    func testFetchError() async {
        // Arrange
        let query = "test"
        store.dependencies.photoClient.fetch = { _, _ in Answer.fail() }

        // Act
        await store.send(.fetch(query)) {
            $0.isLoading = true
            $0.query = query
        }

        // Assert
        await store.receive(.fetchResult(.failure(TestError.someError))) {
            $0.isLoading = false
            $0.error = StateError(error: TestError.someError)
        }
    }

    func testFetchMore() async {
        // Arrange
        let allData = [Photo].stub
        let data = Array(allData[..<(allData.count - 1)])
        let addData = Array(allData[(allData.count - 1)...])
        store = TestStore(initialState: .init(photos: data),
                          reducer: PhotoSearch())
        store.dependencies.photoClient.fetch = { _, _ in Answer.success(addData) }

        // Act
        await store.send(.fetchMore(data.last!)) {
            $0.isLoading = true
            $0.page = 2
        }

        // Assert
        await store.receive(.fetchResult(.success(data + addData))) {
            $0.isLoading = false
            $0.page = 2
            $0.photos = data + addData
        }
    }

    func testFetchMoreSkipNotLast() async {
        // Arrange
        store.dependencies.photoClient.fetch = { _, _ in Answer.nothing() }

        // Act, Assert
        await store.send(.fetchMore(.stub))
    }

    func testFetchMoreSkipIsLoading() async {
        // Arrange
        store = TestStore(initialState: .init(isLoading: true),
                          reducer: PhotoSearch())
        store.dependencies.photoClient.fetch = { _, _ in Answer.nothing() }

        // Act, Assert
        await store.send(.fetchMore(.stub))
    }

    func testFetchMoreError() async {
        // Arrange
        let last = [Photo].stub.last!
        store = TestStore(initialState: .init(photos: .stub),
                          reducer: PhotoSearch())
        store.dependencies.photoClient.fetch = { _, _ in Answer.fail() }

        // Act
        await store.send(.fetchMore(last)) {
            $0.isLoading = true
            $0.page = 2
        }

        // Assert
        await store.receive(.fetchResult(.failure(TestError.someError))) {
            $0.isLoading = false
            $0.page = 1
            $0.error = StateError(error: TestError.someError)
        }
    }
}
