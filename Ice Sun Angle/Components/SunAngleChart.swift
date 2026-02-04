import SwiftUI

struct SunAngleChart: View {
    let dayData: DayData
    var highlightWindow: GoldenWindow? = nil
    var comparisonData: [(date: Date, data: DayData, color: Color)]? = nil
    
    private let chartHeight: CGFloat = 220
    private let excellentThreshold: Double = 20
    private let okayThreshold: Double = 45
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if comparisonData == nil {
                legendView
            }
            
            GeometryReader { geometry in
                let width = geometry.size.width
                
                ZStack(alignment: .topLeading) {
                    // Background zones
                    backgroundZones(width: width)
                    
                    // Grid lines
                    gridLines(width: width)
                    
                    // Comparison lines
                    if let comparison = comparisonData {
                        ForEach(comparison.indices, id: \.self) { index in
                            sunPath(for: comparison[index].data, width: width, color: comparison[index].color, lineWidth: 2)
                        }
                    }
                    
                    // Main sun path
                    sunPath(for: dayData, width: width, color: Color(hex: "FF6B35"), lineWidth: comparisonData != nil ? 3 : 2.5)
                    
                    // Highlight window
                    if let window = highlightWindow {
                        highlightWindowOverlay(window: window, width: width)
                    }
                    
                    // Y-axis labels
                    yAxisLabels
                }
            }
            .frame(height: chartHeight)
            .padding(.leading, 30)
            
            // Time axis
            timeAxis
                .padding(.leading, 30)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
    
    private var legendView: some View {
        HStack(spacing: 16) {
            legendItem(color: Color(hex: "86EFAC"), text: "Best")
            legendItem(color: Color(hex: "FDE68A"), text: "Okay")
            legendItem(color: Color(hex: "FCA5A5"), text: "Poor")
        }
    }
    
    private func legendItem(color: Color, text: String) -> some View {
        HStack(spacing: 6) {
            Circle()
                .fill(color)
                .frame(width: 10, height: 10)
            Text(text)
                .font(.system(size: 12))
                .foregroundColor(Color(hex: "6B7280"))
        }
    }
    
    private func backgroundZones(width: CGFloat) -> some View {
        VStack(spacing: 0) {
            // Poor zone (> 45°)
            Rectangle()
                .fill(Color(hex: "FCA5A5").opacity(0.3))
                .frame(height: chartHeight * (90 - okayThreshold) / 90)
            
            // Okay zone (20° - 45°)
            Rectangle()
                .fill(Color(hex: "FDE68A").opacity(0.3))
                .frame(height: chartHeight * (okayThreshold - excellentThreshold) / 90)
            
            // Excellent zone (< 20°)
            Rectangle()
                .fill(Color(hex: "86EFAC").opacity(0.3))
                .frame(height: chartHeight * excellentThreshold / 90)
        }
        .frame(width: width, height: chartHeight)
        .cornerRadius(8)
    }
    
    private func gridLines(width: CGFloat) -> some View {
        ZStack {
            ForEach([0, 30, 60, 90], id: \.self) { angle in
                let y = chartHeight * (1 - CGFloat(angle) / 90)
                Path { path in
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: width, y: y))
                }
                .stroke(Color(hex: "E5E7EB"), style: StrokeStyle(lineWidth: 0.5, dash: [4, 4]))
            }
        }
    }
    
    private func sunPath(for data: DayData, width: CGFloat, color: Color, lineWidth: CGFloat) -> some View {
        let points = data.sunDataPoints
        guard points.count > 1 else { return AnyView(EmptyView()) }
        
        let totalTime = data.sunset.timeIntervalSince(data.sunrise)
        
        return AnyView(
            Path { path in
                for (index, point) in points.enumerated() {
                    let x = CGFloat(point.time.timeIntervalSince(data.sunrise) / totalTime) * width
                    let y = chartHeight * (1 - CGFloat(point.angle) / 90)
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: x, y: y))
                    } else {
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
            }
            .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
        )
    }
    
    private func highlightWindowOverlay(window: GoldenWindow, width: CGFloat) -> some View {
        let totalTime = dayData.sunset.timeIntervalSince(dayData.sunrise)
        let startX = CGFloat(window.startTime.timeIntervalSince(dayData.sunrise) / totalTime) * width
        let endX = CGFloat(window.endTime.timeIntervalSince(dayData.sunrise) / totalTime) * width
        
        return Rectangle()
            .fill(Color(hex: "FF6B35").opacity(0.2))
            .frame(width: endX - startX, height: chartHeight)
            .offset(x: startX)
            .overlay(
                Rectangle()
                    .fill(Color(hex: "FF6B35"))
                    .frame(width: 2, height: chartHeight)
                    .offset(x: startX)
            )
            .overlay(
                Rectangle()
                    .fill(Color(hex: "FF6B35"))
                    .frame(width: 2, height: chartHeight)
                    .offset(x: endX)
            )
    }
    
    private var yAxisLabels: some View {
        VStack {
            ForEach([90, 60, 30, 0], id: \.self) { angle in
                Text("\(angle)°")
                    .font(.system(size: 10))
                    .foregroundColor(Color(hex: "9CA3AF"))
                    .frame(width: 25, alignment: .trailing)
                    .offset(x: -30)
                if angle != 0 {
                    Spacer()
                }
            }
        }
        .frame(height: chartHeight)
    }
    
    private var timeAxis: some View {
        HStack {
            Text(formatTime(dayData.sunrise))
                .font(.system(size: 11))
                .foregroundColor(Color(hex: "6B7280"))
            
            Spacer()
            
            Text("12:00")
                .font(.system(size: 11))
                .foregroundColor(Color(hex: "6B7280"))
            
            Spacer()
            
            Text(formatTime(dayData.sunset))
                .font(.system(size: 11))
                .foregroundColor(Color(hex: "6B7280"))
        }
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}
