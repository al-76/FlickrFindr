//
//  PhotoDetailsView.swift
//  FlickrFindr
//
//  Created by Vyacheslav Konopkin on 20.01.2023.
//

import SwiftUI

struct PhotoDetailsView: View {
    let photo: Photo

    var body: some View {
        VStack {
            DownloadImageView(url: photo.fullsizePhotoUrl())
            Text(photo.title)
        }
    }
}

struct PhotoDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoDetailsView(photo: .stub)
    }
}
