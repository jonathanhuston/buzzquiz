//
//  ResultView.swift
//  Buzzquiz
//
//  Created by Jonathan Huston on 12/24/20.
//

import SwiftUI

struct ResultView {
    @EnvironmentObject var quizzes: QuizController
    @EnvironmentObject var viewSelector: ViewSelector

    @State private var showingAnswers = false
}

extension ResultView: View {
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                FileImage(quizzes.bestMatch.name.imageURL(from: quizzes.quiz.quizName))
                    .aspectRatio(contentMode: .fit)
                
                Text(quizzes.bestMatch.name)
                    .font(.title)
                    .foregroundColor(colorKeys[quizzes.bestMatch.color])
                
                Text(quizzes.bestMatch.description)
                    .padding()
                
                HStack {
                    Button("Show answers") {
                        showingAnswers.toggle()
                    }
                                    
                    Button("Different quiz?") {
                        viewSelector.activeView = .chooseQuiz
                    }
                    
                    Button("Same quiz?") {
                        quizzes.quiz.characters = resetScores(for: quizzes.quiz.characters)
                        quizzes.quiz.questions = resetQuestions(for: quizzes.quiz.questions)
                        viewSelector.activeView = .questions
                    }
                    
                    Button("Quit") {
                        viewSelector.activeView = .quit
                    }
                }
                .padding()
            }
            
            if showingAnswers {
                ShowAnswersView(showingAnswers: $showingAnswers)
            }
        }
        .animation(.easeInOut)
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView()
    }
}
