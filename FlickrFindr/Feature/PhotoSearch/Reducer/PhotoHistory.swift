//
//  PhotoHistory.swift
//  FlickrFindr
//
//  Created by Vyacheslav Konopkin on 21.01.2023.
//

import Combine
import ComposableArchitecture
import Foundation

struct PhotoHistory: ReducerProtocol {
    struct State: Equatable {
        var query: String = ""
        var history: [History] = []
        var filteredHistory: [History] {
            history
                .filter(by: query)
                .reversed()
        }
        var error: StateError?

        var search: PhotoSearch.State = .init()
    }

    enum Action: Equatable {
        case load
        case loadResult(TaskResult<[History]>)
        case queryChanged(String)
        case save
        case saveResult(TaskResult<Bool>)

        case searchAction(PhotoSearch.Action)
    }

    @Dependency(\.historyStorage) var storage
    @Dependency(\.uuid) var uuid

    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.search, action: /Action.searchAction) {
            PhotoSearch()
        }

        Reduce { state, action in
            switch action {
            case .load:
                guard state.history.isEmpty else {
                    return .none
                }
                return storage
                    .load()
                    .map { .loadResult(.success($0)) }
                    .catch { Just(.loadResult(.failure($0))) }
                    .receive(on: DispatchQueue.main)
                    .eraseToEffect()

            case let .loadResult(.success(history)):
                state.history = history
                state.error = nil

            case let .loadResult(.failure(error)):
                state.error = StateError(error: error)

            case let .queryChanged(query):
                state.query = query

            case .save:
                guard !state.query.isEmpty else {
                    return .none
                }
                if state.history.contains(text: state.query) {
                    return .task { .saveResult(.success(false)) }
                }
                state.history.append(History(id: uuid(),
                                             text: state.query))
                return storage
                    .save(state.history)
                    .map { .saveResult(.success($0)) }
                    .catch { Just(.saveResult(.failure($0))) }
                    .receive(on: DispatchQueue.main)
                    .eraseToEffect()

            case let .saveResult(result):
                if case .success(_) = result {
                    state.error = nil
                } else if case let .failure(error) = result {
                    state.error = StateError(error: error)
                }
                return .task { [query = state.query] in
                    .searchAction(.fetch(query))
                }

            default:
                break
            }

            return .none
        }
    }
}

private extension Array where Element == History {
    func contains(text: String) -> Bool {
        contains { $0.text.lowercased() == text.lowercased() }
    }

    func filter(by key: String) -> Array<History> {
        guard !key.isEmpty else {
            return self
        }
        return filter { $0.text.lowercased()
            .contains(key.lowercased()) }
    }
}
