//
//  LiveHistoryStorage.swift
//  FlickrFindr
//
//  Created by Vyacheslav Konopkin on 21.01.2023.
//

import Combine
import Foundation

extension HistoryStorage {
    private static let storageName = "FlickrFindrHistory"

    static var live = Self(save: { items in
        Future { promise in
            do {
                let url = try getUrl(from: Self.storageName)
                FileManager.default
                    .createFile(atPath: url.path,
                                contents: try JSONEncoder().encode(items),
                                attributes: nil)
                promise(.success(true))
            } catch let error {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }, load: {
        Future { promise in
            do {
                let url = try getUrl(from: Self.storageName)
                guard let data = FileManager.default.contents(atPath: url.path) else {
                    promise(.success([]))
                    return
                }
                promise(.success(try JSONDecoder()
                    .decode([History].self, from: data)))
            } catch let error {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    })

    private static func getUrl(from name: String) throws -> URL {
        try FileManager.default
            .url(for: .applicationSupportDirectory,
                 in: .userDomainMask,
                 appropriateFor: nil,
                 create: true)
            .appendingPathComponent(name, isDirectory: false)
    }
}
