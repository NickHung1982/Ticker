//
//  settingVC.swift
//  rideTicker
//
//  Created by Nick on 9/6/18.
//  Copyright © 2018 NickOwn. All rights reserved.
//

import UIKit
import Eureka

class settingVC: FormViewController {
    var imgList = [ImageItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initForm()
        
        
        self.loadData()
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func loadData(){
        imgList = DataManager.loadImageData()
        if imgList.count > 0 {
            for imgItem in imgList {
                guard let imgdata = imgItem.itemImageData else {
                    break
                }
                
                    if imgItem.itemIdentifier == .UBER {
                        self.form.setValues(["item1Name":imgItem.itemName,"image1":UIImage(data: imgdata)])
                    }
                    if imgItem.itemIdentifier == .Lyft {
                        self.form.setValues(["item2Name":imgItem.itemName,"image2":UIImage(data: imgdata)])
                    }
                
                
            }

        }
    }
    
    func initForm(){
        form +++
        Section("Item 1")
        <<< TextRow() {
            $0.title = "Name:"
            $0.tag = "item1Name"
            $0.add(rule: RuleRequired())
            $0.add(rule: RuleMaxLength(maxLength: 10))
            $0.validationOptions = .validatesOnChange
            }.cellUpdate { cell, row in
                if !row.isValid {
                    guard let limitStr = row.value else { return }
                    let indexEndIdx = limitStr.index(limitStr.startIndex, offsetBy: 10)
                    let substr = limitStr[..<indexEndIdx]
                    row.value = String(substr)
                    cell.titleLabel?.textColor = .red
                }
                var tmpItem = self.imgList.filter({ $0.itemIdentifier == riderCompany.UBER }).first
                tmpItem?.itemName = row.value
                tmpItem?.saveItem()
            }
            <<< ImageRow() {
                $0.title = "image1"
                $0.tag = $0.title
                }.cellUpdate{ cell, row in
                    
                    if let rowImage = row.value {
                        
                        var tmpItem = self.imgList.filter({ $0.itemIdentifier == riderCompany.UBER }).first
                        var newRowImage = rowImage
                        //resize photo
                        if rowImage.size.width > 400 {
                            newRowImage = rowImage.resized(to: CGSize(width: 400, height: 400))
                        }
                        
                        tmpItem?.itemImageData = UIImagePNGRepresentation(newRowImage)
                        tmpItem?.saveItem()
                    }
                }
        +++ Section("Item 2")
            <<< TextRow() {
                $0.title = "Name:"
                $0.tag = "item2Name"
                $0.add(rule: RuleRequired())
                $0.add(rule: RuleMaxLength(maxLength: 10))
                $0.validationOptions = .validatesOnChange
                }.cellUpdate { cell, row in
                    if !row.isValid {
                        guard let limitStr = row.value else { return }
                        let indexEndIdx = limitStr.index(limitStr.startIndex, offsetBy: 10)
                        let substr = limitStr[..<indexEndIdx]
                        row.value = String(substr)
                        cell.titleLabel?.textColor = .red
                    }
                    var tmpItem = self.imgList.filter({ $0.itemIdentifier == riderCompany.Lyft }).first
                    tmpItem?.itemName = row.value
                    tmpItem?.saveItem()
                }
            <<< ImageRow() {
                $0.title = "image2"
                $0.tag = $0.title
                }.cellUpdate{ cell, row in
                    if let rowImage = row.value {
                        
                        var tmpItem = self.imgList.filter({ $0.itemIdentifier == riderCompany.Lyft }).first
                        var newRowImage = rowImage
                        //resize photo
                        if rowImage.size.width > 400 {
                            newRowImage = rowImage.resized(to: CGSize(width: 400, height: 400))
                        }
                        tmpItem?.itemImageData = UIImagePNGRepresentation(newRowImage)
                        tmpItem?.saveItem()
                    }
                }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
   
}
//resize image if too big
extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
