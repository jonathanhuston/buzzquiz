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
    
    @State private var counter = 0
    @State private var selectedAnswer = ""
}

extension QuestionsView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text(quizzes.quiz.quizTitle)
                .font(.title)
                .foregroundColor(.accentColor)
            
            Text(quizzes.quiz.questions[counter].q)
                .font(.title2)
            
            Picker(selection: $selectedAnswer, label: Text("")) {
                ForEach(quizzes.quiz.questions[counter].answers, id:\.self) { answer in
                    Text(answer.a).tag(answer.a)
                }
            }
            .padding()
            .pickerStyle(RadioGroupPickerStyle())
                            
            Button("Next") {
                if counter >= (quizzes.quiz.questions.count - 1) {
                    activeView = .result
                } else {
                    counter += 1
                }
            }
        }
    }
}

struct QuestionsView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionsView(quizzes: QuizData(), activeView: .constant(.questions))
    }
}
