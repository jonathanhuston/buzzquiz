//
//  ChooseQuizView.swift
//  Buzzquiz
//
//  Created by Jonathan Huston on 12/24/20.
//

import SwiftUI

struct ChooseQuizView {
    @StateObject var quizzes = Quizzes()

    @Binding var activeView: ActiveView
    @Binding var quizName: String
}

extension ChooseQuizView: View {
    var body: some View {
        VStack(spacing: 40) {
            Text("Which quiz do you want to play?")
                .font(.title)
                .foregroundColor(.accentColor)
                .padding()
            
            Picker(selection: $quizName, label: Text("")) {
                ForEach(quizzes.names, id:\.self) { name in
                    Text(name).tag(name)
                }
            }
            .padding()
            .pickerStyle(RadioGroupPickerStyle())
            
            HStack {
                Button("Play") {
                    activeView = .questions
                }
                .padding()
                Button("Quit") {
                    activeView = .quit
                }
                .padding()
            }
        }
    }
}

struct ChooseQuizView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseQuizView(activeView: .constant(.chooseQuiz), quizName: .constant("Laika"))
    }
}
