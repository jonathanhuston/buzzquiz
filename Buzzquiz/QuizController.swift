//
//  QuizController.swift
//  Buzzquiz
//
//  Created by Jonathan Huston on 12/24/20.
//

import SwiftUI

class QuizController: ObservableObject {
    @Published var quizNames = getQuizNames().names
    @Published var quiz = Quiz()
    @Published var bestMatch = QuizCharacter()
}
