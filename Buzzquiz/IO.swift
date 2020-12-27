//
//  IO.swift
//  Buzzquiz
//
//  Created by Jonathan Huston on 12/25/20.
//

import Foundation
import SwiftUI

let GAME_DATA_PATH = "Buzzquiz"
let CHARACTERS_FILE = "characters.csv"
let QUESTIONS_FILE = "questions.csv"

let fileManager = FileManager.default
let home = fileManager.homeDirectoryForCurrentUser

let colorKeys = [
    "blue": Color.blue,
    "magenta": Color.purple,
    "green": Color.green,
    "red": Color.red,
    "black": Color.primary,
    "white": Color.secondary,
    "cyan": Color.gray,
    "orange": Color.orange,
    "pink": Color.pink
]

func getQuizNames() -> [String] {
    let buzzquizUrl = home.appendingPathComponent(GAME_DATA_PATH)
    
    do {
        let contents = try fileManager.contentsOfDirectory(at: buzzquizUrl, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
        return contents.map { $0.lastPathComponent }
      } catch {
        return []
      }
}

func loadCSV(at url: URL) -> [String] {
    do {
        let contents = try String(contentsOf: url).split(separator: "\r\n")
        return contents.map { String($0) }
    } catch {
        return [""]
    }
}

func getDescription(from row: String) -> String {
    let i = row.index(row.firstIndex(of: ",") ?? row.startIndex, offsetBy: 1)
    let remainingRow = String(row[i...])
    let j = remainingRow.index(remainingRow.firstIndex(of: ",") ?? remainingRow.startIndex, offsetBy: 1)
    let description = String(remainingRow[j...])
    
    return description.trimmingCharacters(in: ["\""]).replacingOccurrences(of: "\"\"", with: "\"")
}

func getCharacterFields(in row: String) -> (CharacterName, String, String) {
    let columns = row.split(separator: ",")
    
    let name = String(columns[0])
    let color = String(columns[1])
    let description = getDescription(from: row)
    
    return (name, color, description)
}

func loadCharacters(at url: URL) -> [QuizCharacter] {
    var characters = [QuizCharacter]()
    let contents = loadCSV(at: url)
        
    for row in contents {
        let (name, color, description) = getCharacterFields(in: row)
        let character = QuizCharacter(name: name,
                                      color: color,
                                      description: description,
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
