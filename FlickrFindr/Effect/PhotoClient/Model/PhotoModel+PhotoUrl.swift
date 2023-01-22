//
//  PhotoModel+PhotoUrl.swift
//  FlickrFindr
//
//  Created by Vyacheslav Konopkin on 20.01.2023.
//

import Foundation

//
// Details: https://www.flickr.com/services/api/misc.urls.html
//
extension Photo {
    func thumbnailPhotoUrl() -> URL? {
        buildUrl(sizeSuffix: "q")
    }

    func fullsizePhotoUrl() -> URL? {
        buildUrl(sizeSuffix: "b")
    }

    private func buildUrl(sizeSuffix: String) -> URL? {
        URL(string: "https://live.staticflickr.com/")?
            .appendingPathComponent(server)
            .appendingPathComponent("\(id)_\(secret)_\(sizeSuffix).jpg")
    }
}
