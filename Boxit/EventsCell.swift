import UIKit

class EventsCell: UICollectionViewCell {
    
    public static let Identifier = "EventsCellId"
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileBirthday: UILabel!
    @IBOutlet weak var rightSeparator: UIView!
    
}
