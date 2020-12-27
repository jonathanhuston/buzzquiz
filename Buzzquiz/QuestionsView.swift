//
//  QuestionsView.swift
//  Buzzquiz
//
//  Created by Jonathan Huston on 12/24/20.
//

import SwiftUI

struct QuestionsView {
    @ObservedObject var quizzes: QuizData
    @Binding var activeView: ActiveView
}

extension QuestionsView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text(quizzes.quiz.quizTitle)
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
        QuestionsView(quizzes: QuizData(), activeView: .constant(.questions))
    }
}
