//
//  TabBarController.swift
//  Safety Score Accelerometer
//
//  Created by Christopher Torrella on 9/29/21.
//

import UIKit
import Foundation


class TabBarController: UITabBarController {
    
    //Stored in TabViewController so they can be accessed in both the Settings and Accelerometer tabviews
    var UpperAccelBoundaryValue = 0.3
    var UpperBoundaryToneValue = 659
    var LowerAccelBoundaryValue = 0.1
    var LowerBoundaryToneValue = 523

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

}
