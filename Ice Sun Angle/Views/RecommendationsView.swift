import SwiftUI

struct RecommendationsView: View {
    let selectedDate: Date
    let selectedRegion: Region
    @Binding var selectedTab: Tab
    @State private var goldenWindows: [GoldenWindow] = []
    @State private var selectedWindow: GoldenWindow?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                headerSection
                
                // Summary card
                summaryCard
                
                // Windows list
                windowsList
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 20)
        }
        .background(Color(hex: "FAFAFA"))
        .onAppear {
            calculateWindows()
        }
        .onChange(of: selectedDate) { _ in
            calculateWindows()
        }
        .onChange(of: selectedRegion) { _ in
            calculateWindows()
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 4) {
            Text("Fishing Times")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Color(hex: "1F2937"))
            
            Text(formattedDate)
                .font(.system(size: 14))
                .foregroundColor(Color(hex: "6B7280"))
        }
    }
    
    private var summaryCard: some View {
        let excellent = goldenWindows.filter { $0.quality == .excellent }
        let okay = goldenWindows.filter { $0.quality == .okay }
        let poor = goldenWindows.filter { $0.quality == .poor }
        
        let excellentTime = excellent.reduce(0) { $0 + $1.durationMinutes }
        let okayTime = okay.reduce(0) { $0 + $1.durationMinutes }
        let poorTime = poor.reduce(0) { $0 + $1.durationMinutes }
        
        return HStack(spacing: 0) {
            summaryItem(
                label: "Best",
                minutes: excellentTime,
                color: Color(hex: "22C55E")
            )
            
            Divider()
                .frame(height: 40)
            
            summaryItem(
                label: "Okay",
                minutes: okayTime,
                color: Color(hex: "EAB308")
            )
            
            Divider()
                .frame(height: 40)
            
            summaryItem(
                label: "Poor",
                minutes: poorTime,
                color: Color(hex: "EF4444")
            )
        }
        .padding(.vertical, 16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
    }
    
    private func summaryItem(label: String, minutes: Int, color: Color) -> some View {
        VStack(spacing: 4) {
            Circle()
                .fill(color)
                .frame(width: 10, height: 10)
            
            Text(formatDuration(minutes))
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(Color(hex: "1F2937"))
            
            Text(label)
                .font(.system(size: 11))
                .foregroundColor(Color(hex: "6B7280"))
        }
        .frame(maxWidth: .infinity)
    }
    
    private var windowsList: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Time Windows")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(Color(hex: "1F2937"))
            
            if goldenWindows.isEmpty {
                Text("Calculating windows...")
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "6B7280"))
            } else {
                // Sort by quality (excellent first)
                let sortedWindows = goldenWindows.sorted { window1, window2 in
                    let order1 = qualityOrder(window1.quality)
                    let order2 = qualityOrder(window2.quality)
                    if order1 != order2 {
                        return order1 < order2
                    }
                    return window1.startTime < window2.startTime
                }
                
                ForEach(sortedWindows) { window in
                    TimeWindowCard(window: window) {
                        selectedTab = .graph
                    }
                }
            }
        }
    }
    
    private func qualityOrder(_ quality: FishingZone) -> Int {
        switch quality {
        case .excellent: return 0
        case .okay: return 1
        case .poor: return 2
        }
    }
    
    private func calculateWindows() {
        let dayData = SunCalculator.calculateDayData(for: selectedDate, latitude: selectedRegion.latitude)
        goldenWindows = SunCalculator.findGoldenWindows(from: dayData)
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: selectedDate)
    }
    
    private func formatDuration(_ minutes: Int) -> String {
        if minutes >= 60 {
            let hours = minutes / 60
            let mins = minutes % 60
            if mins > 0 {
                return "\(hours)h \(mins)m"
            }
            return "\(hours)h"
        }
        return "\(minutes)m"
    }
}
