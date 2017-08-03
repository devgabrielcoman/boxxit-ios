import UIKit
import RxSwift

class RxButton: UIButton {
    private var action: (() -> Void)?
    
    func onAction (_ action: @escaping () -> Void) {
        self.action = action
        self.addTarget(self, action: #selector (customAction), for: .touchUpInside)
    }
    
    @objc private func customAction () {
        action?()
    }
}
