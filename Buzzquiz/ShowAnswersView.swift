//
//  ShowAnswersView.swift
//  Buzzquiz
//
//  Created by Jonathan Huston on 1/2/21.
//

import SwiftUI

struct ShowAnswersView {
    @EnvironmentObject var quizzes: QuizController
    @Binding var showingAnswers: Bool
}

extension ShowAnswersView: View {
    var body: some View {
        ZStack {
            Color.primary.colorInvert()
            
            VStack(spacing: 20) {
                Text(quizzes.bestMatch.name)
                    .font(.title)
                    .foregroundColor(colorKeys[quizzes.bestMatch.color])
                    .padding()
                
                ForEach(quizzes.quiz.questions, id:\.self) { question in
                    HStack {
                        Text("\(question.q)")
                            .font(.title2)
                            .foregroundColor(.accentColor)
                        Text("\(question.selectedAnswer.imageName)")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                }
                
                Button("Hide answers") {
                    showingAnswers = false
                }
                .padding()
            }
        }
    }
}

struct ShowAnswersView_Previews: PreviewProvider {
    static var previews: some View {
        ShowAnswersView(showingAnswers: .constant(true))
    }
}
