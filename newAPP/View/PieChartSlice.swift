//
//  PieChartSlice.swift
//  FitnessTracker
//
//  Created by Yue Teng on 5/3/24.
//

import SwiftUI

struct PieChartSlice: View {
    let data: Double
    let color: Color
    let title: String

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Path { path in
                    let radius = min(geometry.size.width, geometry.size.height) / 2
                    let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    let startAngle = Angle.zero
                    let endAngle = Angle(degrees: Double(data) * 360)

                    path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
                    path.addLine(to: center)
                    path.closeSubpath()
                }
                .fill(color)

                Text(title)
                    .font(.caption)
                    .foregroundColor(.white)
                    .offset(x: geometry.size.width / 4, y: geometry.size.height / 4)
            }
        }
    }
}
