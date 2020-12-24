//
//  QuestionsModel.swift
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

struct QuestionsModel {
    let quizName: String
}

extension QuestionsModel {
    var quizQuestion: String {
        "Which Laika character are you?"
    }
    
    var characters: [Character] {
        []
    }
    
    var questions: [Question] {
        []
    }
}
