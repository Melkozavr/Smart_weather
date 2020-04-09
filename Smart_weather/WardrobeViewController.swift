//
//  WardrobeViewController.swift
//  Smart_weather
//
//  Created by Melkozavr on 09.04.2020.
//  Copyright © 2020 Melkozavr. All rights reserved.
//

import Foundation
import UIKit

class WardrobeViewController: UIViewController {
    
    
    @IBOutlet weak var wearLabel: UILabel!
    
    var result = ""
    
    @IBAction func exitButton(_ sender: UIButton) {
        performSegue(withIdentifier: "toExit", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wearLabel.text = result
    }
}
