//
//  ViewController.swift
//  Smart_weather
//
//  Created by Melkozavr on 09.04.2020.
//  Copyright © 2020 Melkozavr. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {

    let apiKey = "4346304df400288d06cc99c0d3cadedb"
    var checker = 0
    
    @IBOutlet weak var locationTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func goButton(_ sender: UIButton) {
        if locationTextField.text! == "" {
            let alert = UIAlertController(title: "Error!", message: "Text field must be filled", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationController = segue.destination as? WeatherViewController else { return }
        guard let location = locationTextField.text else { return }
        destinationController.location = location
        locationTextField.text = ""
    }
}

