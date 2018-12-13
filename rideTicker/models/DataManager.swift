//
//  DataManager.swift
//  Todo
//
//  Created by Brian Advent on 08.12.17.
//  Copyright © 2017 Brian Advent. All rights reserved.
//

import Foundation
import UIKit

public class DataManager {
    static fileprivate func getDocumentDirectory () -> URL {
        if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            return url
        }else{
            fatalError("Unable to get document directory")
        }
    }
    
    static func save <T:Encodable> (_ object:T, with fileName:String) {
        let url = getDocumentDirectory().appendingPathComponent(fileName, isDirectory: false)
        
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            if FileManager.default.fileExists(atPath: url.path) {
                try FileManager.default.removeItem(at: url)
            }
            FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
        }catch{
            fatalError(error.localizedDescription)
        }
    }
    
    
    static func load <T:Decodable> (_ fileName:String, with type:T.Type) -> T {
        let url = getDocumentDirectory().appendingPathComponent(fileName, isDirectory: false)
        if !FileManager.default.fileExists(atPath: url.path) {
            fatalError("File not found at path \(url.path)")
        }
        
        if let data = FileManager.default.contents(atPath: url.path) {
            do {
                let model = try JSONDecoder().decode(type, from: data)
                return model
            }catch{
                fatalError(error.localizedDescription)
            }
        }else{
            fatalError("Data unavailable at path \(url.path)")
        }
    }
    
    static func loadData (_ fileName:String) -> Data? {
        let url = getDocumentDirectory().appendingPathComponent(fileName, isDirectory: false)
        if !FileManager.default.fileExists(atPath: url.path) {
            fatalError("File not found at path \(url.path)")
        }
        
        if let data = FileManager.default.contents(atPath: url.path) {
            return data
        }else{
            fatalError("Data unavailable at path \(url.path)")
        }
    }
    
    static func loadAll <T:Decodable> (_ type:T.Type) -> [T] {
        
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: getDocumentDirectory().path)
            
            var modelObjects = [T]()
            for fileName in files {
                if type is ImageItem.Type {
                    //check file name must have ImgItem_
                    if fileName.range(of: "ImgItem_") != nil {
                        modelObjects.append(load(fileName, with: type))
                    }
                }else{
                    //message type
                    if fileName.range(of: "ImgItem_") == nil {
                        modelObjects.append(load(fileName, with: type))
                    }
                }
                
            }
            return modelObjects
            
        }catch{
            fatalError("could not load any files")
        }
        
    }
    
    static func delete (_ fileName:String) {
        let url = getDocumentDirectory().appendingPathComponent(fileName, isDirectory: false)
        if FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.removeItem(at: url)
            }catch{
                fatalError(error.localizedDescription)
            }
        }
    }
    
    static func loadImageData() -> [ImageItem] {
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: getDocumentDirectory().path)
            
            var modelObjects = [ImageItem]()
            
            for fileName in files {
                if fileName.range(of: "ImgItem_") != nil {
                    modelObjects.append(load(fileName, with: ImageItem.self))
                }
                
            }
            //use default value if no image found
            if modelObjects.count == 0 {
                let itemUber = ImageItem.init(itemName: "Uber", itemImageData: #imageLiteral(resourceName: "Uber512.png").pngData(), itemIdentifier: .UBER)
                itemUber.saveItem()
                let itemLyft = ImageItem.init(itemName: "Lyft", itemImageData: #imageLiteral(resourceName: "car.png").pngData(), itemIdentifier: .Lyft)
                itemLyft.saveItem()
                
                modelObjects.append(itemUber)
                modelObjects.append(itemLyft)
            }
            
            return modelObjects
            
        }catch{
            fatalError("could not load any files")
        }
    }
    
    static func loadImageFromRiderCompany(_ riderCompany:riderCompany) -> Data? {
        let imglist = loadImageData()
        return imglist.filter({ $0.itemIdentifier == riderCompany }).first?.itemImageData!
    }
}
