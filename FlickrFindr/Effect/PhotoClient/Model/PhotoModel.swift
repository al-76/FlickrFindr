//
//  PhotoModel.swift
//  FlickrFindr
//
//  Created by Vyacheslav Konopkin on 20.01.2023.
//

import Foundation

struct Photo: Equatable, Decodable, Identifiable, Hashable {
    let id: String
    let secret: String
    let server: String
    let title: String
}
