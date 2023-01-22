//
//  PhotoClient.swift
//  FlickrFindr
//
//  Created by Vyacheslav Konopkin on 20.01.2023.
//

import Combine

struct PhotoClient {
    var fetch: (/* query */ String, /* page */Int) -> AnyPublisher<[Photo], Error>
}
