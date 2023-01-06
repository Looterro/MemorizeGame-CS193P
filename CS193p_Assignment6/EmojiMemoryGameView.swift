//
//  ContentView.swift
//  CS193p_Assignment6
//
//  Created by Jakub Łata on 05/01/2023.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    
    //ObservedObject sets the point of reference to look for changes in the model
    @ObservedObject var game: EmojiMemoryGame
    
    var body: some View {
        
        VStack {
            
            HStack {
                Text("Theme: \(game.themeName())")
                    .padding()
                    .font(.title2)
                Spacer()
                Text("Score: \(game.score())")
                    .padding()
                    .font(.title2)
            }
            .navigationBarTitleDisplayMode(.inline)

            //Check if all cards are matched and if so display "Game Over"
            if !game.cards.allSatisfy(\.isMatched) {

                gameBody
                
            } else {
                gameOverView
            }
            
            HStack {
                
                newGameButton

            }
            .padding()
                        
        }


    }
    
    //MARK: View components:
    
    var gameBody: some View {
        AspectVGrid(items: game.cards, aspectRatio: 2/3) { card in
            
            if card.isMatched && !card.isFaceUp {
                //You can clear the color of the card for the card to be invisible
                Color.clear
            } else {
                CardView(card: card)
                    .padding(4)
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .scale))
                    .onTapGesture {
                        withAnimation {
                            game.choose(card)
                        }
                    }
            }
        }
        .foregroundColor(Color(rgbaColor: game.theme.color))
        .padding(.horizontal)
    }
    
    var gameOverView: some View {
        VStack {
            Spacer()
            Text("Game Over")
                .font(.largeTitle)
                .foregroundColor(Color(rgbaColor: game.theme.color))
            Text("Highest Score: \(game.calculateHighest())")
            Spacer()
        }
    }
    
    var newGameButton: some View {
        Button {
            withAnimation {
                game.newGame()
            }
        } label: {
            Text("New Game")
                .font(.title)
        }
    }
    
    //MARK: - Card Constants
    
    private struct CardConstants {
        static let aspectRatio: CGFloat = 2/3
        static let dealDuration: Double = 0.5
        static let totalDealDuration: Double = 2
        static let undealtHeight: CGFloat = 90
        static let undealthWidth = undealtHeight * aspectRatio
    }
    
}

