//
//  QuestionsView.swift
//  Buzzquiz
//
//  Created by Jonathan Huston on 12/24/20.
//

import SwiftUI

struct QuestionsView {
    @ObservedObject var quizzes: QuizController
    @Binding var activeView: ActiveView
    
    @State private var counter = 0
    @State private var selectedAnswer = ""
    
//    let columns = [GridItem(.fixed(50)), GridItem(.fixed(50))]
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
                if quizzes.quiz.questions[counter].answers[0].a.contains(".jpg") {
//                    LazyVGrid(columns: columns) {
                        ForEach(quizzes.quiz.questions[counter].answers, id:\.self) { answer in
                                let image = answer.a.split(separator: ".")[0]
                                Image(String(image))
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .tag(answer.a)
                        }
//                    }
                } else {
                    ForEach(quizzes.quiz.questions[counter].answers, id:\.self) { answer in
                        Text(answer.a).tag(answer.a)
                    }
                }
            }
            .padding()
            .pickerStyle(RadioGroupPickerStyle())
                            
            Button("Next") {
                quizzes.quiz.characters =
                    updatedScores(for: quizzes.quiz.characters,
                                 answers: quizzes.quiz.questions[counter].answers,
                                 a: selectedAnswer)
                if counter >= (quizzes.quiz.questions.count - 1) {
                    quizzes.bestMatch = getBestMatch(for: quizzes.quiz.characters)
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
        QuestionsView(quizzes: QuizController(), activeView: .constant(.questions))
    }
}
