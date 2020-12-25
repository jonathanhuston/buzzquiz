//
//  QuizModel.swift
//  Buzzquiz
//
//  Created by Jonathan Huston on 12/24/20.
//

import Foundation

typealias CharacterName = String
typealias Score = Int

struct Character {
    var name: CharacterName
    var color: String
    var description: String
    var score: Score = 0
}

struct Answer {
    var answer: String
    var scores: [CharacterName: Score]
}

struct Question {
    var question: String
    var answers: [Answer]
}

struct Quiz {
    var quizName = ""
    var quizTitle = ""
    var characters = [Character]()
    var questions = [Question]()
}
