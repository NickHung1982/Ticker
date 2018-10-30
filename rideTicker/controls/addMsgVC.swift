//
//  addMsgVC.swift
//  rideTicker
//
//  Created by Nick on 8/29/18.
//  Copyright © 2018 NickOwn. All rights reserved.
//

import UIKit
import Eureka

protocol addMsgVCDelegate {
    func fireAfterSavedItem(_ msgItem: MessageItem)
}

class addMsgVC: FormViewController {
    var msgData:MessageItem?
    var uuid:UUID!
    var delegate:addMsgVCDelegate?
    var imgList = [ImageItem]()
    override func viewDidLoad() {
        super.viewDidLoad()
        imgList = DataManager.loadImageData()
        initForm()
        
        if let haveMsgData = msgData {
            self.loadData(haveMsgData)
        }
        
    }
    func initForm(){
        form +++
            Section("Type")
            <<< SegmentedRow<String>() {
                if let firstItemName = imgList.first?.itemName, let secondItemName = imgList.last?.itemName {
                    $0.options = [firstItemName,secondItemName]
                    $0.value = firstItemName
                    $0.tag = "rideType"
                    
                }
               
            }
            +++ Section("Message - Single word")
            <<< TextRow() {
                $0.title = "Line 1"
                $0.tag = "Line 1"
                $0.placeholder = "First line message"
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
                }
            <<< TextRow() {
                $0.title = "Line 2"
                $0.tag = "Line 2"
                $0.placeholder = "Second line message"
                $0.add(rule: RuleRequired())
                $0.add(rule: RuleMaxLength(maxLength: 15))
                $0.validationOptions = .validatesOnChange
                }.cellUpdate { cell, row in
                    if !row.isValid {
                        guard let limitStr = row.value else { return }
                        
                        let indexEndIdx = limitStr.index(limitStr.startIndex, offsetBy: 15)
                        let substr = limitStr[..<indexEndIdx]
                        row.value = String(substr)
                        cell.titleLabel?.textColor = .red
                    }
                }
            
            <<< ButtonRow("Save & Show"){
                $0.tag = "SaveAndShow"
                $0.title = "Saved and Show"
                }.cellUpdate { cell, row in
                    cell.backgroundColor = UIColor.red
                    cell.textLabel?.textColor = UIColor.white
                }.onCellSelection{[weak self](cell,row) in
                    let vDict = self?.form.values(includeHidden: false)
                    guard let line1 = vDict!["Line 1"],let line2 = vDict!["Line 2"], let rideT = vDict!["rideType"] else {
                        return
                    }
                    
                    //Saved segment value
                    var selectedRider: riderCompany!
                    for item in (self?.imgList)! {
                        if rideT as? String == item.itemName {
                            selectedRider = item.itemIdentifier
                        }
                    }
                    
                    
                    var tmpMsgItem = MessageItem(Msg: line1 as! String, riderCompy: selectedRider, bgType: backGroundType.night, iid: (self?.uuid)!, createdAt: Date(), completed: true)
                    tmpMsgItem.Msg2 = line2 as? String
                    tmpMsgItem.saveItem()
                    
                    //將line1 和 riderCompany 預選起來作為下次預設值
                    
                    //退回上頁並顯示
                    self?.delegate?.fireAfterSavedItem(tmpMsgItem)
                    self?.navigationController?.popToRootViewController(animated: true)
                    
            }
            
            <<< ButtonRow("Only Save"){
                $0.tag = "SaveButNoShow"
                $0.title = "Saved and Exit"
                }.cellUpdate { cell, row in
                    cell.backgroundColor = UIColor.lightGray
                    cell.textLabel?.textColor = UIColor.black
                }.onCellSelection{[weak self](cell,row) in
                    let vDict = self?.form.values(includeHidden: false)
                    
                    guard let line1 = vDict!["Line 1"],let line2 = vDict!["Line 2"], let rideT = vDict!["rideType"] else {
                        return
                    }
                    
                    //Saved segment value
                    var selectedRider: riderCompany!
                    for item in (self?.imgList)! {
                        if rideT as? String == item.itemName {
                            selectedRider = item.itemIdentifier
                        }
                    }
                    
                    var tmpMsgItem = MessageItem(Msg: line1 as! String, riderCompy: selectedRider, bgType: backGroundType.night, iid: (self?.uuid)!, createdAt: Date(), completed: true)
                    tmpMsgItem.Msg2 = line2 as? String
                    tmpMsgItem.saveItem()
                    
                    self?.navigationController?.popToRootViewController(animated: true)
                    
            }
        
        if msgData != nil {
            form +++ Section("")
            <<< ButtonRow("DELETE"){
                    $0.tag = "DELETE"
                    $0.title = "DELETE"
                }.cellUpdate { cell, row in
                    cell.textLabel?.textColor = UIColor.red
                }.onCellSelection{[weak self](cell,row) in
                    self?.msgData?.deleteItem()
                    self?.navigationController?.popToRootViewController(animated: true)
                }
        }
    }
    func loadData(_ msgData:MessageItem){
        
        for item in imgList {
            if item.itemIdentifier == msgData.riderCompy {
                form.setValues(["Line 1":msgData.Msg,"Line 2":msgData.Msg2,"rideType":item.itemName])
            }
        }
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

