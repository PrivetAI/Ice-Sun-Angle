import SwiftUI

enum Tab: Int, CaseIterable {
    case home = 0
    case graph
    case recommendations
    case compare
    case help
    
    var title: String {
        switch self {
        case .home: return "Home"
        case .graph: return "Graph"
        case .recommendations: return "Times"
        case .compare: return "Compare"
        case .help: return "Help"
        }
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: Tab
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Tab.allCases, id: \.rawValue) { tab in
                TabBarItem(
                    tab: tab,
                    isSelected: selectedTab == tab,
                    action: { selectedTab = tab }
                )
            }
        }
        .padding(.horizontal, 8)
        .padding(.top, 8)
        .padding(.bottom, 24)
        .background(
            Color.white
                .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: -4)
        )
    }
}

struct TabBarItem: View {
    let tab: Tab
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                tabIcon
                    .frame(width: 24, height: 24)
                    .foregroundColor(isSelected ? Color(hex: "FF6B35") : Color(hex: "9CA3AF"))
                
                Text(tab.title)
                    .font(.system(size: 10, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(isSelected ? Color(hex: "FF6B35") : Color(hex: "9CA3AF"))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 4)
        }
    }
    
    @ViewBuilder
    private var tabIcon: some View {
        switch tab {
        case .home: CustomIcon.home
        case .graph: CustomIcon.chart
        case .recommendations: CustomIcon.clock
        case .compare: CustomIcon.compare
        case .help: CustomIcon.info
        }
    }
}

