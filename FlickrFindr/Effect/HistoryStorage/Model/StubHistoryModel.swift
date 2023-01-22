//
//  StubHistoryModel.swift
//  FlickrFindr
//
//  Created by Vyacheslav Konopkin on 21.01.2023.
//

import Foundation

extension History {
    static let stub = [History].stub[0]
}

extension Array where Element == History {
    static let stub = [
        History(id: UUID(), text: "Some"),
        History(id: UUID(), text: "Random"),
        History(id: UUID(), text: "Words")
    ]
}
