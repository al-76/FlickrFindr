//
//  DownloadImageView.swift
//  FlickrFindr
//
//  Created by Vyacheslav Konopkin on 20.01.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct DownloadImageView: View {
    let url: URL?

    var body: some View {
        WebImage(url: url)
            .placeholder { ProgressView() }
            .resizable()
            .scaledToFit()
            .transition(.fade(duration: 0.5))
    }
}

struct DownloadImageView_Previews: PreviewProvider {
    static var previews: some View {
        DownloadImageView(url: URL(string: "https://live.staticflickr.com/65535/52638432785_0ef3ba0e3c_q.jpg"))
    }
}
