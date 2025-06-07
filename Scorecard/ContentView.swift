//
//  ContentView.swift
//  Scorecard
//
//  Created by Damian Gwóźdź on 23/05/2025.
//

import SwiftUI
import Combine

enum Corners: String, CaseIterable {
    case Blue
    case Red
}

struct ContentView: View {
    @State var isFiveRound: Bool = false
    @State var finalBlueScore: Int = 0
    @State var finalRedScore: Int = 0

    @State var blueScoresArray: [Int] = [0, 0, 0, 0, 0]
    @State var redScoresArray: [Int] = [0, 0, 0, 0, 0]
    
    @State var finalMessage: String = ""

    let points: [Int] = [10, 9, 8]

    func getWinner() -> Corners? {
        if self.finalBlueScore > self.finalRedScore {
            return Corners.Blue
        }
        else if self.finalBlueScore < self.finalRedScore {
            return Corners.Red
        }
        else {
            return nil
        }
    }

    func calculateFinalScoresForBothCorners() {
        finalBlueScore = sumScoreFromRounds(scoresArray: blueScoresArray)
        finalRedScore = sumScoreFromRounds(scoresArray: redScoresArray)
    }

    func buildFinalMessage() -> String {
        calculateFinalScoresForBothCorners()

        let winner = getWinner()
        var output: String = ""

        if winner == .Blue {
            output = "Winner is BLUE corner\n"
        }
        else if winner == .Red {
            output = "Winner is RED corner\n"
        }
        else {
            output = "It's a draw\n"
        }
        output += "Blue: " + String(finalBlueScore) + "\nRed: " + String(finalRedScore)
        return output
    }

    func getFinalMessage() -> String {
        return buildFinalMessage()
    }
    
    func getNumberOfRounds() -> Int {
        return isFiveRound ? 5 : 3
    }

    func getRoundsArray(numberOfRounds: Int) -> [Int] {
        return isFiveRound ? Array(1...numberOfRounds) : Array(1...numberOfRounds)
    }
    
    func sumScoreFromRounds(scoresArray: [Int]) -> Int {
        var sum = 0
        for score in scoresArray {
            sum += score
        }
        return sum
    }

    func finalizeButton() -> some View {
        return HStack{
            Button("Finalize"){
                self.finalMessage = getFinalMessage()
            }
            Text(self.finalMessage)
        }
    }

    func hStackWithPickersForRoundForBothCorners(roundNumber: Int) -> some View {
        HStack() {
            Picker("Select", selection: $blueScoresArray[roundNumber - 1]) {
                ForEach(points, id: \.self) {elem in
                    Text(String(elem)).tag("x")
                }
                
            }.pickerStyle(.menu)

            Spacer()
            Picker("Select", selection: $redScoresArray[roundNumber - 1]) {
                ForEach(points, id: \.self) {elem in
                    Text(String(elem)).tag("x")
                }
            }.pickerStyle(.menu)
        }
    }

    func vStackWithPickersForBothCorners() -> some View {
        VStack {
            hStackWithPickersForRoundForBothCorners(roundNumber: 1)
            hStackWithPickersForRoundForBothCorners(roundNumber: 2)
            hStackWithPickersForRoundForBothCorners(roundNumber: 3)
            hStackWithPickersForRoundForBothCorners(roundNumber: 4).disabled(!isFiveRound)
            hStackWithPickersForRoundForBothCorners(roundNumber: 5).disabled(!isFiveRound)
        }
    }

    func toogleIsFiveRoundBout() -> some View {
        Toggle("Five round bout", isOn: $isFiveRound)
    }

    func hStacksWithCornerColors() -> some View {
        HStack() {
            Text("Blue")
                .font(.system(size: 30, weight: .bold, design: .default))
                .foregroundColor(.blue)
            Spacer()
            Text("Red")
                .font(.system(size: 30, weight: .bold, design: .default))
                .foregroundColor(.red)
        }
    }

    var body: some View {
        VStack() {
            toogleIsFiveRoundBout()
            hStacksWithCornerColors()
            vStackWithPickersForBothCorners()
            finalizeButton()
        }
    }
}

#Preview {
    ContentView()
}
