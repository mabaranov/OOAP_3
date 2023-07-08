//
//  ContentView.swift
//  Snake
//
//  Created by Михаил Баранов on 06.07.2023.
//

import SwiftUI

struct ContentView: View {
    
    enum direction {
        case up, down, left, right
    }
    
    let minX = UIScreen.main.bounds.minX
    let maxX = UIScreen.main.bounds.maxX
    let minY = UIScreen.main.bounds.minY
    let maxY = UIScreen.main.bounds.maxY
    
    @State var startPos: CGPoint = .zero
    @State var isStarted = true
    @State var gameOver = false
    @State var dir = direction.down
    @State var posArray = [CGPoint(x:10, y:10)]
    @State var foodPos = CGPoint(x:0, y:0)
    let snakeSize:CGFloat = 20
    let timer = Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack{
            Color(red: 0.7, green: 0.9, blue: 0.5)
            ZStack {
                ForEach(0..<posArray.count, id:\.self) { index in
                    Rectangle()
                        .frame(width: self.snakeSize, height: self.snakeSize)
                        .foregroundColor(Color(red: 0.9, green: 0.3, blue: 0.6))
                        .position(self.posArray[index])
                }
                Rectangle()
                    .fill(Color(red: 0.6, green: 0.2, blue: 0.1))
                    .frame(width: snakeSize, height: snakeSize)
                    .position(foodPos)
            }
            if self.gameOver {
                VStack(spacing: 10) {
                    Text("Game Over")
                    Text("Score: \(posArray.count-1)")
                    Button(action: {AppState.shared.gameID=UUID()}) {
                        Text("New Game")
                            .foregroundColor(Color(red: 0.1, green: 0.3, blue: 0.6))
                    }
                }.font(.largeTitle)
            }
        }
        .onAppear(){
            self.foodPos = changeRectPosition()
            self.posArray[0] = changeRectPosition()
        }
        .gesture(DragGesture()
            .onChanged { gesture in
                if self.isStarted {
                    self.startPos = gesture.location
                    self.isStarted.toggle()
                }
            }
            .onEnded { gesture in
                let xDist = abs(gesture.location.x - self.startPos.x)
                let yDist = abs(gesture.location.y - self.startPos.y)
                
                if self.startPos.y < gesture.location.y && yDist > xDist {
                    self.dir = direction.down
                } else if self.startPos.y > gesture.location.y && yDist > xDist {
                    self.dir = direction.up
                } else if self.startPos.x > gesture.location.x && yDist < xDist {
                    self.dir = direction.right
                } else if self.startPos.x < gesture.location.x && yDist < xDist {
                    self.dir = direction.left
                }
                self.isStarted.toggle()
            }
        )
        .onReceive(timer) { (_) in
            if !self.gameOver {
                self.changeDirection()
                if self.posArray[0] == self.foodPos {
                    self.posArray.append(self.posArray[0])
                    self.foodPos = self.changeRectPosition()
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
    func changeDirection() {
        if self.posArray[0].x < minX || self.posArray[0].x > maxX && !gameOver {
            gameOver.toggle()
        } else if self.posArray[0].y < minY || self.posArray[0].y > maxY && !gameOver {
            gameOver.toggle()
        }
        var prev = posArray[0]
        if dir == .down {
            self.posArray[0].y += snakeSize
        } else if dir == .up {
            self.posArray[0].y -= snakeSize
        } else if dir == .left {
            self.posArray[0].x += snakeSize
        } else {
            self.posArray[0].x -= snakeSize
        }
        
        for index in 1..<posArray.count {
            let current = posArray[index]
            posArray[index] = prev
            prev = current
        }
    }
    func changeRectPosition() -> CGPoint {
        let rows = Int(maxX / snakeSize)
        let columns = Int(maxY / snakeSize)
        
        let randomX = Int.random(in: 1..<rows) * Int(snakeSize)
        let randomY = Int.random(in: 1..<columns) * Int(snakeSize)
        
        return CGPoint(x: randomX, y: randomY)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
