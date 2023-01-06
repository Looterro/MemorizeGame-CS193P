//
//  MemoryGame.swift
//  CS193p_Assignment6
//
//  Created by Jakub Łata on 05/01/2023.
//

import Foundation

//when using struct, use CardContent argument to pass a value for a card, its a generic
//Card content behaves like a equatable, meaning it can be compared to itself using "=="
struct MemoryGame<CardContent: Equatable> /*where CardContent: Equatable*/ {
    //cards is an array of type struct Card
    private(set) var cards: [Card] // : Array<Card>
    private(set) var score = 0
    
    private var indexOfFirstChosenCard: Int?
    
    //outside label is empty, whereas inside of a function its referenced as a card
    //mutating lets the struct know that we intend to change value
    //optional chosenIndex is checked if exists and then we use cards.firstIndex to find a card in a array
    mutating func choose(_ card: Card) {
        //because there is a let statement, we use coma to pass another condition "and"
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }), !cards[chosenIndex].isFaceUp, !cards[chosenIndex].isMatched {
            
            if let potentialMatchIndex = indexOfFirstChosenCard {
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                    
                    //If matched on time, score additional point
                    if cards[chosenIndex].hasEarnedBonus && cards[potentialMatchIndex].hasEarnedBonus {
                        score += 3
                    } else {
                        score += 2
                        
                    }
                    
                } else {
                    if cards[chosenIndex].seen && cards[potentialMatchIndex].seen {
                        score -= 2
                    } else if cards[chosenIndex].seen || cards[potentialMatchIndex].seen {
                        score -= 1
                    }
                }
                indexOfFirstChosenCard = nil
            } else {
                //cards.indicies means that we iterate over cards.count
                for index in cards.indices {
                    if cards[index].isFaceUp {
                        cards[index].isFaceUp = false
                        cards[index].seen = true
                    }
                }
                indexOfFirstChosenCard = chosenIndex
            }
            
            cards[chosenIndex].isFaceUp.toggle()
        }
    }
    

    //Start the game with some set of cards
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        cards = Array<Card>() //[Card]()
        // add numberOfPairsOfCards x 2 cards to cards array
        for pairIndex in 0..<numberOfPairsOfCards {
            
            //create function to generate card content
            let content = createCardContent(pairIndex)
            
            cards.append(Card(content: content, id: pairIndex*2))
            cards.append(Card(content: content, id: pairIndex*2+1))
        }
        //shuffle all the created the pairs once
        cards.shuffle()
    }
    
    //Could be referenced as a MemoryGame.Card in other places of this struct but its unnecessary
    struct Card: Identifiable {
        var isFaceUp: Bool = false {
            //USING PROPERTY OBSERVER ON A VAR OF THE CARD
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }

        var isMatched: Bool = false {
            didSet {
                stopUsingBonusTime()
            }
        }
        var seen: Bool = false
        //Inserting a generic here, that also requires specifying it when passing the struct
        var content: CardContent
        
        //To iterate over an array of cards, this struct needs to be identifiable and contain var id
        var id: Int
        
        // MARK: - CARD Bonus Time

        //this could give matching bonus points if the user matches the card before a certain amount of time passes during which the card is face up

        //can be zero which means "no bonus time available" for this card
        var bonusTimeLimit: TimeInterval = 6

        // how long this card has ever been face up
        private var faceUpTime: TimeInterval {
            
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }

        // the last time this card was turned face up (and is still face up)
        var lastFaceUpDate: Date?

        // the accumulated time this card has been face up in the past (i.e. not including the current time it's been face up if it is currently so)
        var pastFaceUpTime: TimeInterval = 0

        //how much time left before the bonus opportunity runs out
        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }

        //percentage of the bonus time remaining
        var bonusRemaining: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0 ) ? bonusTimeRemaining / bonusTimeLimit : 0
        }

        //whether the card was matched during the bonus time period
        var hasEarnedBonus: Bool {
            isMatched && bonusTimeRemaining > 0
        }

        //whether we are currently face up, unmatched and have not yet used up the bonus window
        var isConsumingBonusTime: Bool {
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }

        //called when the card transitions to face up state
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }

        //called when the card goes back face down (or gets matched)
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            self.lastFaceUpDate = nil
        }
        
    }
    
    //MARK: THEME STRUCT
    
    struct Theme {
        var name: String
        var emojiSet: [String]
        var numberOfPairs: Int
        var color: String
        
        init(name: String, emojiSet: [String], numberOfPairs: Int, color: String) {
            self.name = name
            self.emojiSet = emojiSet
            //Defend against number being higher than emojiSet array length
            self.numberOfPairs = numberOfPairs > emojiSet.count ? emojiSet.count : numberOfPairs
            self.color = color
        }
    }
    
}
