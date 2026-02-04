import SwiftUI

struct CompareView: View {
    let baseDate: Date
    let selectedRegion: Region
    
    @State private var selectedDates: Set<Date> = []
    @State private var comparisonData: [(date: Date, data: DayData, color: Color)] = []
    
    private let comparisonColors: [Color] = [
        Color(hex: "3B82F6"),
        Color(hex: "8B5CF6"),
        Color(hex: "10B981")
    ]
    
    private var availableDates: [Date] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        var dates: [Date] = []
        
        for i in -7...14 {
            if let date = calendar.date(byAdding: .day, value: i, to: today) {
                dates.append(date)
            }
        }
        return dates
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                headerSection
                
                // Date selection
                dateSelectionSection
                
                // Comparison chart
                if !comparisonData.isEmpty {
                    chartSection
                    
                    // Legend
                    legendSection
                    
                    // Stats comparison
                    statsComparisonSection
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 20)
        }
        .background(Color(hex: "FAFAFA"))
        .onAppear {
            // Auto-select base date
            let calendar = Calendar.current
            let baseStart = calendar.startOfDay(for: baseDate)
            selectedDates.insert(baseStart)
            updateComparisonData()
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 4) {
            Text("Compare Days")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Color(hex: "1F2937"))
            
            Text("Select up to 3 days to compare")
                .font(.system(size: 14))
                .foregroundColor(Color(hex: "6B7280"))
        }
    }
    
    private var dateSelectionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Select Dates")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color(hex: "6B7280"))
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(availableDates, id: \.self) { date in
                        compareDateCell(date: date)
                    }
                }
            }
        }
    }
    
    private func compareDateCell(date: Date) -> some View {
        let calendar = Calendar.current
        let isSelected = selectedDates.contains(calendar.startOfDay(for: date))
        let isToday = calendar.isDateInToday(date)
        let colorIndex = Array(selectedDates.sorted()).firstIndex(of: calendar.startOfDay(for: date))
        
        return Button(action: {
            toggleDate(date)
        }) {
            VStack(spacing: 2) {
                Text(dayName(date))
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(isSelected ? .white : Color(hex: "9CA3AF"))
                
                Text(dayNumber(date))
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(isSelected ? .white : Color(hex: "1F2937"))
            }
            .frame(width: 44, height: 52)
            .background(
                Group {
                    if isSelected, let idx = colorIndex {
                        comparisonColors[idx]
                    } else if isToday {
                        Color(hex: "FFF4EE")
                    } else {
                        Color(hex: "F9FAFB")
                    }
                }
            )
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isToday && !isSelected ? Color(hex: "FF6B35").opacity(0.3) : Color.clear, lineWidth: 1)
            )
        }
    }
    
    private func toggleDate(_ date: Date) {
        let calendar = Calendar.current
        let normalizedDate = calendar.startOfDay(for: date)
        
        if selectedDates.contains(normalizedDate) {
            selectedDates.remove(normalizedDate)
        } else if selectedDates.count < 3 {
            selectedDates.insert(normalizedDate)
        }
        updateComparisonData()
    }
    
    private func updateComparisonData() {
        let sortedDates = selectedDates.sorted()
        comparisonData = sortedDates.enumerated().map { index, date in
            let data = SunCalculator.calculateDayData(for: date, latitude: selectedRegion.latitude)
            return (date: date, data: data, color: comparisonColors[index])
        }
    }
    
    private var chartSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Sun Angle Comparison")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(Color(hex: "1F2937"))
            
            if let firstData = comparisonData.first {
                SunAngleChart(
                    dayData: firstData.data,
                    comparisonData: comparisonData.count > 1 ? Array(comparisonData.dropFirst()) : nil
                )
            }
        }
    }
    
    private var legendSection: some View {
        HStack(spacing: 16) {
            ForEach(comparisonData.indices, id: \.self) { index in
                HStack(spacing: 6) {
                    Circle()
                        .fill(comparisonData[index].color)
                        .frame(width: 10, height: 10)
                    
                    Text(shortDate(comparisonData[index].date))
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "6B7280"))
                }
            }
        }
        .padding(.horizontal, 16)
    }
    
    private var statsComparisonSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Statistics")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(Color(hex: "1F2937"))
            
            ForEach(comparisonData.indices, id: \.self) { index in
                let item = comparisonData[index]
                HStack {
                    Circle()
                        .fill(item.color)
                        .frame(width: 8, height: 8)
                    
                    Text(shortDate(item.date))
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(Color(hex: "1F2937"))
                        .frame(width: 60, alignment: .leading)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("Max: \(Int(item.data.maxAngle))°")
                            .font(.system(size: 12))
                            .foregroundColor(Color(hex: "6B7280"))
                        
                        Text("\(formatTime(item.data.sunrise)) - \(formatTime(item.data.sunset))")
                            .font(.system(size: 11))
                            .foregroundColor(Color(hex: "9CA3AF"))
                    }
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(Color(hex: "F9FAFB"))
                .cornerRadius(8)
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
    }
    
    private func dayName(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }
    
    private func dayNumber(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    private func shortDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}
