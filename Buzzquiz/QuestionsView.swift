//
//  QuestionsView.swift
//  Buzzquiz
//
//  Created by Jonathan Huston on 12/24/20.
//

import SwiftUI

struct QuestionsView {
    @EnvironmentObject var quizzes: QuizController
    @EnvironmentObject var viewSelector: ViewSelector

    @State private var counter = 0
}

extension QuestionsView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text(quizzes.quiz.quizTitle)
                .font(.title)
                .foregroundColor(.accentColor)
            
            Text(quizzes.quiz.questions[counter].q)
                .font(.title2)
            
            Picker(selection: $quizzes.quiz.questions[counter].selectedAnswer, label: Text("")) {
                ForEach(quizzes.quiz.questions[counter].answers, id:\.self) { answer in
                    if answer.a.contains(".jpg") {
                        let image = String(answer.a.split(separator: ".")[0])
                        FileImage(image.imageURL(from: quizzes.quiz.quizName))
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
                Button("Prev") {
                    if counter > 0 {
                        counter -= 1
                    }
                }
                .disabled(counter == 0)
                .padding()
                
                Button(counter < quizzes.quiz.questions.count - 1 ? "Next" : "Result") {
                    if counter >= (quizzes.quiz.questions.count - 1) {
                        quizzes.bestMatch = getBestMatch(for: quizzes.quiz.characters, with: quizzes.quiz.questions)
                        viewSelector.activeView = .result
                    } else {
                        counter += 1
                    }
                }
                .disabled(quizzes.quiz.questions[counter].selectedAnswer.isEmpty)
                .padding()
            }
        }
    }
}

struct QuestionsView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionsView()
    }
}
