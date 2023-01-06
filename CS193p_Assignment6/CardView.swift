//
//  CardView.swift
//  CS193p_Assignment6
//
//  Created by Jakub Łata on 06/01/2023.
//

import SwiftUI

struct CardView: View {
    
    //Pass a single card at a time for security. Using alias in EmojiMemoryGame to simplify the card's name
    let card: EmojiMemoryGame.Card
    
    //keep track of time that was left for the card, without breaking the rules that only changes can be animated and things that are already done. We are calculating on the fly the time remaining through this var.
    @State private var animatedBonusRemaining: Double = 0
    
    var body: some View {
        //stack that puts things on top of each other
        GeometryReader { geometry in
            
            ZStack {
                //Group allows for declaring padding and opacity once for both cases of if statement

                    if card.isConsumingBonusTime {
                        //get the percentage of time remaning and convert to angle in degrees, inverted cause its not clockwise
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (-animatedBonusRemaining)*360-90))
                            .onAppear {
                                //Every time the card appears reset the time to the bonus time remaining
                                animatedBonusRemaining = card.bonusRemaining
                                withAnimation(.linear(duration: card.bonusTimeRemaining)) {
                                    //animate remaning time going to zero with the duration the same as of the card.bonusTimeRemaining, even though counting down independently
                                    animatedBonusRemaining = 0
                                }
                            }
                            .padding(5)
                            .opacity(0.5)
                    } else {
                        //get the percentage of time remaning and convert to angle in degrees, inverted cause its not clockwise
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (-card.bonusRemaining)*360-90))
                            .padding(5)
                            .opacity(0.5)
                    }

                Text(card.content)
                    //keep track if card is matched - after matching rotate  360 degrees
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                //Create an implicit animation, that works only with this changing effect! Placement is super important too!
                    .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
                    //Adjust the font for animation, use scale effect that will fit geometry size
                    .font(Font.system(size: DrawingConstants.fontSize))
                //scale effect will animate the font that was set permamently, and the emoji will not fly on screen after rotation
                    .scaleEffect(scale(thatFits: geometry.size))
            }
            //All animations go into either shapes or view modifiers, so its good to put logic in modifiers to animate
            .cardify(isFaceUp: card.isFaceUp)
        }
        
    }
    
    private func scale(thatFits size: CGSize) -> CGFloat {
        min(size.width, size.height) / (DrawingConstants.fontSize / DrawingConstants.fontScale )
    }
    
    //use this only for referencing values all over the views in one place, so you dont have to change things multiple times
    private struct DrawingConstants {
        // provide the type, as for corner radius it takes cgfloat as argument
        static let fontScale: CGFloat = 0.65
        static let fontSize: CGFloat = 32
    }
}

