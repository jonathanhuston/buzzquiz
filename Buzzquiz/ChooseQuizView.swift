//
//  ChooseQuizView.swift
//  Buzzquiz
//
//  Created by Jonathan Huston on 12/24/20.
//

import SwiftUI

struct ChooseQuizView {
    @EnvironmentObject var quizzes: QuizController
    @EnvironmentObject var viewSelector: ViewSelector
}

extension ChooseQuizView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Which quiz do you want to play?")
                .font(.title)
                .foregroundColor(.accentColor)
                .padding()
            
            ForEach(quizzes.quizNames!, id:\.self) { name in
                Button(action: {
                    let (quiz, error) = loadQuizData(quizName: name)
                    if error == ":ok" {
                        quizzes.quiz = quiz!
                        viewSelector.activeView = .questions
                    } else {
                        viewSelector.activeView = .error(error)
                    }
                }) {
                    ZStack {
                        Color.secondary.colorInvert()
                            .frame(width: 200, height: 40)
                            .border(Color.purple)
                        
                        Text(name)
                            .background(Color.secondary.colorInvert())
                            .frame(width: 200)
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

struct ChooseQuizView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseQuizView()
            .environmentObject(ViewSelector())
            .environmentObject(QuizController())
    }
}
