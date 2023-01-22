//
//  StubHistoryStorage.swift
//  FlickrFindr
//
//  Created by Vyacheslav Konopkin on 21.01.2023.
//

import Combine
import XCTestDynamicOverlay

// MARK: - Preview
extension HistoryStorage {
    static var preview = Self(save: { _ in
        Just(true)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }, load: {
        Just(.stub)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    })
}

// MARK: - Test
extension HistoryStorage {
    static var test = Self(save: unimplemented("HistoryStorage.save"),
                           load: unimplemented("HistoryStorage.load"))
}
