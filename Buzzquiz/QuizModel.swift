//
//  QuizModel.swift
//  Buzzquiz
//
//  Created by Jonathan Huston on 12/24/20.
//

import Foundation

typealias CharacterName = String

struct Character {
    let name: CharacterName
    let color: String
    let description: String
    var score = 0
}

struct Answer {
    let answer: String
    let scores: [CharacterName: Int]
}

struct Question {
    let question: String
    let answers: [Answer]
}

struct Model {
    let quizName: String
    let characters: [Character]
    let questions: [Question]
}
