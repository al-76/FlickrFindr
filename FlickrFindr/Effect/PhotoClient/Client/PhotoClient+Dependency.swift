//
//  PhotoClient+Dependency.swift
//  FlickrFindr
//
//  Created by Vyacheslav Konopkin on 20.01.2023.
//

import ComposableArchitecture

extension PhotoClient: DependencyKey {
    static var liveValue = PhotoClient.live
    static var previewValue = PhotoClient.preview
    static var testValue = PhotoClient.test
}

extension DependencyValues {
  var photoClient: PhotoClient {
    get { self[PhotoClient.self] }
    set { self[PhotoClient.self] = newValue }
  }
}
