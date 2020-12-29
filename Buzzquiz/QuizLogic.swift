//
//  QuizLogic.swift
//  Buzzquiz
//
//  Created by Jonathan Huston on 12/28/20.
//

import Foundation

func updatedScores(for characters: [QuizCharacter], answers: [Answer], a: String) -> [QuizCharacter] {
    var result = [QuizCharacter]()
    
    for answer in answers {
        if answer.a == a {
            for character in characters {
                let score = character.score + answer.scores[character.name]!
                let updatedCharacter = QuizCharacter(name: character.name,
                                                     color: character.color,
                                                     description: character.description,
                                                     score: score)
                result.append(updatedCharacter)
            }
        }
    }
    
    return result
}

func getBestMatch(for characters: [QuizCharacter]) -> QuizCharacter {
    var bestMatch = QuizCharacter()
    var bestScore = 0
    
    for character in characters {
        if character.score >= bestScore {
            bestScore = character.score
            bestMatch = character
        }
    }
    
    return bestMatch
}

func resetScores(for characters: [QuizCharacter]) -> [QuizCharacter] {
    var reset = [QuizCharacter]()
    
    for character in characters {
        reset.append(QuizCharacter(name: character.name,
                                   color: character.color,
                                   description: character.description,
                                   score: 0))
    }
    
    return reset
}
