import SwiftUI

struct SunGraphView: View {
    let selectedDate: Date
    let selectedRegion: Region
    @State private var dayData: DayData?
    @State private var goldenWindows: [GoldenWindow] = []
    @State private var highlightedWindow: GoldenWindow?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                headerSection
                
                // Chart
                if let data = dayData {
                    SunAngleChart(dayData: data, highlightWindow: highlightedWindow)
                    
                    // Summary stats
                    statsSection(data: data)
                    
                    // Quick windows preview
                    quickWindowsSection
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 20)
        }
        .background(Color(hex: "FAFAFA"))
        .onAppear {
            calculateData()
        }
        .onChange(of: selectedDate) { _ in
            calculateData()
        }
        .onChange(of: selectedRegion) { _ in
            calculateData()
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 4) {
            Text(formattedDate)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Color(hex: "1F2937"))
            
            Text("\(selectedRegion.rawValue) Region")
                .font(.system(size: 14))
                .foregroundColor(Color(hex: "6B7280"))
        }
    }
    
    private func statsSection(data: DayData) -> some View {
        HStack(spacing: 12) {
            statCard(
                title: "Sunrise",
                value: formatTime(data.sunrise),
                icon: CustomIcon.sunLow
            )
            
            statCard(
                title: "Max Angle",
                value: "\(Int(data.maxAngle))°",
                icon: CustomIcon.sunHigh
            )
            
            statCard(
                title: "Sunset",
                value: formatTime(data.sunset),
                icon: CustomIcon.sunLow
            )
        }
    }
    
    private func statCard(title: String, value: String, icon: some View) -> some View {
        VStack(spacing: 8) {
            icon
                .frame(width: 20, height: 20)
                .foregroundColor(Color(hex: "FF6B35"))
            
            Text(value)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(Color(hex: "1F2937"))
            
            Text(title)
                .font(.system(size: 11))
                .foregroundColor(Color(hex: "9CA3AF"))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 2)
    }
    
    private var quickWindowsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Fishing Windows")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(Color(hex: "1F2937"))
            
            let excellentWindows = goldenWindows.filter { $0.quality == .excellent }
            
            if excellentWindows.isEmpty {
                Text("No excellent windows today. Check morning and evening hours.")
                    .font(.system(size: 13))
                    .foregroundColor(Color(hex: "6B7280"))
                    .padding(.vertical, 8)
            } else {
                ForEach(excellentWindows.prefix(2)) { window in
                    miniWindowCard(window)
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
    }
    
    private func miniWindowCard(_ window: GoldenWindow) -> some View {
        Button(action: {
            if highlightedWindow?.id == window.id {
                highlightedWindow = nil
            } else {
                highlightedWindow = window
            }
        }) {
            HStack {
                Circle()
                    .fill(Color(hex: "22C55E"))
                    .frame(width: 8, height: 8)
                
                Text(window.timeRangeString)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(hex: "1F2937"))
                
                Spacer()
                
                Text("\(window.durationMinutes) min")
                    .font(.system(size: 12))
                    .foregroundColor(Color(hex: "6B7280"))
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(
                highlightedWindow?.id == window.id ?
                Color(hex: "F0FDF4") : Color(hex: "F9FAFB")
            )
            .cornerRadius(8)
        }
    }
    
    private func calculateData() {
        dayData = SunCalculator.calculateDayData(for: selectedDate, latitude: selectedRegion.latitude)
        if let data = dayData {
            goldenWindows = SunCalculator.findGoldenWindows(from: data)
        }
        highlightedWindow = nil
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: selectedDate)
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}
