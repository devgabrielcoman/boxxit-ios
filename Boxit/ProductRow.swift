import UIKit

class ProductRow: UITableViewCell {

    public static let Identifier = "ProductRowID"
    
    @IBOutlet weak var productPicture: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productReason: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var getOnAmazon: RxButton!
    @IBOutlet weak var getOnAmazonLabel: UILabel!
    @IBOutlet weak var saveToFavourites: RxButton!
    @IBOutlet weak var buttonHolder: UIView!
}
