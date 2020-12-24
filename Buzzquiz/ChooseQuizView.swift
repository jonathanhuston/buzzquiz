//
//  ChooseQuizView.swift
//  Buzzquiz
//
//  Created by Jonathan Huston on 12/24/20.
//

import SwiftUI

struct ChooseQuizView {
    @EnvironmentObject var allQuizzes: AllQuizzes

    @Binding var activeView: ActiveView
    @Binding var quiz: String
}

extension ChooseQuizView: View {
    var body: some View {
        VStack(spacing: 40) {
            Text("Which quiz do you want to play?")
                .font(.title)
                .foregroundColor(.accentColor)
                .padding()
            
            Picker(selection: $quiz, label: Text("")) {
                ForEach(allQuizzes.names, id:\.self) { name in
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
        ChooseQuizView(activeView: .constant(.chooseQuiz), quiz: .constant(""))
    }
}
