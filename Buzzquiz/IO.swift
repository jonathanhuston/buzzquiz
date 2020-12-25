//
//  IO.swift
//  Buzzquiz
//
//  Created by Jonathan Huston on 12/25/20.
//

import Foundation

func getQuizNames() -> [String] {
    let fileManager = FileManager.default
    let home = fileManager.homeDirectoryForCurrentUser
    let buzzquizUrl = home.appendingPathComponent("Buzzquiz")
    
    do {
        let contents = try fileManager.contentsOfDirectory(at: buzzquizUrl, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
        return contents.map { $0.lastPathComponent }
      } catch {
        return []
      }
}
