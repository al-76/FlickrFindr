//
//  HistoryModel.swift
//  FlickrFindr
//
//  Created by Vyacheslav Konopkin on 21.01.2023.
//

import Foundation

struct History: Codable, Equatable, Identifiable {
    let id: UUID
    let text: String
}
