//
//  PieChartView.swift
//  newAPP
//
//  Created by Yue Teng on 4/21/24.
//

import SwiftUI

struct PieChart: View {
    var data: [Double]
    var colors: [Color]

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<data.count, id: \.self) { index in
                    PathShape(data: data,
                              colors: colors,
                              index: index)
                        .fill(colors[index])
                        .frame(width: min(geometry.size.width, geometry.size.height),
                               height: min(geometry.size.width, geometry.size.height))
                        .offset(x: (geometry.size.width - min(geometry.size.width, geometry.size.height)) / 2,
                                y: (geometry.size.height - min(geometry.size.width, geometry.size.height)) / 2)
                        .padding()
                }
            }
            /*.onAppear {
                print("PieChart data: \(data)")
                print("PieChart colors: \(colors)")
            }*/
        }
    }

    struct PathShape: Shape {
        var data: [Double]
        var colors: [Color]
        var index: Int

        func path(in rect: CGRect) -> Path {
            var path = Path()
            let total = data.reduce(0, +)
            var startAngle: Double = 0

            for (i, value) in data.enumerated() {
                let angle = .pi * 2 * (value / total)
                if i == index {
                    let center = CGPoint(x: rect.midX, y: rect.midY)
                    path.move(to: center)
                    path.addArc(center: center,
                                radius: min(rect.width, rect.height) / 2,
                                startAngle: .init(radians: startAngle),
                                endAngle: .init(radians: startAngle + angle),
                                clockwise: false)
                }
                startAngle += angle
            }

            return path
        }
    }
    
}
