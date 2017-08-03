import UIKit
import Fabric
import Crashlytics
import FBSDKCoreKit
import Firebase
import UserNotifications
import PermissionScope
import RxSwift

protocol EnableNotificationResponder {
    func didTapOnNotificationAlert ()
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    var delegate: EnableNotificationResponder?
    var timer = Timer()
    let bag = DisposeBag()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        Fabric.with([Crashlytics.self])
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        FirebaseApp.configure()
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
        }
    
        // For iOS 10 data message (sent via FCM)
        Messaging.messaging().delegate = self
        Messaging.messaging().shouldEstablishDirectChannel = false
        
        // always register for remote notifications here
        application.registerForRemoteNotifications()
        
        print("Starting countdown ...")
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateNotificationTokenForCurrentUser), userInfo: nil, repeats: true)
        
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
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
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        // Called when the user presses yes or no on allowing notifications
        
        // send delegate back
        delegate?.didTapOnNotificationAlert()
    }
    
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the InstanceID token.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
        
        // set APNS token
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    // [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        //
        // handle notif
        handleBirthdayNotification(withUserInfo: userInfo)
        
        //
        // call completion handler
        completionHandler(UIBackgroundFetchResult.newData)
    }
    // [END receive_message]
}

// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Change this to your preferred presentation option
        completionHandler([])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        
        //
        // handle notif
        handleBirthdayNotification(withUserInfo: userInfo)
        
        //
        // completion handler
        completionHandler()
    }
}
// [END ios_10_message_handling]

// [START ios_10_data_message_handling]
extension AppDelegate : MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("New FCM tokens is \(fcmToken)")
    }
    
    // Receive data message on iOS 10 devices while app is in the foreground.
    func application(received remoteMessage: MessagingRemoteMessage) {
        // do nothing
    }
    
}
// [END ios_10_data_message_handling]

// [START auth app delegate functions]
extension AppDelegate {
    
    //
    // send an update to the DB regarding the current APNS token for this user
    func updateNotificationTokenForCurrentUser () {
        
        let token = InstanceID.instanceID().token()
        let user = DataStore.shared.get(userForId: "me")
        
        if let user = user, let token = token {
            
            UserWorker.update(notificationToken: token, forUserId: user.id)
            .subscribe(onSuccess: {
                
                //
                // invalidate timer
                self.timer.invalidate()
                
            }, onError: { error in
                //
                // could not send 
                print("Count not send token \(token)")
            })
            .addDisposableTo(bag)
            
        } else {
            print("Trying to send new token to user ...")
        }
    }
    
    //
    // handles a notification
    func handleBirthdayNotification(withUserInfo userInfo: [AnyHashable: Any]) {
        
        //
        // handle notifications
        if let friendId = userInfo["friendId"] as? String,
            let window = window,
            let root = window.rootViewController as? UINavigationController {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mvc = storyboard.instantiateViewController(withIdentifier: "UserControllerID") as! UserController
            mvc.facebookUser = friendId
            root.pushViewController(mvc, animated: true)
        }
        
    }
}
// [END timer that sends data]
