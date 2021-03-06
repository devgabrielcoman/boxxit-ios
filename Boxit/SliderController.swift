//
//  SliderController.swift
//  Boxit
//
//  Created by Gabriel Coman on 09/06/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit
import TTRangeSlider
import RxSwift

class SliderController: BaseController {

    @IBOutlet weak var slider: TTRangeSlider!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    
    fileprivate var service = PublishSubject<(min: Int, max: Int)>()
    
    var didSlideCallback: ((Int, Int) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        service.asObservable()
            .debounce(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged { (lhs: (min: Int, max: Int), rhs: (min: Int, max: Int)) -> Bool in
                return lhs.min == rhs.min && lhs.max == rhs.max
            }
            .flatMapLatest { (latest: (min: Int, max: Int)) -> Observable<(min: Int, max: Int)> in
                return Observable.just(latest)
            }
            .subscribe(onNext: { (val: (min: Int, max: Int)) in
                self.didSlideCallback?(val.min, val.max)
            })
            .addDisposableTo(disposeBag)
    }
}

extension SliderController: TTRangeSliderDelegate {
    
    func rangeSlider(_ sender: TTRangeSlider!, didChangeSelectedMinimumValue selectedMinimum: Float, andMaximumValue selectedMaximum: Float) {
        let min = Int(selectedMinimum)
        let max = Int(selectedMaximum)
        minLabel.text = "£\(min)"
        maxLabel.text = "£\(max)"
        service.onNext((min, max))
    }
}
