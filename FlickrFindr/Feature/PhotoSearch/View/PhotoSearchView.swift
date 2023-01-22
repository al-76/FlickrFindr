//
//  PhotoSearchView.swift
//  FlickrFindr
//
//  Created by Vyacheslav Konopkin on 20.01.2023.
//

import ComposableArchitecture
import SwiftUI

struct PhotoSearchView: View {
    let store: StoreOf<PhotoHistory>

    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationStack {
                PhotoSearchListView(store: store
                    .scope(state: \.search,
                           action: PhotoHistory.Action.searchAction))
            }
            .searchable(text: viewStore.binding(get: \.query,
                                                send: { .queryChanged($0) })) {
                ForEach(viewStore.filteredHistory) {
                    Text($0.text)
                        .searchCompletion($0.text)
                }
            }
            .overlay {
                if let error = viewStore.error {
                    ErrorView(error)
                }
            }
            .onSubmit(of: .search) {
                viewStore.send(.save)
            }
            .onAppear {
                viewStore.send(.load)
            }
        }
    }
}

struct PhotoSearchView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoSearchView(store: .init(
            initialState: .init(),
            reducer: PhotoHistory()
        ))
    }
}
