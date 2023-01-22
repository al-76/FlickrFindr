//
//  PhotoRowView.swift
//  FlickrFindr
//
//  Created by Vyacheslav Konopkin on 20.01.2023.
//

import SwiftUI

struct PhotoRowView: View {
    let photo: Photo
    
    var body: some View {
        VStack {
            DownloadImageView(url: photo.thumbnailPhotoUrl())
                .frame(width: 180, height: 180)
                .cornerRadius(12.0)
            Text(photo.title)
                .lineLimit(1)
                .font(.footnote)
        }
        .padding(8)
    }
}

struct PhotoRowView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoRowView(photo: .stub)
    }
}
