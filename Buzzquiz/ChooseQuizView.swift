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

    @State private var quizIndex = 0
}

extension ChooseQuizView: View {
    var body: some View {
        VStack(spacing: 40) {
            Text("Which quiz do you want to play?")
                .font(.title)
                .foregroundColor(.accentColor)
                .padding()
            
            Picker(selection: $quizIndex, label: Text("")) {
                ForEach(quizzes.names.indices) { i in
                    Text(quizzes.names[i]).tag(i)
                }
            }
            .padding()
            .pickerStyle(RadioGroupPickerStyle())
            
            Button(action: {
                quizzes.quiz = loadQuizData(quizName: quizzes.names[quizIndex])
                viewSelector.activeView = .questions
            }) {
                Text("Play")
                    .frame(width: 100)
            }
        }
    }
}

struct ChooseQuizView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseQuizView()
    }
}
