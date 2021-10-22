//
//  ShapeBg.swift
//  Moku
//
//  Created by Dicky Buwono on 22/10/21.
//

import SwiftUI

struct ShapeBg: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint.zero)
        path.addLine(to: CGPoint(x: rect.maxX, y: 0))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addQuadCurve(to: CGPoint(x: 0, y: rect.maxY), control: CGPoint(x: rect.midX, y: rect.maxY + 50))
        path.closeSubpath()
        return path
    }
}

struct ShapeBg_Previews: PreviewProvider {
    static var previews: some View {
        ShapeBg()
            .frame(height: 300)
    }
}
