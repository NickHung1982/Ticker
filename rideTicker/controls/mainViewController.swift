//
//  mainViewController.swift
//  rideTicker
//
//  Created by Nick on 8/24/18.
//  Copyright © 2018 NickOwn. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import Toast_Swift
import AudioToolbox

class mainViewController: UIViewController {
    //**** MultipeerConnectivity use ****
    var peerID:MCPeerID!
    var mcSession:MCSession!
    var mcAdvertiserAssistant:MCAdvertiserAssistant!
    //************************************
    var msgList = [MessageItem]() //message list
    var imageList = [ImageItem]() //images list, only have 2 images
    var isConnected:Bool! //peer coneection status
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var logoOnlySettingView: singleShowModeView!
    @IBOutlet weak var connectButton: UIBarButtonItem!
 
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()

        peerID = MCPeerID(displayName: UIDevice.current.name)
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession.delegate = self
        isConnected = false
        
    
        logoOnlySettingView.layer.borderColor = UIColor.black.cgColor
        logoOnlySettingView.layer.borderWidth = 1.0
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    private func loadData(){
        //load images to list
        imageList = DataManager.loadImageData()
        //load msg to list
        msgList = DataManager.loadAll(MessageItem.self).sorted(by: {$0.createdAt < $1.createdAt})
        
        logoOnlySettingView.reloadData()
        self.tableview.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func showConnectivityActions(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Display Choice", message: "This device want to be Host or Client?", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Host", style: .default, handler: { (action:UIAlertAction) in
            
            self.mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "ba-td", discoveryInfo: nil, session: self.mcSession)
            self.mcAdvertiserAssistant.start()
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Client(Showing the device list)", style: .default, handler: { (action:UIAlertAction) in
            let mcBrowser = MCBrowserViewController(serviceType: "ba-td", session: self.mcSession)
            mcBrowser.delegate = self
            self.present(mcBrowser, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        //Add disconnect action if isconnected is true
        if self.isConnected == true {
            let actionDisconnect = UIAlertAction(title: "Disconnect", style: .destructive, handler: { _ in
                self.mcSession.disconnect()
            })
            actionSheet.addAction(actionDisconnect)
        }
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addNewMsg" {
            let distVC = segue.destination as! addMsgVC
            distVC.uuid = UUID()
            distVC.delegate = self
        }
        if segue.identifier == "editMsg" {
            let msgitem = sender as! MessageItem
            let distVC = segue.destination as! addMsgVC
            distVC.msgData = msgitem
            distVC.uuid = msgitem.itemIdentifier
            distVC.delegate = self
        }
    }
    
    internal func showMessageVC(_ msg:MessageItem){
    
        if mcSession.connectedPeers.count > 0  {
            //pass logo image if not BOTH
            if msg.riderCompy != .Both {
                guard let imgData = self.imageList.filter({ $0.itemIdentifier == msg.riderCompy}).first?.itemImageData else {
                    return
                }
                
                var newMsg = MessageItem(withPhoto: msg.Msg, riderCompy: msg.riderCompy, bgType: msg.backGroundType, iid: msg.itemIdentifier, createdAt: msg.createdAt, completed: msg.completed, logoImageData: imgData)
                newMsg.Msg2 = msg.Msg2
                do{
                    let encoder = JSONEncoder()
                    if let encodedData = try? encoder.encode(newMsg) {
                        
                        try self.prepareToSendData(encodedData)
                    }
                    
                }catch let error{
                    NSLog("%@", "Error for sending: \(error)")
                }
            }

           
        }else{
            let vc = presentingTickerVC()
            vc.msgItem = msg
            vc.imgItem = self.imageList.filter({ $0.itemIdentifier == msg.riderCompy}).first
            self.present(vc, animated: true, completion: nil)
        }
    }

    internal func prepareToSendData(_ data: Data) throws {
        
        let fileController = DTFileController.main
        let saveUrl = fileController.cachesUrl(withFileName: "Message")
        
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

extension mainViewController:addMsgVCDelegate {
    func fireAfterSavedItem(_ msgItem: MessageItem){
        self.showMessageVC(msgItem)
    }
}
extension mainViewController:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return msgList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MsgListTableViewCell
        
        let tmpMsgItem = msgList[indexPath.row]
        cell.delegate = self
        cell.line1Label.text = tmpMsgItem.Msg
        cell.line2Label.text = tmpMsgItem.Msg2
        
        if let data = imageList.filter({ $0.itemIdentifier == tmpMsgItem.riderCompy}).first?.itemImageData {
            cell.logoImg.image = UIImage(data: data)
        }
       
        
        return cell
    }
    
}
extension mainViewController:actionCellDelegate {
    //Show
    func didRequestShow(_ cell:MsgListTableViewCell){
        
        if let indexPath = self.tableview.indexPath(for: cell) {
            let tmpMsgItem = msgList[indexPath.row]
            
            self.showMessageVC(tmpMsgItem)
        }
        
    }
    //Edit
    func didRequestEdit(_ cell:MsgListTableViewCell){
        if let indexPath = self.tableview.indexPath(for: cell) {
            let tmpMsgItem = msgList[indexPath.row]
            self.performSegue(withIdentifier: "editMsg", sender: tmpMsgItem)
        }
    }
}

extension mainViewController:MCSessionDelegate {
    //Called when the state of a nearby peer changes
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case MCSessionState.connected:
            //print("Connected: \(peerID.displayName)")
            DispatchQueue.main.async {
                self.connectButton.tintColor = UIColor.orange
                self.title = "Connected"
                self.isConnected = true
                //play system sound_vibrate
                AudioServicesPlaySystemSound(1011)
            }

