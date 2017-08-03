import UIKit

class FavouriteRow: UITableViewCell {

    public static let Identifier = "FavouriteRowId"
    
    @IBOutlet weak var separator: UIView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
}
