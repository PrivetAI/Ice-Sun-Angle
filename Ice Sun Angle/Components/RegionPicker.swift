import SwiftUI

struct RegionPicker: View {
    @Binding var selectedRegion: Region
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Select Region")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color(hex: "6B7280"))
            
            HStack(spacing: 0) {
                ForEach(Region.allCases) { region in
                    RegionTab(
                        region: region,
                        isSelected: selectedRegion == region,
                        action: { selectedRegion = region }
                    )
                }
            }
            .background(Color(hex: "F3F4F6"))
            .cornerRadius(12)
        }
    }
}

struct RegionTab: View {
    let region: Region
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(region.rawValue)
                    .font(.system(size: 15, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(isSelected ? Color(hex: "FF6B35") : Color(hex: "6B7280"))
                
                Text("\(Int(region.latitude))°N")
                    .font(.system(size: 11))
                    .foregroundColor(isSelected ? Color(hex: "FF8C42") : Color(hex: "9CA3AF"))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(isSelected ? Color.white : Color.clear)
            .cornerRadius(10)
            .shadow(color: isSelected ? Color.black.opacity(0.05) : Color.clear, radius: 4, x: 0, y: 2)
        }
        .padding(2)
    }
}
