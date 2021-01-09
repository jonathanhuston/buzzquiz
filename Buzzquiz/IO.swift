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
private let IMAGES_FOLDER = "Images"

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
    var isImage: Bool {
        return self.contains(".jpg")
    }
    
    var imageName: String {
        if self.isImage {
            return String(self.split(separator: ".")[0]).replacingOccurrences(of: "-", with: " ")
        } else {
            return self
        }
    }
    
    func imageURL(from quizName: String) -> URL {
        let imagesURL = home.appendingPathComponent("\(GAME_DATA_PATH)/\(quizName)/\(IMAGES_FOLDER)")
        
//        if !fileManager.fileExists(atPath: imagesURL.path) {
//            fatalError("Images folder not found")
//        }
        
        let imageURL = imagesURL.appendingPathComponent("\(self).jpg".replacingOccurrences(of: " ", with: "-"))
                                
//        if !fileManager.fileExists(atPath: imageURL.path) {
//            fatalError("\(imageURL.lastPathComponent) not found")
//        }
        
        return imageURL
    }
}

func getQuizNames() -> (names: [String]?, error: String) {
    let buzzquizUrl = home.appendingPathComponent(GAME_DATA_PATH)
    
    do {
        let contents = try fileManager.contentsOfDirectory(at: buzzquizUrl, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
        
        if contents.isEmpty {
            return (nil, "Buzzquiz folder much contain subfolders for each quiz")
        }
        
        return (contents.map { $0.lastPathComponent }, ":ok")
      } catch {
        return (nil, "Buzzquiz folder not found in home directory")
      }
}

private func getWorksheet(url: URL) -> (Worksheet?, SharedStrings?, error: String) {
    var worksheet: Worksheet
    
    guard let file = XLSXFile(filepath: url.path) else {
        return (nil, nil, "\(url.lastPathComponent) not found")
    }
    
    guard let sharedStrings = try! file.parseSharedStrings() else {
        return (nil, nil, "\(url.lastPathComponent) not formatted correctly")
    }
    
    do {
        let path = try file.parseWorksheetPaths()
        worksheet = try file.parseWorksheet(at: path[0])
    } catch {
        return (nil, nil, "\(url.lastPathComponent) not formatted correctly")
    }
    
    return (worksheet, sharedStrings, ":ok")
}

private func getCharacterFields(in row: Row, with sharedStrings: SharedStrings) -> (CharacterName, String, String, error: String) {
    if row.cells.count < 3 {
        return ("", "", "", "\(CHARACTERS_FILE) not formatted correctly")
    }

    let name = row.cells[0].stringValue(sharedStrings) ?? ""
    let color = row.cells[1].stringValue(sharedStrings) ?? "black"
    let description = row.cells[2].stringValue(sharedStrings) ?? ""
    
    return (name, color, description, ":ok")
}

private func loadCharacters(at url: URL) -> ([QuizCharacter]?, error: String) {
    var characters = [QuizCharacter]()
    
    let (ws, ss, error) = getWorksheet(url: url)
    
    guard let worksheet = ws, let sharedStrings = ss else {
        return (nil, error)
    }
            
    for row in worksheet.data?.rows ?? [] {
        let (name, color, description, error) = getCharacterFields(in: row, with: sharedStrings)
        
        if error != ":ok" {
            return (nil, error)
        }
        
        let character = QuizCharacter(name: name,
                                      color: color,
                                      description: description)
        characters.append(character)
    }
    
    return (characters, ":ok")
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

private func loadQuestions(for characters: [QuizCharacter], at url: URL) -> (quizTitle: String?, questions: [Question]?, error: String) {
    var quizTitle = ""
    var questions = [Question]()
    
    let (ws, ss, error) = getWorksheet(url: url)
    
    guard let worksheet = ws, let sharedStrings = ss else {
        return (nil, nil, error)
    }

    quizTitle = cellValue(worksheet: worksheet, column: "A", row: 1, with: sharedStrings)
    
    var currentRow: UInt = 3
            
    while currentRow <= (worksheet.data?.rows.last!.reference)! {
        let (q, answers, nextRow) = getQuestion(for: characters, from: worksheet, with: sharedStrings, startingAt: currentRow)
        
        let question = Question(q: q, answers: answers)
        questions.append(question)
        currentRow = nextRow
    }
    
    return (quizTitle, questions, ":ok")
}

func loadQuizData(quizName: String) -> (quiz: Quiz?, error: String) {
    let quizURL = home.appendingPathComponent("\(GAME_DATA_PATH)/\(quizName)/")
    let charactersURL = quizURL.appendingPathComponent(CHARACTERS_FILE)
    let questionsURL = quizURL.appendingPathComponent(QUESTIONS_FILE)

    let (chars, charactersError) = loadCharacters(at: charactersURL)
    
    guard let characters = chars else {
        return (nil, charactersError)
    }
    
    let (qt, quests, questionsError) = loadQuestions(for: characters, at: questionsURL)
    
    guard let quizTitle = qt, let questions = quests else {
        return (nil, questionsError)
    }
    
    let quiz = Quiz(quizName: quizName,
                    quizTitle: quizTitle,
                    characters: characters,
                    questions: questions)
    
    return (quiz, ":ok")
}
