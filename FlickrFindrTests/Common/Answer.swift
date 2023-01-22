//
//  Answer.swift
//  FlickrFindrTests
//
//  Created by Vyacheslav Konopkin on 21.01.2023.
//

import Combine

enum TestError: Error {
    case someError
}

enum Answer {
    static func success<T>(_ data: T) -> AnyPublisher<T, Error> {
        Just(data)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    static func fail<T>(_ error: Error = TestError.someError) -> AnyPublisher<T, Error> {
        Fail<T, Error>(error: error)
            .eraseToAnyPublisher()
    }

    static func fail<T>(_ error: Error, _ type: T.Type) -> AnyPublisher<T, Error> {
        Fail<T, Error>(error: error)
            .eraseToAnyPublisher()
    }

    static func nothing<T>() -> AnyPublisher<T, Error> {
        Empty<T, Error>()
            .eraseToAnyPublisher()
    }
}
