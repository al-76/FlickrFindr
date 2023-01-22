//
//  StubPhotoModel.swift
//  FlickrFindr
//
//  Created by Vyacheslav Konopkin on 21.01.2023.
//

extension Photo {
    static let stub = [Photo].stub[0]
}

extension Array where Element == Photo {
    static let stub = [
        Photo(id: "52638432785", secret: "0ef3ba0e3c", server: "65535", title: "Penguin Awareness Day, 20 januari 2023"),
        Photo(id: "52638343265", secret: "cd8be70ee1", server: "65535", title: "Spring Festival 2023 at Yuyuan Bazaar 6"),
        Photo(id: "52638250093", secret: "7bd5607b00", server: "65535", title: "A Whale of a Ghost"),
        Photo(id: "52636820957", secret: "b3311e2583", server: "65535", title: "From whence the Wellerman"),
        Photo(id: "52637739028", secret: "a763f61057", server: "65535", title: "A7B03066"),
        Photo(id: "52637164916", secret: "00f564bf64", server: "65535", title: "Whale soap"),
        Photo(id: "52637519815", secret: "6911cfdfb6", server: "65535", title: "Whales and Fishies II - WC")
    ]
}
