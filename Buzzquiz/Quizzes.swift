//
//  Quizzes.swift
//  Buzzquiz
//
//  Created by Jonathan Huston on 12/24/20.
//

import SwiftUI

class Quizzes: ObservableObject {
    @Published var names = getQuizNames()
    @Published var data = QuizModel()
}
