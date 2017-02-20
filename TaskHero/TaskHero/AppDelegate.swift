import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var reachability: Reachability? = Reachability()!
    
    var window: UIWindow? = {
        let window = UIWindow(frame: UIScreen.main.bounds)
         window.rootViewController = UINavigationController(rootViewController: InitialViewController())
         //window.rootViewController = UINavigationController(rootViewController: HomeHeaderView())
        return window
    }()
    
    override init() {
        FIRApp.configure()
        FIRDatabase.database().persistenceEnabled = true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        reachabilitySetup()
        application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        let navigationBarAppearace = UINavigationBar.appearance()
        let defaults = UserDefaults.standard
        navigationBarAppearace.barTintColor = .navigationBarColor()
        navigationBarAppearace.tintColor = .white
        if defaults.bool(forKey: "hasLoggedIn") {
            window?.rootViewController = TabBarController()
        }
        window?.makeKeyAndVisible()
        return true
    }
    
    
    func reachabilitySetup() {
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged), name: ReachabilityChangedNotification, object: reachability)
        do {
            try reachability?.startNotifier()
        } catch let error as NSError {
            print("ERROR: couldn't start notifier \(error.localizedDescription)")
        }
    }
    
    func reachabilityChanged() {
        guard let reachability = reachability else { return }
        let status = InternetStatus.shared
        if reachability.isReachable {
            if reachability.isReachableViaWiFi {
                status.hasInternet = true
                print("Reachable via WiFi")
            } else {
                status.hasInternet = true
                print("Reachable via Cellular")
            }
        } else {
            status.hasInternet = false
            print("Network not reachable")
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

