//
//  QuestionsView.swift
//  Buzzquiz
//
//  Created by Jonathan Huston on 12/24/20.
//

import SwiftUI

struct QuestionsView {
    @Binding var activeView: ActiveView
}

extension QuestionsView: View {
    var body: some View {
        Button("Done?") {
            activeView = .result
        }
    }
}

struct QuestionsView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionsView(activeView: .constant(.questions))
    }
}
