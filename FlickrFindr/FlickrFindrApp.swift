//
//  FlickrFindrApp.swift
//  FlickrFindr
//
//  Created by Vyacheslav Konopkin on 20.01.2023.
//

import SwiftUI
import XCTestDynamicOverlay

@main
struct FlickrFindrApp: App {
    var body: some Scene {
        WindowGroup {
            if !_XCTIsTesting {
                PhotoSearchView(store: .init(initialState: .init(),
                                             reducer: PhotoHistory()))
            }
        }
    }
}
