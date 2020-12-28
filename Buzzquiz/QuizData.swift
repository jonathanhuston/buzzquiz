//
//  QuizData.swift
//  Buzzquiz
//
//  Created by Jonathan Huston on 12/24/20.
//

import SwiftUI

class QuizData: ObservableObject {
    @Published var names = getQuizNames()
    @Published var quiz = Quiz()
    @Published var bestMatch = 2
}
