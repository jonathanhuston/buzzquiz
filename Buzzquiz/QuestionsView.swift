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
            
            let gridItems = [GridItem(), GridItem()]
            
            LazyVGrid(columns: gridItems) {
                ForEach(quizzes.quiz.questions[counter].answers, id:\.self) { answer in
                        Button(action: {
                            quizzes.quiz.questions[counter].selectedAnswer = answer.a
                        }) {
                            ZStack {
                                if quizzes.quiz.questions[counter].selectedAnswer == answer.a {
                                    Color.secondary.colorInvert()
                                        .frame(minHeight: 75)
                                        .border(Color.purple)
                                } else {
                                    Color.secondary.colorInvert()
                                        .frame(minHeight: 75)
                                }
                                
                                if answer.a.contains(".jpg") {
                                    let image = String(answer.a.split(separator: ".")[0])
                                    FileImage(image.imageURL(from: quizzes.quiz.quizName))
                                        .aspectRatio(contentMode: .fit)
                                        .padding(10)
                                        .frame(height: 140)
                                } else {
                                    Text(answer.a)
                                        .frame(height: 75)
                                }
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal)
            .frame(minHeight: 450)
            
            HStack(spacing: 40) {
                Button(action: {
                        if counter > 0 {
                            counter -= 1
                        }
                }) {
                    Image(systemName: "arrow.backward")
                        .frame(width: 50)
                }
                .disabled(counter == 0)
                
                Text("\(counter + 1) / \(quizzes.quiz.questions.count)")
                    .frame(width: 50)
                
                Button(action: {
                    if counter >= (quizzes.quiz.questions.count - 1) {
                        quizzes.bestMatch = getBestMatch(for: quizzes.quiz.characters, with: quizzes.quiz.questions)
                        viewSelector.activeView = .result
                    } else {
                        counter += 1
                    }
                }) {
                    if (counter < quizzes.quiz.questions.count - 1) {
                        Image(systemName: "arrow.forward")
                            .frame(width: 50)
                    } else {
                        Text("Result")
                            .frame(width: 50)
                    }
                }
                .disabled(quizzes.quiz.questions[counter].selectedAnswer.isEmpty)
            }
        }
    }
}

struct QuestionsView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionsView()
    }
}
