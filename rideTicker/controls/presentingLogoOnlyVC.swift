//
//  presentingLogoOnlyVC.swift
//  rideTicker
//
//  Created by Nick on 8/24/18.
//  Copyright © 2018 NickOwn. All rights reserved.
//

import UIKit

class presentingLogoOnlyVC: UIViewController {
    @IBOutlet weak var LyftImage: UIImageView!
    @IBOutlet weak var UberImage: UIImageView!
    
    var imageFromData_Lyft:UIImage?
    var imageFromData_Uber:UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture))
        tapGesture.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(tapGesture)
        
        if imageFromData_Lyft == nil && imageFromData_Uber == nil {
            getAllImages()
        }
        
        checkCurrentOrientation()
    }
    private func getAllImages(){
        let imgList = DataManager.loadImageData()
        for item in imgList {
            if item.itemIdentifier == .Lyft {
                self.imageFromData_Lyft = UIImage(data: item.itemImageData!)
            }
            if item.itemIdentifier == .UBER {
                self.imageFromData_Uber = UIImage(data: item.itemImageData!)
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
    
    func checkCurrentOrientation(){
        if UIDevice.current.userInterfaceIdiom != .pad {
            LyftImage.image = self.imageFromData_Lyft
            UberImage.image = self.imageFromData_Uber
            return
        }
        let orient = UIApplication.shared.statusBarOrientation
        switch orient {
            case .portrait,.portraitUpsideDown:
                print("Portrait")
                self.applyportraitConstraint()
                break

            default:
                print("LandScape")
                self.applyLandScapeConstraint()
                break
        }
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) -> Void in

                self.checkCurrentOrientation()
            
        }, completion: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            print("rotation completed")
        })
        
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    //Only work for ipad - Portrait
    func applyportraitConstraint(){
        for subview in self.view.subviews {
            if subview is UIImageView {
                subview.removeFromSuperview()
            }
        }
        
        
        let xPoint_Lyft = CGPoint(x: (self.view.center.x), y: (self.view.center.y / 2))
        let newLyftImage = UIImageView.init(image: imageFromData_Lyft)
        newLyftImage.frame.size = CGSize(width: 480, height: 480)
        newLyftImage.center = xPoint_Lyft
        self.view.addSubview(newLyftImage)
        
        let xPoint_Uber = CGPoint(x: (self.view.center.x), y: (self.view.center.y/2)*3)
        let newUberImage = UIImageView.init(image: imageFromData_Uber)
        newUberImage.frame.size = CGSize(width: 480, height: 480)
        newUberImage.center = xPoint_Uber
        self.view.addSubview(newUberImage)
        

    }
    //Only work for ipad - LandScape
    func applyLandScapeConstraint(){
        for subview in self.view.subviews {
            if subview is UIImageView {
                subview.removeFromSuperview()
            }
        }
        
        
        let xPoint_Lyft = CGPoint(x: (self.view.center.x/2), y: self.view.center.y)
        print(xPoint_Lyft)
        
        let newLyftImage = UIImageView.init(image: imageFromData_Lyft)
        newLyftImage.frame.size = CGSize(width: 480, height: 480)
        newLyftImage.center = xPoint_Lyft
        self.view.addSubview(newLyftImage)
        
        let xPoint_Uber = CGPoint(x: (self.view.center.x/2)*3, y: self.view.center.y)
        print(xPoint_Uber)
        let newUberImage = UIImageView.init(image: imageFromData_Uber)
        newUberImage.frame.size = CGSize(width: 480, height: 480)
        newUberImage.center = xPoint_Uber
        self.view.addSubview(newUberImage)
        
 
    }


}
