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
                    if answer.a.contains(".jpg") {
                        let image = String(answer.a.split(separator: ".")[0])
                        Image(image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 75)
                            .tag(answer.a)

                    } else {
                        Text(answer.a)
                            .tag(answer.a)

                    }
                }
            }
            .pickerStyle(RadioGroupPickerStyle())
            .padding()
            
            HStack {
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
                .padding()
                
                Button("Quit") {
                    activeView = .quit
                }
                .padding()
            }
        }
    }
}

struct QuestionsView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionsView(quizzes: QuizController(), activeView: .constant(.questions))
    }
}
