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
        
        // Always start with Step 1
        let step1VC = Step1ViewController()
        let navigationController = UINavigationController(rootViewController: step1VC)
        navigationController.navigationBar.isHidden = true
        
        // Clear any existing view controllers to ensure fresh navigation stack
        navigationController.setViewControllers([step1VC], animated: false)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        print("✅ AppDelegate: Window configured with Step1ViewController as root")
        print("📊 Navigation stack initialized with 1 view controller")
        
        return true
    }
}

