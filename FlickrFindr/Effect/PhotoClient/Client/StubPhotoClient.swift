//
//  StubPhotoClient.swift
//  FlickrFindr
//
//  Created by Vyacheslav Konopkin on 21.01.2023.
//

import Combine
import XCTestDynamicOverlay

// MARK: - Preview
extension PhotoClient {
    static var preview = Self(fetch: { _, _ in
        Just(.stub)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    })
}

// MARK: - Test
extension PhotoClient {
    static var test = Self(fetch: unimplemented("PhotoClient.fetch"))
}
