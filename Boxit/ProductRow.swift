import UIKit

class ProductRow: UITableViewCell {

    public static let Identifier = "ProductRowID"
    
    @IBOutlet weak var panelView: UIView!
    @IBOutlet weak var productPicture: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productReason: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var getOnAmazon: RxButton!
    @IBOutlet weak var getOnAmazonLabel: UILabel!
    @IBOutlet weak var saveToFavourites: RxButton!
    @IBOutlet weak var buttonHolder: UIView!
    @IBOutlet weak var getOnAmazon2: RxButton!
    
    var viewModel: Product! {
        didSet {
            productName.text = viewModel.title
            
            let del = UIApplication.shared.delegate as! AppDelegate
            let store = del.store!
            let isSelf = store.current.selectedUserState.isSelf
            
            productReason.text = String(format: isSelf ?
                viewModel.isOwn ? "Product Reason - Sure - You".localized : "Product Reason - Maybe - You".localized :
                viewModel.isOwn ? "Product Reason - Sure - Friend".localized : "Product Reason - Maybe - Friend".localized,
                                            viewModel.category.capitalized)
            
            productPrice.text = viewModel.price
            getOnAmazonLabel.text = "Buy Amazon".localized
            productPicture.kf.setImage(with: viewModel.largeIconUrl, placeholder: UIImage(named: "no_ama_pic"))
            saveToFavourites.isHidden = !isSelf
            saveToFavourites.setImage(viewModel.isFavourite ? UIImage(named: "like") : UIImage(named: "nolike"), for: .normal)
            buttonHolder.layer.borderWidth = 1
            buttonHolder.layer.borderColor = UIColor(rgb: 0xe6e7dc).cgColor
            panelView.layer.cornerRadius = 5
            panelView.layer.shadowColor = UIColor.black.cgColor
            panelView.layer.shadowRadius = 4
            panelView.layer.shadowOpacity = 0.15
            panelView.layer.shadowOffset = CGSize.zero
            
            saveToFavourites.onAction {
                let asin = self.viewModel.asin
                let ownId = store.current.loginState.ownId
                if let ownId = ownId {
                    let event = self.viewModel.isFavourite ?
                        Event.delete(favouriteProduct: asin, forUserId: ownId) :
                        Event.save(favouriteProduct: asin, forUserId: ownId)
                    store.dispatch(event)
                }
            }
            
            getOnAmazon.onAction {
                store.dispatch(Event.openAmazonUrlAsSideEffect(forProduct: self.viewModel))
            }
            
            getOnAmazon2.onAction {
                store.dispatch(Event.openAmazonUrlAsSideEffect(forProduct: self.viewModel))
            }
        }
    }
}
