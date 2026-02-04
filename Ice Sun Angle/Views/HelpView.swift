import SwiftUI

struct HelpView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                headerSection
                
                // Why this matters
                sectionCard(
                    icon: CustomIcon.sunHigh,
                    iconColor: Color(hex: "EF4444"),
                    title: "Why Sun Angle Matters",
                    content: "When the sun is high in the sky, sunlight penetrates directly through the fishing hole in the ice. This creates a spotlight effect where fish can clearly see movement, shadows, and your presence above. Fish become cautious and less likely to bite."
                )
                
                // Shadow explanation
                sectionCard(
                    icon: CustomIcon.fish,
                    iconColor: Color(hex: "3B82F6"),
                    title: "Fish See Your Shadow",
                    content: "When the sun is overhead, your shadow falls directly into the fishing hole. Fish are naturally wary of shadows from above - in nature, this often means a predator like a bird. Even small movements cast visible shadows that spook the fish."
                )
                
                // Best times
                sectionCard(
                    icon: CustomIcon.sunLow,
                    iconColor: Color(hex: "22C55E"),
                    title: "Best Fishing Times",
                    content: "Early morning and late afternoon are ideal when the sun is low on the horizon. The light comes at an angle and doesn't penetrate the hole directly. Your shadow falls away from the hole, and fish feel safer to approach the bait."
                )
                
                // Zone explanation
                zoneExplanation
                
                // Cloudy weather
                sectionCard(
                    icon: CustomIcon.compare,
                    iconColor: Color(hex: "6B7280"),
                    title: "Cloudy Weather Exception",
                    content: "On overcast days, the sun angle chart is less critical. Clouds diffuse the sunlight, eliminating harsh shadows and direct light penetration. You can fish effectively throughout the day in cloudy conditions."
                )
                
                // Exceptions
                sectionCard(
                    icon: CustomIcon.info,
                    iconColor: Color(hex: "8B5CF6"),
                    title: "Species Exceptions",
                    content: "Some fish species are actually more active during midday hours. Perch and some other species may feed aggressively when the sun is high. Observe local patterns and adjust your strategy based on your target species."
                )
                
                // Tips
                tipsSection
                
                Spacer(minLength: 100)
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
        }
        .background(Color(hex: "FAFAFA"))
    }
    
    private var headerSection: some View {
        VStack(spacing: 4) {
            Text("How It Works")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Color(hex: "1F2937"))
            
            Text("Understanding sun angle for better ice fishing")
                .font(.system(size: 14))
                .foregroundColor(Color(hex: "6B7280"))
        }
    }
    
    private func sectionCard(icon: some View, iconColor: Color, title: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.15))
                        .frame(width: 36, height: 36)
                    
                    icon
                        .frame(width: 20, height: 20)
                        .foregroundColor(iconColor)
                }
                
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color(hex: "1F2937"))
            }
            
            Text(content)
                .font(.system(size: 14))
                .foregroundColor(Color(hex: "6B7280"))
                .lineSpacing(5)
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
    }
    
    private var zoneExplanation: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Understanding the Zones")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(Color(hex: "1F2937"))
            
            zoneRow(
                color: Color(hex: "22C55E"),
                title: "Green Zone (Under 20°)",
                description: "Excellent conditions. Sun is low, minimal shadow."
            )
            
            zoneRow(
                color: Color(hex: "EAB308"),
                title: "Yellow Zone (20° - 45°)",
                description: "Acceptable conditions. Some light enters the hole."
            )
            
            zoneRow(
                color: Color(hex: "EF4444"),
                title: "Red Zone (Over 45°)",
                description: "Poor conditions. Direct light and visible shadows."
            )
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
    }
    
    private func zoneRow(color: Color, title: String, description: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)
                .padding(.top, 4)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(hex: "1F2937"))
                
                Text(description)
                    .font(.system(size: 13))
                    .foregroundColor(Color(hex: "6B7280"))
            }
        }
    }
    
    private var tipsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(Color(hex: "FF6B35").opacity(0.15))
                        .frame(width: 36, height: 36)
                    
                    CustomIcon.calendar
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color(hex: "FF6B35"))
                }
                
                Text("Planning Tips")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color(hex: "1F2937"))
            }
            
            VStack(alignment: .leading, spacing: 8) {
                tipRow("Check the graph before heading out")
                tipRow("Plan to arrive during green zone times")
                tipRow("Use Compare view to plan trips ahead")
                tipRow("As winter deepens, sun stays lower longer")
                tipRow("Spring brings higher sun - start earlier")
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
    }
    
    private func tipRow(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            CustomIcon.chevronRight
                .frame(width: 12, height: 12)
                .foregroundColor(Color(hex: "FF6B35"))
                .padding(.top, 3)
            
            Text(text)
                .font(.system(size: 14))
                .foregroundColor(Color(hex: "6B7280"))
        }
    }
}
