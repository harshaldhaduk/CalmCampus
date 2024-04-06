//
//  artistic.swift
//  CalmCampus
//
//  Created by Harshal Dhaduk on 3/15/24.
//

import SwiftUI
import Foundation

struct artistic: View {
    
    @State private var currentLine = Line()
    @State private var lines: [Line] = []
    @State private var thickness: Double = 1.0
    @State private var selectedColor: Color = .red // Added selectedColor state
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Canvas { context, size in
                    for line in lines {
                        var path = Path()
                        path.addLines(line.points)
                        context.stroke(path, with: .color(line.color), lineWidth: CGFloat(line.lineWidth))
                    }
                    // Draw current line in real-time
                    if !currentLine.points.isEmpty {
                        var path = Path()
                        path.addLines(currentLine.points)
                        context.stroke(path, with: .color(currentLine.color), lineWidth: CGFloat(currentLine.lineWidth))
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height * 0.8) // Adjusted canvas height
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            let currentPoint = value.location
                            currentLine.points.append(currentPoint)
                            currentLine.lineWidth = thickness // Update thickness
                            currentLine.color = selectedColor // Update color
                        }
                        .onEnded { _ in
                            lines.append(currentLine)
                            currentLine = Line()
                        }
                )
                
                Spacer()
                
                HStack {
                    Slider(value: $thickness, in: 1...20) {
                        Text("Thickness")
                    }
                    .frame(maxWidth: geometry.size.width * 0.6) // Adjusted slider width
                    
                    Divider()
                    
                    ColorPickerView(selectedColor: $selectedColor) // Pass selectedColor binding
                }
                .padding()
                .frame(width: geometry.size.width, height: geometry.size.height * 0.2) // Adjusted picker/slider container height
            }
        }
    }
}

struct ColorPickerView: View {
    
    let colors = [Color.red, Color.orange, Color.green, Color.blue, Color.purple]
    @Binding var selectedColor: Color
    
    var body: some View {
        HStack {
            ForEach(colors, id: \.self) { color in
                Image(systemName: self.selectedColor == color ? Constants.Icons.recordCircleFill : Constants.Icons.circleFill)
                    .foregroundColor(color)
                    .font(.system(size: 24))
                    .clipShape(Circle())
                    .onTapGesture {
                        self.selectedColor = color
                    }
            }
        }
    }
}

struct Constants {
    struct Icons {
        static let plusCircle = "plus.circle"
        static let line3HorizontalCircleFill = "line.3.horizontal.circle.fill"
        static let circle = "circle"
        static let circleInsetFilled = "circle.inset.filled"
        static let exclaimationMarkCircle = "exclamationmark.circle"
        static let recordCircleFill = "record.circle.fill"
        static let trayCircleFill = "tray.circle.fill"
        static let circleFill = "circle.fill"
    }
}

struct Line {
    var points = [CGPoint]()
    var color: Color = .red
    var lineWidth: Double = 1.0
}

struct artistic_Previews: PreviewProvider {
    static var previews: some View {
        artistic()
    }
}
