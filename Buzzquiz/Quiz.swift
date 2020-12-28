//
//  Quiz.swift
//  Buzzquiz
//
//  Created by Jonathan Huston on 12/24/20.
//

import Foundation

typealias CharacterName = String
typealias Score = Int

struct QuizCharacter {
    let name: CharacterName
    let color: String
    let description: String
    let score: Score
}

struct Answer {
    let a: String
    let scores: [CharacterName: Score]
}

struct Question {
    let q: String
    let answers: [Answer]
}

struct Quiz {
    var quizName = ""
    var quizTitle = ""
    var characters = [QuizCharacter]()
    var questions = [Question]()
}
