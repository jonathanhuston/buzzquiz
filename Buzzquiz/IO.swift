//
//  IO.swift
//  Buzzquiz
//
//  Created by Jonathan Huston on 12/25/20.
//

import Foundation

let GAME_DATA_PATH = "Buzzquiz"
let CHARACTERS_FILE = "characters.csv"
let QUESTIONS_FILE = "questions.csv"

let fileManager = FileManager.default
let home = fileManager.homeDirectoryForCurrentUser

func getQuizNames() -> [String] {
    let buzzquizUrl = home.appendingPathComponent(GAME_DATA_PATH)
    
    do {
        let contents = try fileManager.contentsOfDirectory(at: buzzquizUrl, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
        return contents.map { $0.lastPathComponent }
      } catch {
        return []
      }
}

func loadCSV(at url: URL) -> String {
    do {
        let contents = try String(contentsOf: url)
        return contents
    } catch {
        return ""
    }
}

func loadCharacters(at url: URL) -> [QuizCharacter] {
    var characters = [QuizCharacter]()
    let contents = loadCSV(at: url)
    let rows = contents.split(separator: "\r\n")
        
    for row in rows {
        let columns = row.split(separator: ",")
        print(columns)
        let character = QuizCharacter(name: String(columns[0]),
                                      color: String(columns[1]),
                                      description: String(columns[2]),
                                      score: 0)
        characters.append(character)
    }
    
    return characters
}

func loadQuestions(at url: URL) -> (String, [Question]) {
    let quizTitle = ""
    let questions = [Question]()
    
    return (quizTitle, questions)
}

func loadQuizData(quizName: String) -> Quiz {
    let quizURL = home.appendingPathComponent("\(GAME_DATA_PATH)/\(quizName)/")
    let charactersURL = quizURL.appendingPathComponent(CHARACTERS_FILE)
    let questionsURL = quizURL.appendingPathComponent(QUESTIONS_FILE)

    let characters = loadCharacters(at: charactersURL)
    let (quizTitle, questions) = loadQuestions(at: questionsURL)
    
    let quiz = Quiz(quizName: quizName,
                    quizTitle: quizTitle,
                    characters: characters,
                    questions: questions)
    
    return quiz
}
