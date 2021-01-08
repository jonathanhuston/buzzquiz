//
//  FileImage.swift
//  Buzzquiz
//
//  Created by Jonathan Huston on 1/3/21.
//  Pilfered from: https://www.hackingwithswift.com/forums/swiftui/loading-images/3292

import SwiftUI

struct FileImage: View {
    private enum LoadState {
        case loading, success, failure
    }

    private class Loader: ObservableObject {
        var data = Data()
        var state = LoadState.loading

        init(_ url: URL) {

            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data, data.count > 0 {
                    self.data = data
                    self.state = .success
                } else {
                    self.state = .failure
                }

                DispatchQueue.main.async {
                    self.objectWillChange.send()
                }
            }.resume()
        }
    }

    @StateObject private var loader: Loader
    var loading: Image
    var failure: Image

    var body: some View {
        selectImage()
            .resizable()
    }

    init(_ url: URL, loading: Image = Image(systemName: "photo"), failure: Image = Image(systemName: "multiply.circle")) {
        _loader = StateObject(wrappedValue: Loader(url))
        self.loading = loading
        self.failure = failure
    }

    private func selectImage() -> Image {
        switch loader.state {
        case .loading:
            return loading
        case .failure:
            return failure
        case .success:
            if let image = NSImage(data: loader.data) {
                return Image(nsImage: image)
            } else {
                return failure
            }
        }
    }
}

