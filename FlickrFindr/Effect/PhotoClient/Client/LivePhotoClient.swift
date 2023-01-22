//
//  PhotoClientImpl.swift
//  FlickrFindr
//
//  Created by Vyacheslav Konopkin on 20.01.2023.
//

import Combine
import Foundation

extension PhotoClient {
    enum ClientError: Error {
        case badUrl
    }

    private struct PhotoResponse: Decodable {
        let photos: PhotoContainer
    }

    private struct PhotoContainer: Decodable {
        let photo: [Photo]
    }

    static var live = Self(fetch: { query, page in
        guard let url = Self.getApiUrl(query, page) else {
            return Fail(error: ClientError.badUrl)
                .eraseToAnyPublisher()
        }
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: PhotoResponse.self, decoder: JSONDecoder())
            .map(\.photos.photo)
            .eraseToAnyPublisher()
    })

    private static func getApiUrl(_ query: String, _ page: Int) -> URL? {
        var components = URLComponents(string: "https://www.flickr.com/services/rest")
        components?.queryItems = [
            URLQueryItem(name: "method", value: "flickr.photos.search"),
            URLQueryItem(name: "api_key", value: "1508443e49213ff84d566777dc211f2a"),
            URLQueryItem(name: "text", value: query),
            URLQueryItem(name: "per_page", value: "25"),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "nojsoncallback", value: "1"),
            URLQueryItem(name: "page", value: "\(page)")
        ]
        return components?.url
    }
}
