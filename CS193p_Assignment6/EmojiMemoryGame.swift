//
//  EmojiMemoryGame.swift
//  CS193p_Assignment6
//
//  Created by Jakub Łata on 05/01/2023.
//

import SwiftUI



// View Model is a class, as opposed to structs in models and views
// Observable objects notifies that something changed in the logic
class EmojiMemoryGame: ObservableObject {
    
    init(theme: Theme) {
//        self.theme = EmojiMemoryGame.themes.randomElement()!
//        self.theme.numberOfPairs = Int.random(in: 4 ..< theme.emojiSet.count)
        self.theme = theme
        self.model = EmojiMemoryGame.createMemoryGame(theme: theme)
    }
    
    //static allows for emojis to be global variable and initialize independently of the class
//    static var themes: [MemoryGame<String>.Theme] = [
//        MemoryGame<String>.Theme(name: "Vehicles",
//                                emojiSet: ["✈️", "🚂", "🚀", "🚗", "🛵", "🚲"],
//                                numberOfPairs: 6,
//                                color: "blue"
//                               ),
//        MemoryGame<String>.Theme(name: "Animals",
//                                emojiSet: ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🐻‍❄️", "🐨", "🐯", "🦁", "🐮", "🐷", "🐵"],
//                                numberOfPairs: 8,
//                                color: "red"
//                               ),
//        MemoryGame<String>.Theme(name: "Sports",
//                                emojiSet: ["⚽️", "🏀", "🏈", "⚾️", "🎾", "🏉", "🥏", "🏐", "🎱"],
//                                numberOfPairs: 4,
//                                color: "yellow"
//                               )
//    ]
    
    static func createMemoryGame(theme: Theme) -> MemoryGame<String> {
        
        // in means a function and everything before is a parameter (here an index) and return value is already specified in the model, so we only write emojis we want to return
        /*return*/ MemoryGame<String>(numberOfPairsOfCards: theme.numberOfPairs) { pairIndex in //(pairIndex: Int) -> String in
            theme.emojiSet[pairIndex]
        }
    }
        
    //Only the view models code can see the model thanks to decorator private in front of var, no one else can reference it. Its part of an access control. Private(set) allows to look at the model for other views, but cannot change them
    //Published is decorator that notifies view that something changed every time it changes
    @Published private var model: MemoryGame<String>
    
    let theme: Theme
    
    //Keep track of the highest score
    var highestScore = 0
    
    func calculateHighest() -> Int {
        if model.score > highestScore {
            highestScore = model.score
            return highestScore
        }
        return highestScore
    }
    
    func score() -> Int {
        return model.score
    }
    
    func themeName() -> String {
        return theme.name
    }
    
//    var themeColor: Color {
//        switch theme.color {
//        case "blue":
//            return .blue
//        case "red":
//            return .red
//        case "yellow":
//            return .yellow
//        default:
//            return .red
//        }
//    }
    
    //Making a copy of cards without directly changing them in the model
    var cards: [MemoryGame<String>.Card]/*Array<GameModel<String>.Card>*/ {
        return model.cards
    }
    
    //Mark: - Intent(s)
    
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }
    
    func newGame () {
//        theme = EmojiMemoryGame.themes.randomElement()!
//        theme.numberOfPairs = Int.random(in: 4 ..< theme.emojiSet.count)
        model = EmojiMemoryGame.createMemoryGame(theme: theme)
    }
}

