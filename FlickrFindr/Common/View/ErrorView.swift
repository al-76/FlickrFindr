//
//  ErrorView.swift
//  FlickrFindr
//
//  Created by Vyacheslav Konopkin on 20.01.2023.
//

import SwiftUI

struct ErrorView: View {
    let error: Error

    var body: some View {
        VStack(alignment: .leading) {
            Text("Error")
                .font(.title2)
                .bold()
            Text(error.localizedDescription)
        }
        .padding()
        .background(.red)
        .foregroundColor(.white)
        .cornerRadius(10)
    }
}

extension ErrorView {
    init(_ stateError: StateError) {
        self.init(error: stateError.error)
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(error: URLError(.badURL))
    }
}
