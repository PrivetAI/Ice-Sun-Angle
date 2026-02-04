import SwiftUI

struct MainView: View {
    @Binding var selectedDate: Date
    @Binding var selectedRegion: Region
    @Binding var selectedTab: Tab
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                headerSection
                
                // Date picker
                WeekDatePicker(selectedDate: $selectedDate)
                
                // Region picker
                RegionPicker(selectedRegion: $selectedRegion)
                
                // Info card
                infoCard
                
                // Action button
                PrimaryButton(title: "Show Sun Graph") {
                    selectedTab = .graph
                }
                .padding(.top, 8)
                
                Spacer(minLength: 100)
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
        }
        .background(Color(hex: "FAFAFA"))
    }
    
    private var headerSection: some View {
        VStack(spacing: 8) {
            HStack {
                CustomIcon.sunMedium
                    .frame(width: 32, height: 32)
                    .foregroundColor(Color(hex: "FF6B35"))
                
                Text("Ice Sun Angle")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(hex: "1F2937"))
            }
            
            Text("Find the best fishing times based on sun position")
                .font(.system(size: 14))
                .foregroundColor(Color(hex: "6B7280"))
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 8)
    }
    
    private var infoCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                CustomIcon.fish
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color(hex: "3B82F6"))
                
                Text("Why Sun Angle Matters")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(Color(hex: "1F2937"))
            }
            
            Text("When the sun is high, light shines directly into the fishing hole. Fish can see your shadow and movement, making them cautious. Low sun angles create better conditions for ice fishing.")
                .font(.system(size: 13))
                .foregroundColor(Color(hex: "6B7280"))
                .lineSpacing(4)
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
    }
}
