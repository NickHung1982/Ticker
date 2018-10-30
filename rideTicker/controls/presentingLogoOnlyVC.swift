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
    @IBOutlet weak var tapView: UIView!
    
    var imageFromData_Lyft:UIImage?
    var imageFromData_Uber:UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture))
        tapGesture.numberOfTapsRequired = 2
        tapView.isUserInteractionEnabled = true
        tapView.addGestureRecognizer(tapGesture)
        
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
        // Do something
        default:
            print("LandScape")
            self.applyLandScapeConstraint()
            // Do something else
            
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
        
        
//        self.LyftImage.translatesAutoresizingMaskIntoConstraints = false
//        self.UberImage.translatesAutoresizingMaskIntoConstraints = false
//        self.LyftImage.removeConstraints(self.LyftImage.constraints)
//        self.UberImage.removeConstraints(self.UberImage.constraints)
//        self.view.removeConstraints(self.view.constraints)
//
//
//        //**** LYFT IMAGE : UP
//        //1:1 radio
//        let constraintAspectRadio = LyftImage.heightAnchor.constraint(equalTo: LyftImage.widthAnchor, multiplier: 1.0)
//        //top to safearea margin is 20
//        let constraintTop = NSLayoutConstraint(item: LyftImage, attribute: .topMargin, relatedBy: .equal, toItem: self.view, attribute: .topMargin, multiplier: 1.0, constant: 20)
//        //centerX to superview
//        let constraintX = NSLayoutConstraint(item: LyftImage, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
//
//
//
//        //**** UBER IMAGE : DOWN
//        //1:1 radio
//        let constraintAspectRadio2 = UberImage.heightAnchor.constraint(equalTo: UberImage.widthAnchor, multiplier: 1.0)
//        //buttom to safearea margin is 20
//        let constraintButtom = NSLayoutConstraint(item: UberImage, attribute: .bottomMargin, relatedBy: .equal, toItem: self.view, attribute: .bottomMargin, multiplier: 1.0, constant: 20)
//        //centerX to superview
//        let constraintX2 = NSLayoutConstraint(item: UberImage, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
//        //2 IMAGEVIEW BETWEEN 10
//        let verticalSpace = NSLayoutConstraint(item: self.LyftImage, attribute: .bottom, relatedBy: .equal, toItem: self.UberImage, attribute: .top, multiplier: 1, constant: 20)
//
//        //2 image equal with
//        let equalWidth2Img = UberImage.widthAnchor.constraint(equalTo: LyftImage.widthAnchor, multiplier: 1.0)
//
//    self.view.addConstraints([constraintAspectRadio2,constraintButtom,constraintX2,verticalSpace,constraintTop,constraintX,equalWidth2Img,constraintAspectRadio])


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
        
        
//        newLyftImage.translatesAutoresizingMaskIntoConstraints = false
//        newUberImage.translatesAutoresizingMaskIntoConstraints = false
//
//
//        newLyftImage.widthAnchor.constraint(equalToConstant: 480.0).isActive = true
//        newUberImage.widthAnchor.constraint(equalToConstant: 480.0).isActive = true
//
//        newLyftImage.trailingAnchor.constraint(equalTo: newUberImage.leadingAnchor, constant: 20).isActive = true
//
//
//        newLyftImage.heightAnchor.constraint(equalTo: newUberImage.heightAnchor, multiplier: 1).isActive = true
//        newUberImage.widthAnchor.constraint(equalTo: newLyftImage.widthAnchor, multiplier: 1).isActive = true
//
//        newLyftImage.heightAnchor.constraint(equalTo: newLyftImage.widthAnchor, multiplier: 1.0).isActive = true
//        newUberImage.heightAnchor.constraint(equalTo: newUberImage.widthAnchor, multiplier: 1.0).isActive = true
//
//        newUberImage.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
//        newLyftImage.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
//        self.LyftImage.translatesAutoresizingMaskIntoConstraints = false
//        self.UberImage.translatesAutoresizingMaskIntoConstraints = false
        

//        self.LyftImage.removeConstraints(self.LyftImage.constraints)
//        self.UberImage.removeConstraints(self.UberImage.constraints)
//        self.view.removeConstraints(self.view.constraints)
//
//        //**** LYFT IMAGE : LEFT
//        //1:1 radio
//        let constraintAspectRadio = LyftImage.heightAnchor.constraint(equalTo: LyftImage.widthAnchor, multiplier: 1.0)
//        //left to safearea margin is 20
//        let constraintLeft = NSLayoutConstraint(item: LyftImage, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 20)
//        //centerY to superview
////        let constraintY = NSLayoutConstraint(item: LyftImage, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0)
//        let limitWidth_lyft = LyftImage.widthAnchor.constraint(equalToConstant: 480.0)
//
//        //**** UBER IMAGE : RIGHT
//        //1:1 radio
//        let constraintAspectRadio2 = UberImage.heightAnchor.constraint(equalTo: UberImage.widthAnchor, multiplier: 1.0)
//        //buttom to safearea margin is 20
//        let constraintRight = NSLayoutConstraint(item: UberImage, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: 20)
//        //centerY to superview
////        let constraintY2 = NSLayoutConstraint(item: UberImage, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0)
//
//        //2 IMAGEVIEW BETWEEN 20
//        let horizontalSpace = NSLayoutConstraint(item: LyftImage, attribute: .trailing, relatedBy: .equal, toItem: UberImage, attribute: .leading, multiplier: 1, constant: 20)
//        //2 image equal with
//        let equalWidth2Img = UberImage.widthAnchor.constraint(equalTo: LyftImage.widthAnchor, multiplier: 1.0)
//        //2 image equal height
//        let equalHeight2Img = LyftImage.heightAnchor.constraint(equalTo: UberImage.heightAnchor, multiplier: 1.0)
//    self.view.addConstraints([limitWidth_lyft,constraintAspectRadio,constraintLeft,constraintAspectRadio2,constraintRight,horizontalSpace,equalWidth2Img,equalHeight2Img])
     
//        UberImage.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
//        LyftImage.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }


}
