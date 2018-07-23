//
//  fastSegue.swift
//  Hooga
//
//  Created by Omar Abbas on 3/3/17.
//  Copyright © 2017 Omar Abbas. All rights reserved.
//

import UIKit

class fastSegue: UIStoryboardSegue {
    override func perform() {
        let src = self.source
        let dst = self.destination
        let transition: CATransition = CATransition()
        let timeFunc : CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.duration = 0.4
        transition.timingFunction = timeFunc
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        
        src.view.window?.layer.add(transition, forKey: nil)
        src.present(dst, animated: false, completion: nil)
    }
   }
