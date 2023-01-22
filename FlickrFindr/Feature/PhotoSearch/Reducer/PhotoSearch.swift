//
//  PhotoSearch.swift
//  FlickrFindr
//
//  Created by Vyacheslav Konopkin on 20.01.2023.
//

import Combine
import ComposableArchitecture
import Foundation

struct PhotoSearch: ReducerProtocol {
    struct State: Equatable {
        var query: String = ""
        var photos: [Photo] = []
        var page: Int = 1
        var isLoading = false
        var error: StateError?
    }

    enum Action: Equatable {
        case fetch(String)
        case fetchMore(Photo)
        case fetchResult(TaskResult<[Photo]>)
    }

    @Dependency(\.photoClient) var client

    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case let .fetch(query):
            state.isLoading = true
            state.query = query
            state.page = 1
            state.error = nil
            return reduceFetch(page: state.page, query: query)

        case let .fetchMore(photo):
            guard !state.isLoading, photo == state.photos.last else {
                return .none
            }
            state.isLoading = true
            state.page += 1
            state.error = nil
            return reduceFetch(page: state.page,
                               query: state.query,
                               photos: state.photos)

        case let .fetchResult(.success(photos)):
            state.isLoading = false
            state.photos = photos
            state.error = nil

        case let .fetchResult(.failure(error)):
            state.isLoading = false
            state.page = max(1, state.page - 1)
            state.error = StateError(error: error)
        }

        return .none
    }

    private func reduceFetch(page: Int,
                             query: String,
                             photos: [Photo] = []) -> EffectTask<Action> {
        client
            .fetch(query, page)
            .map { .fetchResult(.success((photos + $0).removeDuplicates())) }
            .catch { Just(.fetchResult(.failure($0))) }
            .receive(on: DispatchQueue.main)
            .eraseToEffect()
    }
}

private extension Array where Element == Photo {
    func removeDuplicates() -> [Photo] {
        NSOrderedSet(array: self).map { $0 as! Photo }
    }
}
