import UIKit
import RxCocoa
import RxSwift

enum AppSegues: String {
    // navigation segues
    case IntroToLogin = "IntroToLogin"
    case IntroToLoad = "IntroToLoad"
    case LoadToMain = "LoadToMain"
    case LoginToMain = "LoginToMain"
    case Next1ToMain = "Next1ToMain"
    case Next2ToMain = "Next2ToMain"
    case ProfileMainToUser = "ProfileMainToUser"
    case EventsToUser = "EventsToUser"
    case UserToFavourite = "UserToFavourite"
    case MainHeaderToUser = "MainHeaderToUser"
    
    // embed segues
    case MainEmbedsProfileMain = "MainEmbedsProfileMain"
    case MainEmbedsEvents = "MainEmbedsEvents"
    case UserEmbedsProfileHeader = "UserEmbedsProfileHeader"
    case UserEmbedsExplore = "UserEmbedsExplore"
    case ExploreEmbedsSlider = "ExploreEmbedsSlider"
    case ExploreEmbedsError = "ExploreEmbedsError"
    case EventsEmbedsError = "EventsEmbedsError"
    case FavouritesEmbedsError = "FavouritesEmbedsError"
    
    // popup
    case NotificationsToSetup = "NotificationsToSetup"
}

class BaseController: UIViewController {

    let disposeBag = DisposeBag ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func performSegue (_ identifier: AppSegues) {
        self.performSegue(withIdentifier: identifier.rawValue, sender: self)
    }
}

extension BaseController {
    
    func getChild <T: UIViewController> () -> T? {
        
        var childVC: T?
        
        self.childViewControllers.forEach { child in
            if let child = child as? T {
                childVC = child
            }
        }
        
        return childVC
    }
}
