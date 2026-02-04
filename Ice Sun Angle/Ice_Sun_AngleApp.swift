import SwiftUI

@main
struct Ice_Sun_AngleApp: App {
    init() {
        // Force light mode
        if #available(iOS 15.0, *) {
            // Set appearance for all windows
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light)
        }
    }
}
