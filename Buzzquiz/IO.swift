//
//  IO.swift
//  Buzzquiz
//
//  Created by Jonathan Huston on 12/25/20.
//

import Foundation

let GAME_DATA_PATH = "Buzzquiz"
let DESCRIPTIONS_FILE = "descriptions.csv"
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

func loadCSV(at url: URL) throws -> String {
    let s = try String(contentsOf: url)
    return s
}

func loadQuizData(quizName: String) -> Quiz {
    let quizURL = home.appendingPathComponent("\(GAME_DATA_PATH)/\(quizName)/")
    let descriptionURL = quizURL.appendingPathComponent(DESCRIPTIONS_FILE)
    let questionsURL = quizURL.appendingPathComponent(QUESTIONS_FILE)

    let descriptions = try! loadCSV(at: descriptionURL)
    let questions = try! loadCSV(at: questionsURL)
    
    print(descriptions)
    print(questions)
    
    let quiz = Quiz(quizName: quizName, quizTitle: "Which \(quizName) character are you?")
    
    return quiz
}
