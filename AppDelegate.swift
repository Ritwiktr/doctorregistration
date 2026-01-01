import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        print("🚀 AppDelegate: Application didFinishLaunchingWithOptions")
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // Reset registration data to ensure fresh start
        RegistrationData.shared.reset()
        print("🔄 RegistrationData reset")
        
        // Load from storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateInitialViewController()
        
        window?.rootViewController = initialViewController
        window?.makeKeyAndVisible()
        
        print("✅ AppDelegate: Window configured from Main.storyboard")
        
        return true
    }
}

