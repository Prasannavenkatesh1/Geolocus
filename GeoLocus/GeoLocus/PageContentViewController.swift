//
//  PageContentViewController.swift
//  GeoLocus
//
//  Created by Saranya on 22/01/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import UIKit

class PageContentViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    var pageIndex : Int!
    var titleString : String!
    var imageName : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backgroundImageView.image = UIImage(named:imageName)
        self.titleLabel.text = self.titleString
        self.titleLabel.alpha = 0.1
        UIView.animateWithDuration(0.2, delay: 0.3, options: UIViewAnimationOptions.TransitionNone, animations: {
            self.titleLabel.alpha = 1.0
            }, completion:nil)
    }
}
