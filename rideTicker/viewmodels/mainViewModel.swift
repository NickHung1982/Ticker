//
//  mainViewModel.swift
//  rideTicker
//
//  Created by Nick on 12/15/18.
//  Copyright © 2018 Darktt. All rights reserved.
//

import Foundation
import Toast_Swift
import MultipeerConnectivity

public typealias ActionViewCompletion = (UIAlertAction) -> Void

protocol mainViewModelType {
    //var mcBroswerDelegate: MCBrowserViewControllerDelegate? { get set }
    //var mcSessionDelegate: MCSessionDelegate? { get set }
}

class mainViewModel {
    //**** MultipeerConnectivity use ****
    private var peerID:MCPeerID!
    private var mcSession:MCSession!
    private var mcAdvertiserAssistant:MCAdvertiserAssistant!
    
    private var msgList = [MessageItem]() //message list
    private var imageList = [ImageItem]() //images list, only have 2 images
    var isConnected:Bool! //peer coneection status
    
    weak var mcBroswerDelegate:MCBrowserViewControllerDelegate?
    //weak var mcSessionDelegate:MCSessionDelegate?
    
    init(){
        self.imageList = DataManager.loadImageData()
        self.msgList = DataManager.loadAll(MessageItem.self).sorted(by: {$0.createdAt < $1.createdAt})
        
        self.peerID = MCPeerID(displayName: UIDevice.current.name)
        self.mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
    }
    
    public var getPeerID: MCPeerID {
        return peerID
    }
    
    public var getMcSession: MCSession {
        return mcSession
    }
    
    public var getImageList: [ImageItem] {
        return self.imageList
    }
    
    public var getMcAdvertiserAssistant: MCAdvertiserAssistant {
        return mcAdvertiserAssistant
    }
    
    public var getMessageCount: Int {
        return self.msgList.count
    }
    
    public func reloadImg() {
        self.msgList = DataManager.loadAll(MessageItem.self)
    }
    
    public func getCellData(indexPath: IndexPath) -> (msgItem:MessageItem, img:UIImage) {
        let tmpMsgItem = msgList[indexPath.row]
        
        var image = UIImage.init()
        if let data = imageList.filter({ $0.itemIdentifier == tmpMsgItem.riderCompy}).first?.itemImageData {
            image = UIImage(data: data)!
        }
        
        return (tmpMsgItem, image)
    }
    /**
     Get local imageitem from riderCompany
     */
    public func getLocalImage(riderCompy: riderCompany) -> ImageItem? {
        if let imgItem = self.imageList.filter({ $0.itemIdentifier == riderCompy}).first {
            return imgItem
        }
        return nil
    }
    /**
     If peers count > 0 , send the data to other iOS devices. Otherwise call presentingTickerVC to shows message.
     */
    public func showMessageVC(_ msg:MessageItem) -> (peerCount:Int,rideComp: riderCompany,others: AnyObject?) {
        if mcSession.connectedPeers.count > 0  {
            //pass logo image if not BOTH
            if msg.riderCompy != .Both {
                guard let imgData = self.imageList.filter({ $0.itemIdentifier == msg.riderCompy}).first?.itemImageData else {
                    return (mcSession.connectedPeers.count, msg.riderCompy, nil)
                }
                
                var newMsg = MessageItem(withPhoto: msg.Msg, riderCompy: msg.riderCompy, bgType: msg.backGroundType, iid: msg.itemIdentifier, createdAt: msg.createdAt, completed: msg.completed, logoImageData: imgData)
                newMsg.Msg2 = msg.Msg2
                do{
                    let encoder = JSONEncoder()
                    if let encodedData = try? encoder.encode(newMsg) {
                        //try mcSession.send(encodedData, toPeers: mcSession.connectedPeers, with: .reliable)
                        try self.prepareToSendData(encodedData)
                    }
                    
                }catch let error{
                    NSLog("%@", "Error for sending: \(error)")
                }
            }
        }else{
            return (0,msg.riderCompy,nil)
        }
        return (mcSession.connectedPeers.count,msg.riderCompy,nil)
    }
    
