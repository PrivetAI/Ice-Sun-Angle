import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .home
    @State private var selectedDate: Date = Date()
    @State private var selectedRegion: Region = .center
    
    init() {
        // Load saved region
        if let savedRegion = UserDefaults.standard.string(forKey: "selectedRegion"),
           let region = Region(rawValue: savedRegion) {
            _selectedRegion = State(initialValue: region)
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Main content
            VStack(spacing: 0) {
                tabContent
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            // Custom tab bar
            CustomTabBar(selectedTab: $selectedTab)
        }
        .ignoresSafeArea(.keyboard)
        .onChange(of: selectedRegion) { newValue in
            UserDefaults.standard.set(newValue.rawValue, forKey: "selectedRegion")
        }
    }
    
    @ViewBuilder
    private var tabContent: some View {
        switch selectedTab {
        case .home:
            MainView(
                selectedDate: $selectedDate,
                selectedRegion: $selectedRegion,
                selectedTab: $selectedTab
            )
        case .graph:
            SunGraphView(
                selectedDate: selectedDate,
                selectedRegion: selectedRegion
            )
        case .recommendations:
            RecommendationsView(
                selectedDate: selectedDate,
                selectedRegion: selectedRegion,
                selectedTab: $selectedTab
            )
        case .compare:
            CompareView(
                baseDate: selectedDate,
                selectedRegion: selectedRegion
            )
        case .help:
            HelpView()
        }
    }
}
