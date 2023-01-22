//
//  PhotoSearchListView.swift
//  FlickrFindr
//
//  Created by Vyacheslav Konopkin on 21.01.2023.
//

import ComposableArchitecture
import SwiftUI

struct PhotoSearchListView: View {
    let store: StoreOf<PhotoSearch>

    private let columns = [GridItem(.flexible()),
                           GridItem(.flexible())]

    @Namespace private var topId

    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollViewReader { proxy in
                ScrollView {
                    EmptyView() // Just a marker to scroll to top
                        .id(topId)
                    LazyVGrid(columns: columns) {
                        ForEach(viewStore.photos) { photo in
                            NavigationLink(value: photo) {
                                PhotoRowView(photo: photo)
                            }
                            .onAppear {
                                viewStore.send(.fetchMore(photo))
                            }
                        }
                    }
                }
                .onChange(of: viewStore.page) { page in
                    // Scroll to top on page == 1 to reset scroll
                    guard page == 1 else {
                        return
                    }
                    withAnimation {
                        proxy.scrollTo(topId, anchor: .top)
                    }
                }
                if viewStore.isLoading {
                    ProgressView("Loading...")
                }
            }
            .overlay {
                if let error = viewStore.error {
                    ErrorView(error)
                }
            }
            .navigationTitle("Search")
            .navigationDestination(for: Photo.self) {
                PhotoDetailsView(photo: $0)
            }
        }
    }
}

struct PhotoSearchListView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoSearchListView(store: .init(
            initialState: .init(photos: .stub),
            reducer: PhotoSearch()
        ))
    }
}
