//
//  MessageItem.swift
//  rideTicker
//
//  Created by Nick on 8/24/18.
//  Copyright © 2018 NickOwn. All rights reserved.
//

import CloudKit

enum riderCompany:String,Codable {
    case UBER
    case Lyft
    case Both
}
enum backGroundType:String,Codable {
    case whiteday
    case night
    case auto
}

struct MessageItem: Codable {
    var Msg:String
    var Msg2:String?
    var riderCompy:riderCompany
    var backGroundType:backGroundType
    var createdAt:Date
    
    var itemIdentifier:UUID
    var completed:Bool //false: only shows logo
    var logoImageData:Data? //first image
    var logoImageData2:Data? //second image
    func saveItem() {
        DataManager.save(self, with: "\(itemIdentifier.uuidString)")
    }
    
    func deleteItem() {
        DataManager.delete(itemIdentifier.uuidString)
    }
    
    mutating func markAsCompleted(){
        self.completed = true
        DataManager.save(self, with: "\(itemIdentifier.uuidString)")
    }
    
    init(Msg:String, riderCompy:riderCompany, bgType:backGroundType, iid:UUID, createdAt: Date, completed:Bool) {
        self.Msg = Msg
        self.riderCompy = riderCompy
        self.backGroundType = bgType
        self.itemIdentifier = iid
        self.completed = completed
        self.createdAt = createdAt
    }
    
    init(withPhoto Msg:String, riderCompy:riderCompany, bgType:backGroundType, iid:UUID, createdAt: Date, completed:Bool, logoImageData:Data){
        self.Msg = Msg
        self.riderCompy = riderCompy
        self.backGroundType = bgType
        self.itemIdentifier = iid
        self.completed = completed
        self.createdAt = createdAt
        
        self.logoImageData = logoImageData
    }
    
    init(onlyTwoPhotos iid:UUID, logoImageData:Data, logoImageData2:Data) {
        self.Msg = ""
        self.riderCompy = .Both
        self.backGroundType = .auto
        self.itemIdentifier = iid
        self.completed = false
        self.createdAt = Date()
        
        self.logoImageData = logoImageData
        self.logoImageData2 = logoImageData2
    }
}
