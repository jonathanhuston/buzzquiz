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
    case quit
}

class ViewSelector: ObservableObject {
    @Published var activeView: ActiveView = .chooseQuiz
}

@main
struct BuzzquizApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(ViewSelector())
                .environmentObject(QuizController())
                .frame(minWidth: 750, minHeight: 750, alignment: .center)
        }
    }
}
