import SwiftUI

struct WeekDatePicker: View {
    @Binding var selectedDate: Date
    let dateRange: Int = 7
    
    private var dates: [Date] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        var result: [Date] = []
        
        for i in -dateRange...dateRange {
            if let date = calendar.date(byAdding: .day, value: i, to: today) {
                result.append(date)
            }
        }
        return result
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Select Date")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color(hex: "6B7280"))
            
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(dates, id: \.self) { date in
                            DateCell(
                                date: date,
                                isSelected: Calendar.current.isDate(date, inSameDayAs: selectedDate),
                                isToday: Calendar.current.isDateInToday(date),
                                action: { selectedDate = date }
                            )
                            .id(date)
                        }
                    }
                    .padding(.horizontal, 4)
                }
                .onAppear {
                    proxy.scrollTo(selectedDate, anchor: .center)
                }
            }
        }
    }
}

struct DateCell: View {
    let date: Date
    let isSelected: Bool
    let isToday: Bool
    let action: () -> Void
    
    private var dayName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }
    
    private var dayNumber: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    private var monthName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter.string(from: date)
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(dayName)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(isSelected ? .white : Color(hex: "9CA3AF"))
                
                Text(dayNumber)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(isSelected ? .white : Color(hex: "1F2937"))
                
                Text(monthName)
                    .font(.system(size: 10))
                    .foregroundColor(isSelected ? .white.opacity(0.8) : Color(hex: "9CA3AF"))
            }
            .frame(width: 52, height: 72)
            .background(
                Group {
                    if isSelected {
                        LinearGradient(
                            colors: [Color(hex: "FF8C42"), Color(hex: "FF6B35")],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    } else if isToday {
                        Color(hex: "FFF4EE")
                    } else {
                        Color(hex: "F9FAFB")
                    }
                }
            )
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isToday && !isSelected ? Color(hex: "FF6B35").opacity(0.3) : Color.clear, lineWidth: 1)
            )
            .shadow(color: isSelected ? Color(hex: "FF6B35").opacity(0.3) : Color.clear, radius: 4, x: 0, y: 2)
        }
    }
}
