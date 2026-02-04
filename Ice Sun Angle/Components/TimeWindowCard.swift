import SwiftUI

struct TimeWindowCard: View {
    let window: GoldenWindow
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                // Quality indicator
                qualityIndicator
                
                // Content
                VStack(alignment: .leading, spacing: 4) {
                    Text(window.timeRangeString)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(hex: "1F2937"))
                    
                    Text(window.description)
                        .font(.system(size: 13))
                        .foregroundColor(Color(hex: "6B7280"))
                }
                
                Spacer()
                
                // Duration
                VStack(alignment: .trailing, spacing: 2) {
                    Text("\(window.durationMinutes) min")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(Color(hex: "6B7280"))
                    
                    Text("Avg \(Int(window.averageAngle))°")
                        .font(.system(size: 11))
                        .foregroundColor(Color(hex: "9CA3AF"))
                }
                
                // Arrow
                CustomIcon.chevronRight
                    .frame(width: 16, height: 16)
                    .foregroundColor(Color(hex: "D1D5DB"))
            }
            .padding(16)
            .background(cardBackground)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 2)
        }
    }
    
    private var qualityIndicator: some View {
        ZStack {
            Circle()
                .fill(qualityColor.opacity(0.2))
                .frame(width: 44, height: 44)
            
            qualityIcon
                .frame(width: 24, height: 24)
                .foregroundColor(qualityColor)
        }
    }
    
    private var qualityColor: Color {
        switch window.quality {
        case .excellent: return Color(hex: "22C55E")
        case .okay: return Color(hex: "EAB308")
        case .poor: return Color(hex: "EF4444")
        }
    }
    
    @ViewBuilder
    private var qualityIcon: some View {
        switch window.quality {
        case .excellent: CustomIcon.sunLow
        case .okay: CustomIcon.sunMedium
        case .poor: CustomIcon.sunHigh
        }
    }
    
    @ViewBuilder
    private var cardBackground: some View {
        switch window.quality {
        case .excellent:
            Color(hex: "F0FDF4")
        case .okay:
            Color(hex: "FEFCE8")
        case .poor:
            Color(hex: "FEF2F2")
        }
    }
}
