//
//  presentingLogoOnlyVC.swift
//  rideTicker
//
//  Created by Nick on 8/24/18.
//  Copyright © 2018 NickOwn. All rights reserved.
//

import UIKit

class presentingLogoOnlyVC: UIViewController {
    
    var UberImage: UIImageView!
    var LyftImage: UIImageView!
    
    var imageFromData_Uber:UIImage?
    var imageFromData_Lyft:UIImage?
    
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
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if UberImage != nil || LyftImage != nil {
            checkCurrentOrientation()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkCurrentOrientation(){
        for subview in self.view.subviews {
            subview.removeFromSuperview()
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
    
    func applyportraitConstraint(){
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 10
        
        UberImage = UIImageView(image: imageFromData_Uber)
        LyftImage = UIImageView(image: imageFromData_Lyft)
        
        stackView.addArrangedSubview(UberImage)
        stackView.addArrangedSubview(LyftImage)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        //constraint
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        
    }
    func applyLandScapeConstraint(){
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 10
        
        UberImage = UIImageView(image: imageFromData_Uber)
        LyftImage = UIImageView(image: imageFromData_Lyft)
        
        stackView.addArrangedSubview(UberImage)
        stackView.addArrangedSubview(LyftImage)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        //constraint
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        
    }



}
