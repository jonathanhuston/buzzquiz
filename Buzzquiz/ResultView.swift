//
//  ResultView.swift
//  Buzzquiz
//
//  Created by Jonathan Huston on 12/24/20.
//

import SwiftUI

struct ResultView {
    @ObservedObject var quizzes: QuizController
    @Binding var activeView: ActiveView
}

extension ResultView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(quizzes.bestMatch.name.replacingOccurrences(of: " ", with: "-"))
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            Text(quizzes.bestMatch.name)
                .font(.title)
                .foregroundColor(colorKeys[quizzes.bestMatch.color])
            
            Text(quizzes.bestMatch.description)
                .padding()
            
            HStack {
                Button("Different quiz?") {
                    activeView = .chooseQuiz
                }
                Button("Same quiz?") {
                    quizzes.quiz.characters = resetScores(for: quizzes.quiz.characters)
                    activeView = .questions
                }
                Button("Quit") {
                    activeView = .quit
                }
            }
            .foregroundColor(.primary)
            .padding()
        }
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView(quizzes: QuizController(), activeView: .constant(.result))
    }
}
