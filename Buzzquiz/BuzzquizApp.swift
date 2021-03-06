//
//  BuzzquizApp.swift
//  Buzzquiz
//
//  Created by Jonathan Huston on 12/23/20.
//

import SwiftUI

enum ActiveView {
    case chooseQuiz
    case questions
    case result
    case error(String)
    case quit
}

class ViewSelector: ObservableObject {
    @Published var activeView: ActiveView = (getQuizNames().error == ":ok" ? .chooseQuiz : .error(getQuizNames().error))
}

@main
struct BuzzquizApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(ViewSelector())
                .environmentObject(QuizController())
                .frame(minWidth: 800, minHeight: 800, alignment: .center)
        }
    }
}
