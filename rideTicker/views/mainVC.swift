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

class mainViewController: UIViewController{
    
    var model:mainViewModel!
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var logoOnlySettingView: singleShowModeView!
    @IBOutlet weak var connectButton: UIBarButtonItem!
 
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()

        model = mainViewModel.init()
        model.getMcSession.delegate = self
        model.mcBroswerDelegate = self

        
        logoOnlySettingView.layer.borderColor = UIColor.black.cgColor
        logoOnlySettingView.layer.borderWidth = 1.0
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        model.reloadImg()
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func showConnectivityActions(_ sender: Any) {
        
        model.showConnectivityAlertView(vc: self, completion: { action in
            
            print(action.title!)
            
        })
 
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
    
    func showMessageVC(_ msg:MessageItem){
        //model will handle sending data to peer if peer count > 0
        if self.model.showMessageVC(msg).peerCount == 0 {
            let vc = presentingTickerVC()
            vc.msgItem = msg
            vc.imgItem = self.model.getLocalImage(riderCompy: msg.riderCompy)
            self.present(vc, animated: true, completion: nil)
        }

    }

    func dismissCurrentVC() {
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
    
    


}

extension mainViewController:addMsgVCDelegate {
    //Delegate method from addMsg "Save and show"
    func fireAfterSavedItem(_ msgItem: MessageItem){
        self.showMessageVC(msgItem)
    }
}
extension mainViewController:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.getMessageCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MsgListTableViewCell
        cell.delegate = self
        
        let tmpMsgObj = model.getCellData(indexPath: indexPath)
        cell.line1Label.text = tmpMsgObj.msgItem.Msg
        cell.line2Label.text = tmpMsgObj.msgItem.Msg2
        cell.logoImg.image = tmpMsgObj.img
        
        return cell
    }
    
}
extension mainViewController:actionCellDelegate {
    //Show
    func didRequestShow(_ cell:MsgListTableViewCell){
        if let indexPath = self.tableview.indexPath(for: cell) {
            let tmpMsgItem = model.getCellData(indexPath: indexPath)
            self.showMessageVC(tmpMsgItem.msgItem)
        }
        
    }
    //Edit
    func didRequestEdit(_ cell:MsgListTableViewCell){
        if let indexPath = self.tableview.indexPath(for: cell) {
            let tmpMsgItem = model.getCellData(indexPath: indexPath)
            self.performSegue(withIdentifier: "editMsg", sender: tmpMsgItem.msgItem)
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
                self.model.isConnected = true
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
                self.model.isConnected = false
            }

        }
        
    }
    //called after it has been fully received
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {

        //dismiss vc if now showing
        DispatchQueue.main.async {
            self.dismissCurrentVC()
        }

        //play system sound
        AudioServicesPlaySystemSound(1003)
     
        if let vc = model.showMessage(data: data, OrUrlPath: nil){
            self.present(vc, animated: true, completion: nil)
        }
     
        
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        print(progress.completedUnitCount)
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        if let _ = error {
            self.view.makeToast("ERROR")
            return
        }
        guard let fileURL = localURL else { return }
        //dismiss vc if now showing
        DispatchQueue.main.async {
            self.dismissCurrentVC()
        }
        
        //play system sound
        AudioServicesPlaySystemSound(1003)
        
        if let vc = model.showMessage(data: nil, OrUrlPath: fileURL) {
            self.present(vc, animated: true, completion: nil)
        }
        
        
        
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
    /**
     This action is for shows icon only mode (the area on the buttom of main view)
     */
    func singleShowButtonClick(_ segmentIndex:Int) {
        //Show own device
        if model.getMessageCount == 0 {
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
            //show on peer
           model.prepareMessageItemToPeer(segmentIndex: segmentIndex)
        }
    

    }
}
