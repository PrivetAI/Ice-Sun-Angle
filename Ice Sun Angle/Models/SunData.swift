import Foundation

enum FishingZone: String {
    case excellent = "Excellent"
    case okay = "Okay"
    case poor = "Poor"
    
    var description: String {
        switch self {
        case .excellent: return "Sun is low - minimal shadow, best time"
        case .okay: return "Sun at angle - acceptable conditions"
        case .poor: return "Sun high - light shines into hole"
        }
    }
    
    static func from(angle: Double) -> FishingZone {
        if angle < 20 {
            return .excellent
        } else if angle < 45 {
            return .okay
        } else {
            return .poor
        }
    }
}

struct SunData: Identifiable {
    let id = UUID()
    let time: Date
    let angle: Double
    let zone: FishingZone
    
    init(time: Date, angle: Double) {
        self.time = time
        self.angle = max(0, angle)
        self.zone = FishingZone.from(angle: self.angle)
    }
}

struct DayData: Identifiable {
    let id = UUID()
    let date: Date
    let sunrise: Date
    let sunset: Date
    let sunDataPoints: [SunData]
    let maxAngle: Double
    
    var dayLength: TimeInterval {
        sunset.timeIntervalSince(sunrise)
    }
}
