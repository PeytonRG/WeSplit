//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Peyton Gasink on 7/11/22.
//

import SwiftUI

struct FlagImage: View {
    var country: String
    
    var body: some View {
        Image(country)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}

struct ContentView: View {
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var alertText = ""
    @State private var questionNumber = 1
    @State private var continueButtonText = ""
    
    @State private var animationAmount = 0.0
    @State private var opacity = 1.0
    @State private var scale = 1.0
    @State private var tappedFlag = 0
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            // flag was tapped
                            flagTapped(number)
                        } label: {
                            FlagImage(country: countries[number])
                        }
                        
                        .rotationEffect(tappedFlag == number ? .degrees(animationAmount) : .degrees(0))
                        .opacity(tappedFlag != number ? opacity : 1)
                        .scaleEffect(tappedFlag != number ? scale : 1)
//                        .onTapGesture {
//                            print("tapped \(countries[number])")
//                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button(continueButtonText, action: askQuestion)
        } message: {
            Text(alertText)
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
            alertText = "Your score is \(score)"
        }
        else {
            scoreTitle = "Wrong"
            if score > 0 {
                score -= 1
            }
            alertText = "That's the flag of \(countries[number])"
        }
        if questionNumber == 8 {
            scoreTitle = "Final Results"
            alertText = "Your final score is \(score)"
            continueButtonText = "Play Again"
        }
        else {
            continueButtonText = "Continue"
        }
        showingScore = true
        
        tappedFlag = number
        
        withAnimation {
            opacity = 0.25
            scale = 0.5
            animationAmount += 360
        }
    }
    
    func askQuestion() {
        if questionNumber == 8 {
            score = 0
            questionNumber = 1
        }
        else {
            questionNumber += 1
        }
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        withAnimation {
            opacity = 1
            scale = 1
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
