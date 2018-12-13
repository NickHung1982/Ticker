//
//  DTNavigationController.swift
//  rideTicker
//
//  Created by EdenLi on 2018/12/13.
//  Copyright © 2018年 Darktt. All rights reserved.
//

import UIKit

public class DTNavigationController: UINavigationController
{

    public override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationBar.apply {
            
            let tintColor = UIColor.white
            
            $0.tintColor = tintColor
        }
    }
    
}
