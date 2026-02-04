import Foundation

class SunCalculator {
    
    private static let degreesToRadians = Double.pi / 180.0
    private static let radiansToDegrees = 180.0 / Double.pi
    
    // MARK: - Public Methods
    
    static func calculateDayData(for date: Date, latitude: Double) -> DayData {
        let calendar = Calendar.current
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: date) ?? 1
        
        let (sunrise, sunset) = calculateSunriseSunset(dayOfYear: dayOfYear, latitude: latitude, date: date)
        
        var sunDataPoints: [SunData] = []
        var maxAngle: Double = 0
        
        let interval: TimeInterval = 10 * 60 // 10 minutes
        var currentTime = sunrise
        
        while currentTime <= sunset {
            let angle = calculateSunAngle(time: currentTime, dayOfYear: dayOfYear, latitude: latitude)
            let sunData = SunData(time: currentTime, angle: angle)
            sunDataPoints.append(sunData)
            maxAngle = max(maxAngle, angle)
            currentTime = currentTime.addingTimeInterval(interval)
        }
        
        return DayData(
            date: date,
            sunrise: sunrise,
            sunset: sunset,
            sunDataPoints: sunDataPoints,
            maxAngle: maxAngle
        )
    }
    
    static func findGoldenWindows(from dayData: DayData) -> [GoldenWindow] {
        var windows: [GoldenWindow] = []
        var currentZone: FishingZone?
        var windowStart: Date?
        var angleSum: Double = 0
        var angleCount: Int = 0
        
        for dataPoint in dayData.sunDataPoints {
            if currentZone == nil {
                currentZone = dataPoint.zone
                windowStart = dataPoint.time
                angleSum = dataPoint.angle
                angleCount = 1
            } else if dataPoint.zone == currentZone {
                angleSum += dataPoint.angle
                angleCount += 1
            } else {
                if let start = windowStart, let zone = currentZone {
                    let window = GoldenWindow(
                        startTime: start,
                        endTime: dataPoint.time,
                        quality: zone,
                        averageAngle: angleSum / Double(angleCount)
                    )
                    windows.append(window)
                }
                currentZone = dataPoint.zone
                windowStart = dataPoint.time
                angleSum = dataPoint.angle
                angleCount = 1
            }
        }
        
        // Add the last window
        if let start = windowStart, let zone = currentZone, let lastPoint = dayData.sunDataPoints.last {
            let window = GoldenWindow(
                startTime: start,
                endTime: lastPoint.time,
                quality: zone,
                averageAngle: angleSum / Double(angleCount)
            )
            windows.append(window)
        }
        
        return windows
    }
    
    // MARK: - Private Methods
    
    private static func calculateSunriseSunset(dayOfYear: Int, latitude: Double, date: Date) -> (sunrise: Date, sunset: Date) {
        let latRad = latitude * degreesToRadians
        
        // Solar declination
        let declination = 23.45 * sin(degreesToRadians * (360.0 / 365.0) * Double(dayOfYear - 81))
        let declRad = declination * degreesToRadians
        
        // Hour angle at sunrise/sunset
        let cosHourAngle = -tan(latRad) * tan(declRad)
        let clampedCos = max(-1, min(1, cosHourAngle))
        let hourAngle = acos(clampedCos) * radiansToDegrees
        
        // Convert to hours from solar noon
        let hoursFromNoon = hourAngle / 15.0
        
        let calendar = Calendar.current
        let noon = calendar.date(bySettingHour: 12, minute: 0, second: 0, of: date) ?? date
        
        let sunrise = noon.addingTimeInterval(-hoursFromNoon * 3600)
        let sunset = noon.addingTimeInterval(hoursFromNoon * 3600)
        
        return (sunrise, sunset)
    }
    
    private static func calculateSunAngle(time: Date, dayOfYear: Int, latitude: Double) -> Double {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: time)
        let minute = calendar.component(.minute, from: time)
        let decimalHour = Double(hour) + Double(minute) / 60.0
        
        let latRad = latitude * degreesToRadians
        
        // Solar declination
        let declination = 23.45 * sin(degreesToRadians * (360.0 / 365.0) * Double(dayOfYear - 81))
        let declRad = declination * degreesToRadians
        
        // Hour angle (15 degrees per hour from solar noon)
        let hourAngle = (decimalHour - 12.0) * 15.0
        let hourAngleRad = hourAngle * degreesToRadians
        
        // Solar elevation angle
        let sinElevation = sin(latRad) * sin(declRad) + cos(latRad) * cos(declRad) * cos(hourAngleRad)
        let elevation = asin(sinElevation) * radiansToDegrees
        
        return max(0, elevation)
    }
}
