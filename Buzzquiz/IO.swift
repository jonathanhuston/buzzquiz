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

extension String {
    func trimQuotes () -> String {
        return self.trimmingCharacters(in: ["\""]).replacingOccurrences(of: "\"\"", with: "\"")
    }
}

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
    
    return description.trimQuotes()
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

func getAnswer(for characters: [QuizCharacter], from content: [String.SubSequence]) -> (String, [CharacterName: Score]) {
    var scores = [CharacterName: Score]()
    
    let answer = String(content[0])
    
    for i in 1..<content.count {
        scores[characters[i-1].name] = Int(content[i])
    }
    
    return (answer, scores)
}

func getFirstColumn(from row: String) -> String {
    return String((row.split(separator: ","))[0]).trimQuotes()
}

func getQuestion(for characters: [QuizCharacter], from contents: [String], startingAt firstRow: Int) -> (String, [Answer], Int) {
    var answers = [Answer]()
    
    let q = getFirstColumn(from: contents[firstRow])
    
    var currentRow = firstRow + 2
    
    while currentRow < contents.count {
        let content = contents[currentRow].split(separator: ",")
        
        if content.isEmpty {
            break
        }
        
        let (a, scores) = getAnswer(for: characters, from: content)
        let answer = Answer(a: a, scores: scores)
        
        answers.append(answer)
        currentRow += 1
    }
    
    
    return (q, answers, currentRow + 1)
}

func loadQuestions(for characters: [QuizCharacter], at url: URL) -> (String, [Question]) {
    var questions = [Question]()
    let contents = loadCSV(at: url)
    
    let quizTitle = getFirstColumn(from: contents[0])
    print(quizTitle)
    
    var currentRow = 2

    while currentRow < contents.count {
        let (q, answers, nextRow) = getQuestion(for: characters, from: contents, startingAt: currentRow)
        
        let question = Question(q: q, answers: answers)
        print(q)
        print(answers)
        questions.append(question)
        currentRow = nextRow
    }
    
    return (quizTitle, questions)
}

func loadQuizData(quizName: String) -> Quiz {
    let quizURL = home.appendingPathComponent("\(GAME_DATA_PATH)/\(quizName)/")
    let charactersURL = quizURL.appendingPathComponent(CHARACTERS_FILE)
    let questionsURL = quizURL.appendingPathComponent(QUESTIONS_FILE)

    let characters = loadCharacters(at: charactersURL)
    let (quizTitle, questions) = loadQuestions(for: characters, at: questionsURL)
    
    let quiz = Quiz(quizName: quizName,
                    quizTitle: quizTitle,
                    characters: characters,
                    questions: questions)
    
    return quiz
}
