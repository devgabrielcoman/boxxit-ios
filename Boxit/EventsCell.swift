import UIKit

class EventsCell: UICollectionViewCell {
    
    public static let Identifier = "EventsCellId"
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileBirthday: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let path = UIBezierPath(roundedRect: profilePicture.bounds,
                                byRoundingCorners:[.topRight, .topLeft],
                                cornerRadii: CGSize(width: 15, height:  15))
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        profilePicture.layer.mask = maskLayer
    }
    
}
