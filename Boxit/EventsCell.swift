import UIKit

class EventsCell: UICollectionViewCell {
    
    public static let Identifier = "EventsCellId"
    
    @IBOutlet weak var profilePanel: UIView!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileBirthday: UILabel!
    
    var viewModel: ViewModels.User! {
        didSet {
            profilePanel.layer.cornerRadius = 10
            profilePanel.layer.shadowColor = UIColor.black.cgColor
            profilePanel.layer.shadowRadius = 4
            profilePanel.layer.shadowOpacity = 0.15
            profilePanel.layer.shadowOffset = CGSize.zero
            profilePanel.layer.masksToBounds = false
            
            profilePicture.kf.setImage(with: viewModel.profile.pictureUrl)
            profilePicture.kf.indicatorType = .activity
            profileName.text = viewModel.profile.name
            profileBirthday.text = viewModel.birthdayShort
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let path = UIBezierPath(roundedRect: profilePicture.bounds,
                                byRoundingCorners:[.topRight, .topLeft],
                                cornerRadii: CGSize(width: 10, height:  10))
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        profilePicture.layer.mask = maskLayer
    }
    
}
