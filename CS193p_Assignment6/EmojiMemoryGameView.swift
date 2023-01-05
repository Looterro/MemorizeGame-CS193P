//
//  ContentView.swift
//  CS193p_Assignment6
//
//  Created by Jakub Łata on 05/01/2023.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    
    //Always instatiate this variable to see whats in the view model.
    //ObservedObject sets the point of reference to look for changes in the model
    @ObservedObject var game: EmojiMemoryGame
    
    var body: some View {
        
        //Dont let cards overlap the buttons with scroll view
        VStack {
            
            HStack {
                Text("Theme: \(game.themeName())")
                    .padding()
                    .font(.title)
                Spacer()
                Text("Score: \(game.score())")
                    .padding()
                    .font(.title)
            }
            
            //Check if all cards are matched and if so display "Game Over"
            if !game.cards.allSatisfy(\.isMatched) {
                ScrollView {
                    
                    //You have to use array of gridItems instead of int, because you cant edit any one of them. Choosing adaptive will adapt to paramaters of the screen, with argument for minimum, that establishes the minimal width of one item
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))]) {
                        
                            //for each loop, in the function pass an argument, adding id self to let the forEach loop, with the use in range argument
                            ForEach(game.cards) { card in
                                    CardView(card: card)
                                    .aspectRatio(2/3, contentMode: .fit)
                                    //On tap gesture is an intent on user depart to change some logic in the view model
                                    .onTapGesture {
                                    game.choose(card)
                                    }
                            }
                    }
                    
                }
                .foregroundColor(Color(rgbaColor: game.theme.color))
                //You can define parent attributes, and then rewrite them in the container
                .padding(.horizontal)
                
            } else {
                VStack {
                    Spacer()
                    Text("Game Over")
                        .font(.largeTitle)
                        .foregroundColor(Color(rgbaColor: game.theme.color))
                    Text("Highest Score: \(game.calculateHighest())")
                    Spacer()
                }
            }
            
            Button {
                game.newGame()
            } label: {
                Text("New Game")
                    .font(.largeTitle)
            }
        }
    }
    
}

////Preview modifier, we can add multiple views
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        let game = EmojiMemoryGame()
//        EmojiMemoryGameView(game: game)
//            .preferredColorScheme(.light)
//        EmojiMemoryGameView(game: game)
//            .preferredColorScheme(.dark)
//    }
//}

//Its better to have a couple of small views than few big ones by SwiftUI convention
struct CardView: View {
    
    //Pass a single card at a time for security
    let card: MemoryGame<String>.Card
    
    var body: some View {
        //stack that puts things on top of each other
        ZStack {
            
            //set a local variable to reduce redundancy
            let shape = RoundedRectangle(cornerRadius: 20)
            
            if card.isFaceUp {
                //put fill first and then add additional border
                shape
                    .fill()
                    .foregroundColor(.white)
                //Be default Swift knows to return a function
                shape
                //Attributes are usually written in their own line
                    .strokeBorder(lineWidth: 3)
                
                Text(card.content)
                    .font(.largeTitle)
                
            } else if card.isMatched {
                //change the matched cards to be transparent
                shape.opacity(0)
            } else {
                shape
                    .fill()
            }
        }
    }
}

