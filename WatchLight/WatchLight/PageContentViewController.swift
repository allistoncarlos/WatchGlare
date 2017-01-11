//
//  PageContentViewController.swift
//  WatchLight
//
//  Created by Alliston Aleixo on 09/01/17.
//  Copyright © 2017 Alliston Aleixo. All rights reserved.
//

import UIKit
import Foundation

class PageContentViewController: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    var pageIndex:      Int = 0
    var strTitle:       String!
    var strPhotoName:   String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //imageView.image = UIImage(named: strPhotoName)
        //lblTitle.text = strTitle
    }
}
