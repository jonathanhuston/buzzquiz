//
//  ResultView.swift
//  Buzzquiz
//
//  Created by Jonathan Huston on 12/24/20.
//

import SwiftUI

struct ResultView {
    @Binding var activeView: ActiveView
}

extension ResultView: View {
    var body: some View {
        VStack {
            Image("Baymax")
                .padding()
            HStack {
                Button("Different quiz?") {
                    activeView = .chooseQuiz
                }
                Button("Same quiz?") {
                    activeView = .questions
                }
                Button("Quit") {
                    activeView = .quit
                }
            }
            .padding()
        }
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView(activeView: .constant(.result))
    }
}
