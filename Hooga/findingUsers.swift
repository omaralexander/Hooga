//
//  findingUsers.swift
//  Hooga
//
//  Created by Omar Abbas on 4/20/17.
//  Copyright © 2017 Omar Abbas. All rights reserved.
//

import UIKit

class findingUsers: UIViewController{
    
    @IBAction func dismissButton(_ sender: UIButton) {
         dismiss(animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    scrollView.contentSize.width = 2250
    scrollView.isPagingEnabled = true
    scrollView.alwaysBounceHorizontal = true

    }
}
