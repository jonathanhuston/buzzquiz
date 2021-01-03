//
//  ContentView.swift
//  Buzzquiz
//
//  Created by Jonathan Huston on 12/23/20.
//

import SwiftUI

struct ContentView {
    @EnvironmentObject var quizzes: QuizController
    @EnvironmentObject var viewSelector: ViewSelector
}

extension ContentView: View {
    var body: some View {
        switch viewSelector.activeView {
        case .chooseQuiz:
            ChooseQuizView()
        case .questions:
            QuestionsView()
        case .result:
            ResultView()
        case .quit:
            exit(0)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
