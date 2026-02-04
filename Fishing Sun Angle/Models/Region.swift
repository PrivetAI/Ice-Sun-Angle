import Foundation

enum Region: String, CaseIterable, Identifiable {
    case north = "North"
    case center = "Center"
    case south = "South"
    
    var id: String { rawValue }
    
    var latitude: Double {
        switch self {
        case .north: return 65.0
        case .center: return 55.0
        case .south: return 45.0
        }
    }
    
    var description: String {
        switch self {
        case .north: return "Arctic regions (65°N)"
        case .center: return "Central regions (55°N)"
        case .south: return "Southern regions (45°N)"
        }
    }
}