// Custom icons using Path (no SF Symbols)
struct CustomIcon {
    static var home: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            Path { path in
                let w = size
                let h = size
                // House shape
                path.move(to: CGPoint(x: w * 0.5, y: h * 0.1))
                path.addLine(to: CGPoint(x: w * 0.9, y: h * 0.45))
                path.addLine(to: CGPoint(x: w * 0.9, y: h * 0.9))
                path.addLine(to: CGPoint(x: w * 0.1, y: h * 0.9))
                path.addLine(to: CGPoint(x: w * 0.1, y: h * 0.45))
                path.closeSubpath()
            }
            .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
        }
    }
    
    static var chart: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            Path { path in
                let w = size
                let h = size
                // Chart curve
                path.move(to: CGPoint(x: w * 0.1, y: h * 0.8))
                path.addQuadCurve(
                    to: CGPoint(x: w * 0.9, y: h * 0.8),
                    control: CGPoint(x: w * 0.5, y: h * 0.1)
                )
            }
            .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round))
        }
    }
    
    static var clock: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            let center = CGPoint(x: size / 2, y: size / 2)
            Path { path in
                // Circle
                path.addEllipse(in: CGRect(x: size * 0.1, y: size * 0.1, width: size * 0.8, height: size * 0.8))
                // Hour hand
                path.move(to: center)
                path.addLine(to: CGPoint(x: center.x, y: size * 0.3))
                // Minute hand
                path.move(to: center)
                path.addLine(to: CGPoint(x: size * 0.65, y: center.y))
            }
            .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round))
        }
    }
    
    static var compare: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            Path { path in
                let w = size
                let h = size
                // Two overlapping rectangles
                path.addRoundedRect(in: CGRect(x: w * 0.1, y: h * 0.2, width: w * 0.5, height: w * 0.6), cornerSize: CGSize(width: 4, height: 4))
                path.addRoundedRect(in: CGRect(x: w * 0.35, y: h * 0.3, width: w * 0.55, height: w * 0.55), cornerSize: CGSize(width: 4, height: 4))
            }
            .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
        }
    }
    
    static var info: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            let center = CGPoint(x: size / 2, y: size / 2)
            Path { path in
                // Circle
                path.addEllipse(in: CGRect(x: size * 0.1, y: size * 0.1, width: size * 0.8, height: size * 0.8))
                // Dot
                path.addEllipse(in: CGRect(x: center.x - 2, y: size * 0.28, width: 4, height: 4))
                // Line
                path.move(to: CGPoint(x: center.x, y: size * 0.42))
                path.addLine(to: CGPoint(x: center.x, y: size * 0.72))
            }
            .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round))
        }
    }
    
    static var sunLow: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            Path { path in
                let w = size
                let h = size
                // Horizon line
                path.move(to: CGPoint(x: 0, y: h * 0.7))
                path.addLine(to: CGPoint(x: w, y: h * 0.7))
                // Half sun
                path.addArc(center: CGPoint(x: w * 0.5, y: h * 0.7), radius: w * 0.25, startAngle: .degrees(180), endAngle: .degrees(0), clockwise: false)
                // Rays
                path.move(to: CGPoint(x: w * 0.5, y: h * 0.2))
                path.addLine(to: CGPoint(x: w * 0.5, y: h * 0.35))
                path.move(to: CGPoint(x: w * 0.2, y: h * 0.45))
                path.addLine(to: CGPoint(x: w * 0.32, y: h * 0.52))
                path.move(to: CGPoint(x: w * 0.8, y: h * 0.45))
                path.addLine(to: CGPoint(x: w * 0.68, y: h * 0.52))
            }
            .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round))
        }
    }
    
    static var sunMedium: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            let center = CGPoint(x: size / 2, y: size / 2)
            Path { path in
                // Sun circle
                path.addEllipse(in: CGRect(x: center.x - size * 0.2, y: center.y - size * 0.2, width: size * 0.4, height: size * 0.4))
                // Rays
                let rayLength: CGFloat = size * 0.12
                let rayStart: CGFloat = size * 0.28
                for i in 0..<8 {
                    let angle = CGFloat(i) * .pi / 4
                    path.move(to: CGPoint(
                        x: center.x + cos(angle) * rayStart,
                        y: center.y + sin(angle) * rayStart
                    ))
                    path.addLine(to: CGPoint(
                        x: center.x + cos(angle) * (rayStart + rayLength),
                        y: center.y + sin(angle) * (rayStart + rayLength)
                    ))
                }
            }
            .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round))
        }
    }
    
    static var sunHigh: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            let center = CGPoint(x: size / 2, y: size * 0.35)
            Path { path in
                // Bright sun circle
                path.addEllipse(in: CGRect(x: center.x - size * 0.22, y: center.y - size * 0.22, width: size * 0.44, height: size * 0.44))
                // Arrow down
                path.move(to: CGPoint(x: size * 0.5, y: size * 0.65))
                path.addLine(to: CGPoint(x: size * 0.5, y: size * 0.9))
                path.move(to: CGPoint(x: size * 0.35, y: size * 0.78))
                path.addLine(to: CGPoint(x: size * 0.5, y: size * 0.9))
                path.addLine(to: CGPoint(x: size * 0.65, y: size * 0.78))
            }
            .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
        }
    }
    
    static var chevronRight: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            Path { path in
                path.move(to: CGPoint(x: size * 0.35, y: size * 0.2))
                path.addLine(to: CGPoint(x: size * 0.65, y: size * 0.5))
                path.addLine(to: CGPoint(x: size * 0.35, y: size * 0.8))
            }
            .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
        }
    }
    
    static var fish: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            Path { path in
                let w = size
                let h = size
                // Fish body
                path.move(to: CGPoint(x: w * 0.85, y: h * 0.5))
                path.addQuadCurve(to: CGPoint(x: w * 0.25, y: h * 0.5), control: CGPoint(x: w * 0.5, y: h * 0.15))
                path.addQuadCurve(to: CGPoint(x: w * 0.85, y: h * 0.5), control: CGPoint(x: w * 0.5, y: h * 0.85))
                // Tail
                path.move(to: CGPoint(x: w * 0.25, y: h * 0.5))
                path.addLine(to: CGPoint(x: w * 0.08, y: h * 0.25))
                path.move(to: CGPoint(x: w * 0.25, y: h * 0.5))
                path.addLine(to: CGPoint(x: w * 0.08, y: h * 0.75))
                // Eye
                path.addEllipse(in: CGRect(x: w * 0.65, y: h * 0.4, width: w * 0.08, height: w * 0.08))
            }
            .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
        }
    }
    
    static var calendar: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            Path { path in
                let w = size
                let h = size
                // Calendar body
                path.addRoundedRect(in: CGRect(x: w * 0.1, y: h * 0.2, width: w * 0.8, height: h * 0.7), cornerSize: CGSize(width: 4, height: 4))
                // Header line
                path.move(to: CGPoint(x: w * 0.1, y: h * 0.38))
                path.addLine(to: CGPoint(x: w * 0.9, y: h * 0.38))
                // Hooks
                path.move(to: CGPoint(x: w * 0.3, y: h * 0.1))
                path.addLine(to: CGPoint(x: w * 0.3, y: h * 0.28))
                path.move(to: CGPoint(x: w * 0.7, y: h * 0.1))
                path.addLine(to: CGPoint(x: w * 0.7, y: h * 0.28))
            }
            .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
        }
    }
}
