//
//  presentingTickerVC.swift
//  rideTicker
//
//  Created by Nick on 8/24/18.
//  Copyright © 2018 NickOwn. All rights reserved.
//

import UIKit

class presentingTickerVC: UIViewController {
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var msg1Label: UILabel!
    @IBOutlet weak var msg2Label: UILabel!
    var msgItem:MessageItem?
    var imgItem:ImageItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Add gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture))
        tapGesture.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(tapGesture)

        //Adjust Logo
        if UIDevice.current.userInterfaceIdiom == .pad {
            logoImg.widthAnchor.constraint(equalToConstant: 375.0).isActive = true
        
        }
        //Logo border
        logoImg.layer.borderColor = UIColor.white.cgColor
        logoImg.layer.borderWidth = 2
        logoImg.layer.cornerRadius = 10
        
        
        loadData()
    }
    @objc func tapGesture(){
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData(){
        if let msg = msgItem {
            //check if msg.logoImage has data means from peer
            if msg.logoImageData != nil {
                if let fromPeerImage = msg.logoImageData {
                    self.logoImg.image = UIImage(data: fromPeerImage)
                }
            }else{
                let imgData = DataManager.loadImageFromRiderCompany(msg.riderCompy)
                self.logoImg.image = UIImage(data: imgData!)
            }
            
            
            self.msg1Label.text = msg.Msg
            self.msg2Label.text = msg.Msg2
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
