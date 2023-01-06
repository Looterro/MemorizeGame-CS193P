//
//  Pie.swift
//  Memorize
//
//  Created by Jakub Łata on 04/12/2022.
//

//Create a custom shape
import SwiftUI

//Shape is a view itself
struct Pie: Shape {
    //shapes need to be animated so those need to be vars
    var startAngle: Angle
    var endAngle: Angle
    
    //get new values of start and end angle to animate path
    var animatableData: AnimatablePair<Double, Double> {
        get { AnimatablePair(startAngle.radians, endAngle.radians) }
        set {
            startAngle = Angle.radians(newValue.first)
            endAngle = Angle.radians(newValue.second)
        }
    }
    
    //function to draw shape
    func path(in rect: CGRect) -> Path {
        
        //geting middle points of width and height axis and finding the center point of the card
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let start = CGPoint (
            x: center.x + radius * CGFloat(cos(startAngle.radians)),
            y: center.y + radius * CGFloat(sin(startAngle.radians))
        )
        
        var p = Path()
        p.move(to: center)
        p.addLine(to: start)
        p.addArc(
            center: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true
        )
        
        return p
    }
}
