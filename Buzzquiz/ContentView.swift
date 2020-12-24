//
//  ContentView.swift
//  Buzzquiz
//
//  Created by Jonathan Huston on 12/23/20.
//

import SwiftUI

enum ActiveView {
    case chooseQuiz
    case questions
    case result
    case quit
}

struct ContentView {
    @State var activeView: ActiveView = .chooseQuiz
    @State var quiz = ""
}

extension ContentView: View {
    var body: some View {
        switch activeView {
        case .chooseQuiz:
            ChooseQuizView(activeView: $activeView, quiz: $quiz)
        case .questions:
            QuestionsView(activeView: $activeView, quiz: $quiz)
        case .result:
            ResultView(activeView: $activeView)
        case .quit:
            exit(0)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(activeView: .chooseQuiz)
    }
}
