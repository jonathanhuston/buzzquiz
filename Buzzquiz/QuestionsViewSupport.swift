//
//  QuestionsViewSupport.swift
//  Buzzquiz
//
//  Created by Jonathan Huston on 12/24/20.
//

import SwiftUI

class QuestionsViewSupport: ObservableObject {
    @Published var data = QuestionsModel(quizName: "Laika")
}

