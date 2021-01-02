//
//  QuizLogic.swift
//  Buzzquiz
//
//  Created by Jonathan Huston on 12/28/20.
//

import Foundation

func getBestMatch(for characters: [QuizCharacter], with questions: [Question]) -> QuizCharacter {
    var characterScores = [QuizCharacter: Score]()
    var bestMatch = QuizCharacter()
    var bestScore = 0
    
    for character in characters {
        characterScores[character] = 0
        
        for question in questions {
            for answer in question.answers {
                if answer.a == question.selectedAnswer {
                    characterScores[character]! += answer.scores[character.name]!
                }
            }
        }
        
        if characterScores[character]! >= bestScore {
            bestScore = characterScores[character]!
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
                                   description: character.description))
    }
    
    return reset
}

func resetQuestions(for questions: [Question]) -> [Question] {
    var reset = [Question]()
    
    for question in questions {
        reset.append(Question(q: question.q,
                              answers: question.answers,
                              selectedAnswer: ""))
    }
    
    return reset
}
