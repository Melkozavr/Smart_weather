//
//  WeatherViewController.swift
//  Smart_weather
//
//  Created by Melkozavr on 09.04.2020.
//  Copyright © 2020 Melkozavr. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView

class WeatherViewController : UIViewController {
    
    var location: String = ""
    var pic = ""
    
    @IBOutlet weak var celsiusLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var dayLabel: UILabel!
    
    @IBOutlet weak var conditionLabel: UILabel!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var conditionImageView: UIImageView!
    
    @IBOutlet weak var backgroundView: UIView!
    
    let gradientLayer = CAGradientLayer()
    
    let apiKey = "4346304df400288d06cc99c0d3cadedb"
    var activityIndicator: NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.layer.addSublayer(gradientLayer)
        
        let indicatorSize: CGFloat = 70
        let indicatorFrame = CGRect(x: (view.frame.width - indicatorSize)/2, y: (view.frame.height - indicatorSize)/2, width: indicatorSize, height: indicatorSize)
        activityIndicator = NVActivityIndicatorView(frame: indicatorFrame, type: .lineScale, color: UIColor.white, padding: 20.0)
        activityIndicator.backgroundColor = .black
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        locateMe()
    }
}

extension WeatherViewController {
    
    func setBlueGradientBackground () {
        let topColor = UIColor(red: 95.0/255.0, green: 165.0/255.0, blue: 1.0, alpha: 1.0).cgColor
        let bottomColor = UIColor(red: 72.0/255.0, green: 114.0/255.0, blue: 184.0/255.0, alpha: 1.0).cgColor
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [topColor, bottomColor]
    }
    
    func setGrayGradientBackground() {
        let topColor = UIColor(red: 151.0/255.0, green: 151.0/255.0, blue: 151.0/255.0, alpha: 1.0).cgColor
        let bottomColor = UIColor(red: 72.0/255.0, green: 72.0/255.0, blue: 72.0/255.0, alpha: 1.0).cgColor
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [topColor, bottomColor]
    }
}

extension WeatherViewController {
    
    func locateMe() {
        let replacement = self.location.replacingOccurrences(of: " ", with: "%20")
        Alamofire.request("https://api.openweathermap.org/data/2.5/weather?q=\(replacement)&appid=\(apiKey)&units=metric").responseJSON {
            response in
            self.activityIndicator.stopAnimating()
            if let responseStr = response.result.value {
                let jsonResponse = JSON(responseStr)
                if jsonResponse["message"].stringValue == "city not found" {
                    let alert = UIAlertController(title: "Error!", message: "City not found", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                } else {
                    let jsonWeather = jsonResponse["weather"].array![0]
                    let jsonTemp = jsonResponse["main"]
                    let iconName = jsonWeather["icon"].stringValue

                    self.celsiusLabel.text = "℃"
                    self.locationLabel.text = self.location
                    self.conditionImageView.image = UIImage(named: iconName)
                    self.conditionLabel.text = jsonWeather["main"].stringValue
                    self.temperatureLabel.text = "\(Int(round(jsonTemp["temp"].doubleValue)))"
                    self.pic = iconName
            
                    let date = Date()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "EEEE"
                    self.dayLabel.text = dateFormatter.string(from: date)
            
                    let suffix = iconName.suffix(1)
                    if suffix == "n" {
                        self.setGrayGradientBackground()
                    } else {
                        self.setBlueGradientBackground()
                    }
                }
            }
        }
    }
}

extension WeatherViewController {
    
    @IBAction func wardrobeButton(_ sender: UIButton) {
        performSegue(withIdentifier: "toWardrobe", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationController = segue.destination as? WardrobeViewController else { return }
        guard let temperature = Int(temperatureLabel.text!) else { return }
        var collector = ""
        if temperature <= 0 {
            collector = "Please wear: gloves, scarf, cap and down-bed."
            if pic == "13d" || pic == "13n" {
                collector = "Please wear: gloves, scarf, cap and down-bed. Don`t forget about scarf!"
            }
        } else if temperature > 0 && temperature <= 0 {
            collector = "Please wear: jacket."
            if pic == "11d" || pic == "11n" {
                collector = "Please wear: jacket. Take raincoat or umbrella. Recomended to stay at home."
            }
            if pic == "09d" || pic == "09n" || pic == "10d" || pic == "10n" {
                collector = "Please wear: jacket. Take raincoat or umbrella."
            }
        } else {
            collector = "Please wear: t-shirt and shorts."
            if pic == "09d" || pic == "09n" || pic == "10d" || pic == "10n" {
                collector = "Please wear: t-shirt and shorts. Take raincoat or umbrella."
            }
            if pic == "11d" || pic == "11n" {
                collector = "Please wear: t-shirt and shorts. Take raincoat or umbrella. Recomended to stay at home."
            }
        }
        destinationController.result = collector
    }
}
