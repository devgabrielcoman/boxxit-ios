import UIKit

class FavouriteRow: UITableViewCell {

    public static let Identifier = "FavouriteRowId"
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomContraint: NSLayoutConstraint!
    @IBOutlet weak var panelView: UIView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var amazonButton: RxButton!
    @IBOutlet weak var removeButton: RxButton!
    
    var viewModel: Product! {
        didSet {
            
            let del = UIApplication.shared.delegate as! AppDelegate
            let store = del.store!
            let isSelf = store.current.selectedUserState.isSelf
            
            title.text = viewModel.title
            price.text = viewModel.price
            icon.kf.setImage(with: viewModel.largeIconUrl, placeholder: UIImage(named: "no_ama_pic"))
            panelView.layer.cornerRadius = 5
            panelView.layer.shadowColor = UIColor.black.cgColor
            panelView.layer.shadowRadius = 4
            panelView.layer.shadowOpacity = 0.15
            panelView.layer.shadowOffset = CGSize.zero
            amazonButton.layer.cornerRadius = 14
            amazonButton.layer.borderWidth = 1
            amazonButton.layer.borderColor = UIColor(rgb: 0xe6e7dc).cgColor
//            topConstraint.constant = index.row == 0 ? 16 : 8
//            bottomContraint.constant = index.row == total - 1 ? 16 : 8
            removeButton.isHidden = !isSelf

        }
    }
}
