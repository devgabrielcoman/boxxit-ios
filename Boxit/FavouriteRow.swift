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
}
