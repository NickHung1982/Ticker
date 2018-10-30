//
//  presentingSingleLogoVC.swift
//  rideTicker
//
//  Created by Nick on 8/31/18.
//  Copyright © 2018 NickOwn. All rights reserved.
//

import UIKit

class presentingSingleLogoVC: UIViewController {
    var logoType:riderCompany?
    var logoImagData:Data?
    
    @IBOutlet weak var logoImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Add gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture))
        tapGesture.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(tapGesture)
        
        if let logoImagData = logoImagData {
            logoImg.image = UIImage(data: logoImagData)
        }else{
            
            let imgList = DataManager.loadImageData()
            let imgSingleItem:ImageItem?
            //asign default image if don't have
            if let logo = logoType {
                if logo == .Lyft {
                    do {
                        imgSingleItem = imgList.filter({ $0.itemIdentifier == riderCompany.Lyft }).first
                        logoImg.image = UIImage(data: (imgSingleItem?.itemImageData)!)
                    }
                }else if logo == .UBER {
                    do {
                        imgSingleItem = imgList.filter({ $0.itemIdentifier == riderCompany.UBER }).first
                        logoImg.image = UIImage(data: (imgSingleItem?.itemImageData)!)
                    }
                }
            }
            
        }
        
    }
    @objc func tapGesture(){
        self.dismiss(animated: true, completion: nil)
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
