//
//  HistoryStorage+Dependency.swift
//  FlickrFindr
//
//  Created by Vyacheslav Konopkin on 21.01.2023.
//

import ComposableArchitecture

extension HistoryStorage: DependencyKey {
    static var liveValue = HistoryStorage.live
    static var previewValue = HistoryStorage.preview
    static var testValue = HistoryStorage.test
}

extension DependencyValues {
  var historyStorage: HistoryStorage {
    get { self[HistoryStorage.self] }
    set { self[HistoryStorage.self] = newValue }
  }
}
