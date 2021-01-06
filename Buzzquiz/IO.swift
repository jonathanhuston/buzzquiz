//
//  IO.swift
//  Buzzquiz
//
//  Created by Jonathan Huston on 12/25/20.
//

import Foundation
import SwiftUI
import CoreXLSX

private let GAME_DATA_PATH = "Buzzquiz"
private let CHARACTERS_FILE = "characters.xlsx"
private let QUESTIONS_FILE = "questions.xlsx"
private let IMAGES_FOLDER = "images"

private let fileManager = FileManager.default
private let home = fileManager.homeDirectoryForCurrentUser

let colorKeys = [
    "blue": Color.blue,
    "purple": Color.purple,
    "magenta": Color(red: 1, green: 0, blue: 1),
    "green": Color.green,
    "red": Color.red,
    "black": Color.primary,
    "white": Color.secondary,
    "cyan": Color(red: 0, green: 1, blue: 1),
    "gray": Color.gray,
    "orange": Color.orange,
    "pink": Color.pink,
    "yellow": Color.yellow
]

extension String {
    func displayImageName() -> String {
        if self.contains(".jpg") {
            let imageName = String(self.split(separator: ".")[0])
            return imageName.replacingOccurrences(of: "-", with: " ")
        } else {
            return self
        }
    }
    
    func imageURL(from quizName: String) -> URL {
        let quizURL = home.appendingPathComponent("\(GAME_DATA_PATH)/\(quizName)/")
        let imagesURL = quizURL.appendingPathComponent(IMAGES_FOLDER)
        
        return imagesURL.appendingPathComponent("\(self).jpg".replacingOccurrences(of: " ", with: "-"))
    }
}

func getQuizNames() -> [String] {
    let buzzquizUrl = home.appendingPathComponent(GAME_DATA_PATH)
    
    do {
        let contents = try fileManager.contentsOfDirectory(at: buzzquizUrl, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
        return contents.map { $0.lastPathComponent }
      } catch {
        fatalError("~/Buzzquiz directory must contain separate folders for each quiz")
      }
}

private func getWorksheet(url: URL) -> (Worksheet, SharedStrings) {
    var worksheet: Worksheet
    
    guard let file = XLSXFile(filepath: url.path) else {
        fatalError("\(url.lastPathComponent) is corrupted or does not exist")
    }
    
    guard let sharedStrings = try! file.parseSharedStrings() else {
        fatalError("\(url.lastPathComponent) is not formatted correctly")
    }
    
    do {
        let path = try file.parseWorksheetPaths()
        worksheet = try file.parseWorksheet(at: path[0])
    } catch {
        fatalError("\(url.lastPathComponent) is not formatted correctly")
    }
    
    return (worksheet, sharedStrings)
}

private func getCharacterFields(in row: Row, with sharedStrings: SharedStrings) -> (CharacterName, String, String) {
    let name = row.cells[0].stringValue(sharedStrings) ?? ""
    let color = row.cells[1].stringValue(sharedStrings) ?? ""
    let description = row.cells[2].stringValue(sharedStrings) ?? ""
    
    return (name, color, description)
}

private func loadCharacters(at url: URL) -> [QuizCharacter] {
    var characters = [QuizCharacter]()
    
    let (worksheet, sharedStrings) = getWorksheet(url: url)
            
    for row in worksheet.data?.rows ?? [] {
        let (name, color, description) = getCharacterFields(in: row, with: sharedStrings)
        let character = QuizCharacter(name: name,
                                      color: color,
                                      description: description)
        characters.append(character)
    }
    
    return characters
}

private func cellValue(worksheet: Worksheet, column: String, row: UInt, with sharedStrings: SharedStrings) -> String {
    return worksheet.cells(atColumns: [ColumnReference(column)!], rows: [row]).first?.stringValue(sharedStrings) ?? ""
}

private func getAnswer(for characters: [QuizCharacter], from row: [Cell], with sharedStrings: SharedStrings) -> (String, [CharacterName: Score]) {
    var scores = [CharacterName: Score]()
    let answer = row.first?.stringValue(sharedStrings) ?? ""
    
    for i in 1..<row.count {
        scores[characters[i-1].name] = Int(row[i].stringValue(sharedStrings) ?? "0")
    }
    
    return (answer, scores)
}

private func getQuestion(for characters: [QuizCharacter], from worksheet: Worksheet, with sharedStrings: SharedStrings, startingAt firstRow: UInt) -> (String, [Answer], UInt) {
    var answers = [Answer]()

    let q = cellValue(worksheet: worksheet, column: "A", row: firstRow, with: sharedStrings)
        
    var currentRow = firstRow + 2
    
    while currentRow <= (worksheet.data?.rows.last!.reference)! {
        let row = worksheet.cells(atRows: [currentRow])
        
        if row.count == 0 {
            break
        }
        
        let (a, scores) = getAnswer(for: characters, from: row, with: sharedStrings)
        let answer = Answer(a: a, scores: scores)
        
        answers.append(answer)
        currentRow += 1
    }
    
    return (q, answers, currentRow + 1)
}

private func loadQuestions(for characters: [QuizCharacter], at url: URL) -> (String, [Question]) {
    var quizTitle = ""
    var questions = [Question]()
    
    let (worksheet, sharedStrings) = getWorksheet(url: url)

    quizTitle = cellValue(worksheet: worksheet, column: "A", row: 1, with: sharedStrings)
    
    var currentRow: UInt = 3
            
    while currentRow <= (worksheet.data?.rows.last!.reference)! {
        let (q, answers, nextRow) = getQuestion(for: characters, from: worksheet, with: sharedStrings, startingAt: currentRow)
        
        let question = Question(q: q, answers: answers)
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
