import Foundation

struct GoldenWindow: Identifiable {
    let id = UUID()
    let startTime: Date
    let endTime: Date
    let quality: FishingZone
    let averageAngle: Double
    
    var duration: TimeInterval {
        endTime.timeIntervalSince(startTime)
    }
    
    var durationMinutes: Int {
        Int(duration / 60)
    }
    
    var description: String {
        switch quality {
        case .excellent:
            if averageAngle < 10 {
                return "Sun very low on horizon"
            } else {
                return "Sun low, minimal shadow"
            }
        case .okay:
            return "Sun at moderate angle"
        case .poor:
            if averageAngle > 60 {
                return "Sun near zenith"
            } else {
                return "Sun shines into fishing hole"
            }
        }
    }
    
    var timeRangeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return "\(formatter.string(from: startTime)) - \(formatter.string(from: endTime))"
    }
}
