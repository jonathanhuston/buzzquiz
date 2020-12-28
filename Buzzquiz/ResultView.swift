//
//  ResultView.swift
//  Buzzquiz
//
//  Created by Jonathan Huston on 12/24/20.
//

import SwiftUI

struct ResultView {
    @ObservedObject var quizzes: QuizData
    @Binding var activeView: ActiveView
}

extension ResultView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(quizzes.quiz.characters[quizzes.bestMatch].name.replacingOccurrences(of: " ", with: "-"))
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            Text(quizzes.quiz.characters[quizzes.bestMatch].name)
                .font(.title)
                .foregroundColor(colorKeys[quizzes.quiz.characters[quizzes.bestMatch].color])
            
            Text(quizzes.quiz.characters[quizzes.bestMatch].description)
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
        ResultView(quizzes: QuizData(), activeView: .constant(.result))
    }
}