    func showMessage(data: Data?,OrUrlPath: URL?) -> UIViewController? {
        var msgItem: MessageItem?
        
        do {
            //if data is not nil
            if let data = data {
                msgItem = try JSONDecoder().decode(MessageItem.self, from: data)
            }
            //if url is not nil
            if let dataFromUrl = OrUrlPath {
                let data = try Data(contentsOf: dataFromUrl)
                msgItem = try JSONDecoder().decode(MessageItem.self, from: data)
            }
            
            guard let tmpMsgItem = msgItem else {
                return nil
            }
            
            if tmpMsgItem.completed == true {
                //SINGLE IMAGE WITH MESSAGE
                let vc = presentingTickerVC()
                vc.msgItem = tmpMsgItem
                return vc
            }else if tmpMsgItem.completed == false && tmpMsgItem.riderCompy == .Both {
                //BOTH
                let vc = presentingLogoOnlyVC()
                if let imgData1 = tmpMsgItem.logoImageData, let imgData2 = tmpMsgItem.logoImageData2 {
                    vc.view.backgroundColor = UIColor.orange
                    vc.UberImage = UIImage(data: imgData1)
                    vc.LyftImage = UIImage(data: imgData2)
                }
                return vc
            }else{
                //SINGLE IMAGE
                let vc = presentingSingleLogoVC()
                vc.logoType = tmpMsgItem.riderCompy
                
                if let imgData = tmpMsgItem.logoImageData {
                    vc.logoImagData = imgData
                }
                return vc
            }
            
        }catch{
            fatalError("Unable to process recieved data")
        }

    }
    /**
     If peers count > 0 , get local image to messageitem
     */
    public func prepareMessageItemToPeer(segmentIndex: Int)  {
        var msgItem:MessageItem?
        
        if segmentIndex == 2 {
            //show both
            if let firstImgData = self.imageList.first?.itemImageData, let secondImgData = self.imageList.last?.itemImageData {
                msgItem = MessageItem(onlyTwoPhotos: UUID(), logoImageData: firstImgData, logoImageData2: secondImgData)
            }
            
        }else if segmentIndex == 1{
            //show single logo - lyft
            if let imgData = getLocalImage(riderCompy: .Lyft)?.itemImageData {
                msgItem = MessageItem(withPhoto: "", riderCompy: .Lyft, bgType: .auto, iid: UUID(), createdAt: Date(), completed: false, logoImageData: imgData)
            }
            
            
        }else{
            //show single logo - uber
            if let imgData = getLocalImage(riderCompy: .UBER)?.itemImageData {
                msgItem = MessageItem(withPhoto: "", riderCompy: .UBER, bgType: .auto, iid: UUID(), createdAt: Date(), completed: false, logoImageData: imgData)
            }
            
        }
        
        //send to peer
        do{
            let encodedData = try JSONEncoder().encode(msgItem)
            try mcSession.send(encodedData, toPeers: mcSession.connectedPeers, with: .reliable)
            
        }catch let error{
            NSLog("%@", "Error for sending: \(error)")
        }
    }
    
    internal func prepareToSendData(_ data: Data) throws {
        
        let fileController = DTFileController.main
        let saveUrl = fileController.cachesUrl(withFileName: "Message.data")
        
        if fileController.fileExist(atUrl: saveUrl) {
            
            try fileController.removeFile(at: saveUrl)
        }
        
        try data.write(to: saveUrl)
        self.sendData(atUrl: saveUrl)
    }
    
    internal func sendData(atUrl url: URL, at index: Int = 0) {
        
        let peers = mcSession.connectedPeers
        
        if index >= peers.count {
            
            return
        }
        
        let peer = mcSession.connectedPeers[index]
        let completionHandler: (Error?) -> Void = {
            error in
            
            if let error = error {
                
                print("Got some error: \(error), at \(index)")
            }
            
            //send to next peer
            self.sendData(atUrl: url, at: index + 1)
        }
        
        let progress = mcSession.sendResource(at: url, withName: "Message", toPeer: peer, withCompletionHandler: completionHandler)
        
        progress.unwrapped {
            
            let _ = $0.observe(\.fractionCompleted, options: .new) {
                
                (progress, change) in
                
                print("Sending... (\(change.newValue! * 100.0)%)")
            }
        }
    }
    
}

extension mainViewModel {
    public func showConnectivityAlertView(vc:UIViewController, completion: @escaping ActionViewCompletion)  {
        
        let actionSheet = UIAlertController(title: "Display Choice", message: "This device want to be Host or Client?", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Host", style: .default, handler: { (action:UIAlertAction) in
            
            self.mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "ba-td", discoveryInfo: nil, session: self.mcSession)
            self.mcAdvertiserAssistant.start()
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Client(Showing the device list)", style: .default, handler: { (action:UIAlertAction) in
            
            let mcBrowser = MCBrowserViewController(serviceType: "ba-td", session: self.mcSession)
            mcBrowser.delegate = self.mcBroswerDelegate
            vc.present(mcBrowser, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = vc.view
            popoverController.sourceRect = CGRect(x: vc.view.bounds.midX, y: vc.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        //Add disconnect action if isconnected is true
        if self.isConnected == true {
            let actionDisconnect = UIAlertAction(title: "Disconnect", style: .destructive, handler: { _ in
                self.mcSession.disconnect()
            })
            actionSheet.addAction(actionDisconnect)
        }
        
        vc.present(actionSheet, animated: true, completion: nil)
    }
    

}

