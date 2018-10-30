//
//  ImageItem.swift
//  rideTicker
//
//  Created by Nick on 9/13/18.
//  Copyright © 2018 NickOwn. All rights reserved.
//


import CloudKit
import UIKit

struct ImageItem: Codable{
    var itemName: String? //name可以變
    var itemImageData: Data? //照片
    var itemIdentifier: riderCompany
    
    func saveItem() {
        DataManager.save(self, with: "ImgItem_\(itemIdentifier.rawValue)")
    }
    
    func deleteItem() {
        DataManager.delete(itemIdentifier.rawValue)
    }
    
}