        case MCSessionState.connecting:
            //print("Connecting: \(peerID.displayName)")
            DispatchQueue.main.async {
                self.title = "Connecting"
            }
            
        case MCSessionState.notConnected:
            //print("Not Connected: \(peerID.displayName)")
            DispatchQueue.main.async {
                self.connectButton.tintColor = UIColor.white
                self.title = "No connect"
                self.isConnected = false
            }

        }
        
    }
    //called after it has been fully received
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {

        //dismiss vc if now showing
        DispatchQueue.main.async {
            if var topController = UIApplication.shared.keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
                if topController is mainViewController {
                    
                }else{
                    topController.dismiss(animated: true, completion: nil)
                }
                
            }
        }

        //play system sound
        AudioServicesPlaySystemSound(1003)
        
        do {
            let tmpMsgItem = try JSONDecoder().decode(MessageItem.self, from: data)
            
            if tmpMsgItem.completed == true {
                //SINGLE IMAGE WITH MESSAGE
                let vc = presentingTickerVC()
                vc.msgItem = tmpMsgItem
                self.present(vc, animated: true, completion: nil)
            }else if tmpMsgItem.completed == false && tmpMsgItem.riderCompy == .Both {
                //BOTH
                let vc = presentingLogoOnlyVC()
                if let imgData1 = tmpMsgItem.logoImageData, let imgData2 = tmpMsgItem.logoImageData2 {
                    vc.view.backgroundColor = UIColor.orange
                    vc.UberImage = UIImage(data: imgData1)
                    vc.LyftImage = UIImage(data: imgData2)
                }
                self.present(vc, animated: true, completion: nil)
            }else{
                //SINGLE IMAGE
                let vc = presentingSingleLogoVC()
                vc.logoType = tmpMsgItem.riderCompy
        
                if let imgData = tmpMsgItem.logoImageData {
                    vc.logoImagData = imgData
                }
                self.present(vc, animated: true, completion: nil)
            }

            
            
        }catch{
            fatalError("Unable to process recieved data")
        }
        
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) {
        certificateHandler(true)
    }
    
}

extension mainViewController:MCBrowserViewControllerDelegate {
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }
}

extension mainViewController:singleShowModeDelegate {
    func singleShowButtonClick(_ segmentIndex:Int) {
        if mcSession.connectedPeers.count == 0 {
            //Show own device
            if segmentIndex == 2 {
                //show both
                self.present(presentingLogoOnlyVC(), animated: true, completion: nil)
            }else{
                //show single logo
                let distVC = presentingSingleLogoVC()
                if segmentIndex == 1 {
                    distVC.logoType = riderCompany.Lyft
                }else{
                    distVC.logoType = riderCompany.UBER
                }
                self.present(distVC, animated: true, completion: nil)
            }
            
        }else{
            var msgItem:MessageItem?
            //show on peer
            if segmentIndex == 2 {
                //show both
                if let firstImgData = imageList.first?.itemImageData, let secondImgData = imageList.last?.itemImageData {
                    msgItem = MessageItem(onlyTwoPhotos: UUID(), logoImageData: firstImgData, logoImageData2: secondImgData)
                }
                
                
                
            }else if segmentIndex == 1{
                //show single logo - lyft
                if let imgData = imageList.filter({ $0.itemIdentifier == riderCompany.Lyft }).first?.itemImageData {
                    msgItem = MessageItem(withPhoto: "", riderCompy: .Lyft, bgType: .auto, iid: UUID(), createdAt: Date(), completed: false, logoImageData: imgData)
                }
                
                
            }else{
                //show single logo - uber
                if let imgData = imageList.filter({ $0.itemIdentifier == riderCompany.UBER }).first?.itemImageData {
                    msgItem = MessageItem(withPhoto: "", riderCompy: .UBER, bgType: .auto, iid: UUID(), createdAt: Date(), completed: false, logoImageData: imgData)
                }
                
            }
            
            
            do{
                
                let encodedData = try JSONEncoder().encode(msgItem)
                try mcSession.send(encodedData, toPeers: mcSession.connectedPeers, with: .reliable)
                
                
            }catch let error{
                NSLog("%@", "Error for sending: \(error)")
            }
        }
    }
}
