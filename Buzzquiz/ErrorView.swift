//
//  ErrorView.swift
//  Buzzquiz
//
//  Created by Jonathan Huston on 1/9/21.
//

import SwiftUI

struct ErrorView {
    @EnvironmentObject var viewSelector: ViewSelector
}

extension ErrorView: View {
    var body: some View {
        VStack(spacing: 20) {
            switch viewSelector.activeView {
            case let .error(error):
                Text(error)
                    .font(.title)
                    .foregroundColor(.red)
                    .padding()
            default:
                Text("Fatal error")
                    .font(.title)
                    .foregroundColor(.red)
                    .padding()
            }
        
            Button("Quit") {
                viewSelector.activeView = .quit
            }
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView()
    }
}
