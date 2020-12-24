//
//  QuestionsView.swift
//  Buzzquiz
//
//  Created by Jonathan Huston on 12/24/20.
//

import SwiftUI

struct QuestionsView {
    @StateObject var quiz = QuestionsViewSupport()
    
    @Binding var activeView: ActiveView
    @Binding var quizName: String
}

extension QuestionsView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text(quiz.data.quizQuestion)
                .font(.title)
                .foregroundColor(.accentColor)
            
            Button("Done?") {
                activeView = .result
            }
        }
    }
}

struct QuestionsView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionsView(activeView: .constant(.questions), quizName: .constant("Laika"))
    }
}
