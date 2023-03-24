//
//  ContentView.swift
//  Clock
//
//  Created by Derek Howes on 3/23/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { ctx, size in
                let clock = getAngles(for: timeline.date)
                let rect = CGRect(origin: .zero, size: size)
                let radius = min(size.width, size.height) / 2
                
                let border = radius / 25
                let hLength = radius / 2.5
                let mLength = radius / 1.5
                
                ctx.stroke(Circle()
                    .inset(by: border / 2)
                    .path(in: rect), with: .color(.primary), lineWidth: border)
                
                ctx.translateBy(x: rect.midX, y: rect.midY)
                drawHours(in: ctx, radius: radius)
                drawHand(in: ctx, radius: radius, length: mLength, angle: clock.minute)
                drawHand(in: ctx, radius: radius, length: hLength, angle: clock.hour)
                
                let innerRing = radius / 6
                let ringWidth = radius / 40
                let inner = CGRect(x: -innerRing / 2, y: -innerRing / 2, width : innerRing, height: innerRing)
                ctx.stroke(
                    Circle()
                        .path(in: inner), with: .color(.primary),
                    lineWidth: ringWidth
                )
                
                let sLength = radius * 1.1
                let sWidth = radius / 25
                let secondLine = Capsule()
                    .offset(x: 0, y: -radius / 6)
                    .rotation(clock.second, anchor: .top)
                    .path(in: CGRect(x: -sWidth / 2, y: 0, width: sWidth, height: sLength))
                
                ctx.fill(secondLine, with: .color(.orange))
                
                let centerPiece = Circle()
                    .path(in: inner.insetBy(dx: ringWidth, dy: ringWidth))
                ctx.blendMode = .clear
                ctx.fill(centerPiece, with: .color(.white))
                
                ctx.blendMode = .normal
                ctx.stroke(centerPiece, with: .color(.orange), lineWidth: ringWidth)
                            }
        }
    }
    
    func drawHours(in context: GraphicsContext, radius: Double) {
        let textSize = radius / 4
        let textOffset = radius * 0.75
        
        for i in 1...12 {
            let text = Text(String(i)).font(.system(size: textSize)).bold()
            let point = CGPoint(x: 0, y: -textOffset)
                .applying(CGAffineTransform(rotationAngle: Double(i) * .pi / 6))
            
            context.draw(text, at: point)
        }
    }
    
    func getAngles(for date:Date) ->(hour:Angle, minute: Angle, second:Angle) {
        let parts = Calendar.current.dateComponents([.hour,.minute,.second,.nanosecond], from: .now)
        let h = Double(parts.hour ?? 0)
        let m = Double(parts.minute ?? 0)
        let s = Double(parts.second ?? 0)
        let n = Double(parts.nanosecond ?? 0)
        
        let hour = Angle.degrees(30 * (h + m / 60) + 180)
        let minute = Angle.degrees(6 * (m + s / 60) + 180)
        let second = Angle.degrees(6 * (s + n / 1_000_000_000) + 180)

        return(hour,minute,second)
    }
    
    func drawHand(in context: GraphicsContext, radius: Double, length: Double, angle: Angle) {
        let width = radius/30
        
        let stalk = Rectangle().rotation(angle, anchor: .top)
            .path(in: CGRect(x: -width / 2, y: 0, width: width, height: length))
        context.fill(stalk, with: .color(.primary))
        
        let hand = Capsule()
            .offset(x: 0, y: radius / 5)
            .rotation(angle, anchor: .top)
            .path(in: CGRect(x: -width, y: 0, width: width * 2, height: length))
        
        context.fill(hand, with: .color(.primary))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
