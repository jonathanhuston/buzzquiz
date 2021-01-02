//
//  Quiz.swift
//  Buzzquiz
//
//  Created by Jonathan Huston on 12/24/20.
//

import Foundation

typealias CharacterName = String
typealias Score = Int

struct QuizCharacter: Hashable {
    var name: CharacterName = ""
    var color = ""
    var description = ""
}

struct Answer: Hashable {
    let a: String
    var scores: [CharacterName: Score]
}

struct Question: Hashable {
    let q: String
    var answers: [Answer]
    var selectedAnswer = ""
}

struct Quiz {
    var quizName = ""
    var quizTitle = ""
    var characters = [QuizCharacter]()
    var questions = [Question]()
}
