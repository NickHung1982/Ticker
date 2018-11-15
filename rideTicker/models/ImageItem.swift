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
    
    var itemName: String? //nickname for image, changable
    var itemImageData: Data? //photo data
    var itemIdentifier: riderCompany //for address belong which company
    
    func saveItem() {
        //all image file name must start with ImgItem_
        DataManager.save(self, with: "ImgItem_\(itemIdentifier.rawValue)")
    }
    
    func deleteItem() {
        DataManager.delete(itemIdentifier.rawValue)
    }
    
}
