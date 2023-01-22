//
//  HistoryStorage.swift
//  FlickrFindr
//
//  Created by Vyacheslav Konopkin on 21.01.2023.
//

import Combine

struct HistoryStorage {
    var save: ([History]) -> AnyPublisher<Bool, Error>
    var load: () -> AnyPublisher<[History], Error>
}
