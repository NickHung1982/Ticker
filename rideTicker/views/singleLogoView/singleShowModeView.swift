//
//  singleShowModeView.swift
//  rideTicker
//
//  Created by Nick on 10/31/18.
//  Copyright © 2018 NickOwn. All rights reserved.
//

import UIKit

@objc protocol singleShowModeDelegate: AnyObject {
    func singleShowButtonClick(_ segmentIndex:Int)
}
class singleShowModeView: UIView {
    let kVIEW_XIB_FILENAME = "singleShowModeView"
    @IBOutlet weak var logoSelectSegment: UISegmentedControl!
    @IBOutlet weak var showlogoOnlyButton: UIButton!
    @IBOutlet weak var delegate: singleShowModeDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    //load xib file and setup segment texts
    private func setupUI(){
        let view = Bundle.main.loadNibNamed(kVIEW_XIB_FILENAME, owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
        setupSegmentItemName()
    }
    
    private func setupSegmentItemName() {
        let imageList = DataManager.loadImageData()
            for item in imageList {
                if item.itemIdentifier == .UBER {
                        self.logoSelectSegment.setTitle(item.itemName, forSegmentAt: 0)
                }else if item.itemIdentifier == .Lyft {
                        self.logoSelectSegment.setTitle(item.itemName, forSegmentAt: 1)
                }
            }
    }
    
    
    @IBAction func clickShowButton(_ sender: Any) {
        delegate?.singleShowButtonClick(self.logoSelectSegment.selectedSegmentIndex)
    }
    
    @IBAction func logoSelectChange(_ sender: UISegmentedControl) {
        print("segment change")
    }
    
    
    
}

//extension UIView
//{
//    func fixInView(_ container: UIView!) -> Void{
//        self.translatesAutoresizingMaskIntoConstraints = false;
//        self.frame = container.frame;
//        container.addSubview(self);
//        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
//        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
//        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
//        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
//    }
//}
