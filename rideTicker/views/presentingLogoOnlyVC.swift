//
//  presentingLogoOnlyVC.swift
//  rideTicker
//
//  Created by Nick on 8/24/18.
//  Copyright © 2018 NickOwn. All rights reserved.
//

import UIKit

final class presentingLogoOnlyVC: UIViewController {
    
    var UberImage: UIImage?
    var LyftImage: UIImage?
    
    var UberImageView: UIImageView!
    var LyftImageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UberImage == nil && LyftImage == nil {
            getAllImages()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        //tap twice to dismiss vc
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture))
        tapGesture.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(tapGesture)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UberImage != nil && LyftImage != nil {
           checkCurrentOrientation()
        }
    }

    private func getAllImages(){
        let imgList = DataManager.loadImageData()
        for item in imgList {
            if item.itemIdentifier == .Lyft {
                LyftImage = UIImage(data: item.itemImageData!)
            }
            if item.itemIdentifier == .UBER {
                UberImage = UIImage(data: item.itemImageData!)
            }
        }
    }
    @objc func tapGesture(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//        if UberImage != nil || LyftImage != nil {
//            checkCurrentOrientation()
//        }
//    }
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
        
        let UberImageView = UIImageView()
        UberImageView.contentMode = .scaleAspectFit
        let LyftImageView = UIImageView()
        LyftImageView.contentMode = .scaleAspectFit
        
        if UberImage != nil && LyftImage != nil {
            UberImageView.image = UberImage
            LyftImageView.image = LyftImage
        }
        
        stackView.addArrangedSubview(UberImageView)
        stackView.addArrangedSubview(LyftImageView)
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
        
        UberImageView = UIImageView()
        UberImageView.contentMode = .scaleAspectFit
        LyftImageView = UIImageView()
        LyftImageView.contentMode = .scaleAspectFit
        
        if UberImage != nil && LyftImage != nil {
            UberImageView.image = UberImage
            LyftImageView.image = LyftImage
        }
        
        stackView.addArrangedSubview(UberImageView)
        stackView.addArrangedSubview(LyftImageView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        //constraint
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        
    }



}
