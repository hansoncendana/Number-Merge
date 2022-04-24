//
//  ContentView.swift
//  NumberMerge
//
//  Created by User12 on 2022/4/23.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("bestScore") var bestScore = 0
    @State private var board = Array(repeating:0, count: 25)
    @State var score = 0
    @State var selectedNum = Int.random(in:1...3)
    @State var alert = false
    
    func newGame() {
        for idx in 0...24 {
            board[idx] = 0
        }
        score = 0
        selectedNum = Int.random(in:1...3)
    }
    func merge(x: Int, y: Int) -> Bool{
        var available: Bool = false
        if 5 * (x - 1) + y >= 0 {
            if board[5 * (x - 1) + y] == board[5 * x + y] {
                board[5 * (x - 1) + y] = 0
                available = true
            }
        }
        if 5 * (x + 1) + y <= 24 {
            if board[5 * (x + 1) + y] == board[5 * x + y] {
                board[5 * (x + 1) + y] = 0
                available =  true
            }
        }
        if 5 * x + (y - 1) >= 0 {
            if board[5 * x + (y - 1)] == board[5 * x + y] {
                board[5 * x + (y - 1)] = 0
                available = true
            }
        }
        if 5 * x + (y + 1) <= 24 {
            if board[5 * x + (y + 1)] == board[5 * x + y] {
                board[5 * x + (y + 1)] = 0
                available = true
            }
        }
        if available == true {
            score += 1
            board[5 * x + y] += 1
        }
        return available
    }
    
    func GameOver() -> Bool {
        for idx in 0...24 {
            if board[idx] == 0 {
                return false
            }
        }
        return true
    }
    
    var body: some View {
        ZStack {
            NavigationView {
                VStack(spacing: 30) {
                    Spacer()
                    VStack {
                        ForEach(0..<5) { x in
                            HStack {
                                ForEach(0..<5) { y in
                                    if board[5 * x + y] == 0 {
                                        Image(systemName: "square")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width:60,height:60)
                                            .border(Color(red:201/255, green:41/255, blue: 100/255))
                                            .onTapGesture {
                                                board[5 * x + y] = selectedNum
                                                var merger:Bool = merge(x: x, y: y)
                                                while merger == true {
                                                    merger = merge(x:x, y:y)
                                                }
                                                selectedNum = Int.random(in: 1...3)
                                                if GameOver() == true {
                                                    if score > bestScore {
                                                        bestScore = score
                                                    }
                                                    alert = true
                                                }
                                            }
                                    }
                                    else {
                                        Image(systemName: "\(board[5 * x + y]).square")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 60, height: 60)
                                            .foregroundColor(Color(red:201/255, green:41/255, blue: 100/255))
                                    }
                                }
                            }
                        }
                    }
                    Image(systemName: "\(selectedNum).square")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 55, height: 55)
                        .foregroundColor(Color(red:201/255, green:41/255, blue: 100/255))
                    Spacer()
                    Spacer()
                }
                .toolbar {
                    ToolbarItem (placement: .navigationBarLeading) {
                        VStack(alignment:.leading) {
                            Text("Best:")
                                .foregroundColor(Color(red:201/255, green:41/255, blue: 100/255))
                            Text("\(bestScore)")
                                .foregroundColor(Color(red:201/255, green:41/255, blue: 100/255))
                        }
                        .padding(.vertical, 10)
                    }
                    ToolbarItem(placement:.principal) {
                        VStack(alignment:.center) {
                            Text("\(score)")
                                .foregroundColor(Color(red:201/255, green:41/255, blue: 100/255))
                                .font(.system(size:30))
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            newGame()
                        } label: {
                            Image(systemName: "arrow.counterclockwise.circle")
                                .foregroundColor(Color(red:201/255, green:41/255, blue: 100/255))
                        }
                    }
                }
                .background(Image("Back"))
                .alert(isPresented: $alert, content: {
                    return Alert(
                        title: Text("Game Over!"))
                })
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
