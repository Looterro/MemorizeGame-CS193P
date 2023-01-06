//
//  Cardify.swift
//  Memorize
//
//  Created by Jakub Łata on 11/12/2022.
//

import SwiftUI

//adding view modifier that will take a card contents and make them an actual card
// animatableModifier is animatable and a view modifier protocol
struct Cardify: AnimatableModifier {
    
    init(isFaceUp: Bool) {
        //initialize the view modifier and if the card is face up then rotate to 0 degrees, showing the contents of the card
        rotation = isFaceUp ? 0: 180 // in order to not let this switch immediately from 0 to 180 degrees we use var animatableData on animatableModifier protocol to struct Cardify
    }
    
    //data that impacts this view modifiers animations, this is how we tell what data we want to animate within animatablemodifier, rotation gets called over and over and over, making sure its animated
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }

    
    var rotation: Double // custom animation parameter to make sure animation work the way we intend, in degrees
    
    func body(content: Content) -> some View {
        
        ZStack {
            
            //set a local variable to reduce redundancy
            let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
            
            //If rotation is smaller than 90, show the cart, 90 to 180 is face down when we rotate the card in animation
            if rotation < 90 {
                //put fill first and then add additional border
                shape
                    .fill()
                    .foregroundColor(.white)
                //Be default Swift knows to return a function
                shape
                //Attributes are usually written in their own line
                    .strokeBorder(lineWidth: DrawingConstants.lineWidth)
                
            } else {
                shape
                    .fill()
            }
            
            //View that we are modyfing!
            content
                //In order to make animation work for the second card, it must have its content already loaded on the view. But it cannot be visible to the user cause then the memory game wouldnt make sense- content would be visible! So only change opacity when face up
                //if rotation is less than 90 then show the card
                .opacity(rotation < 90 ? 1 : 0)
            
        }
        //rotate the whole Zstack when it face down and its about to be flipped - rotate from 180 to 0 and at 90 display content of the card
        .rotation3DEffect(Angle.degrees(rotation), axis: (0, 1, 0))
        
    }
    
    //use this only for referencing values all over the views in one place, so you dont have to change things multiple times
    private struct DrawingConstants {
        // provide the type, as for corner radius it takes cgfloat as argument
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 3
    }
    
}

//create an extension on View Protocol that allows the modifier to be called .cardify instead of .modifier(Cardify(isFaceUp: Bool))
extension View {
    func cardify (isFaceUp: Bool) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp))
    }
}
