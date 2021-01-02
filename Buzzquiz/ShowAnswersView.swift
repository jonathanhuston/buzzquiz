//
//  ShowAnswersView.swift
//  Buzzquiz
//
//  Created by Jonathan Huston on 1/2/21.
//

import SwiftUI

struct ShowAnswersView {
    @ObservedObject var quizzes: QuizController
    
    @Binding var showingAnswers: Bool

}

extension ShowAnswersView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.black)
            
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
                        Text("\(question.selectedAnswer.displayImageName())")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                }
                .foregroundColor(.white)
                
                Button("Hide answers") {
                    showingAnswers = false
                }
                .padding()
            }
        }
        .frame(idealWidth: .infinity, idealHeight: .infinity, alignment: .center)
    }
}

struct ShowAnswersView_Previews: PreviewProvider {
    static var previews: some View {
        ShowAnswersView(quizzes: QuizController(), showingAnswers: .constant(true))
    }
}
