//
//  ViewController.swift
//  LemonStand
//
//  Created by Александр Подрабинович on 04/01/15.
//  Copyright (c) 2015 Alex Podrabinovich. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var moneySupplyCount: UILabel!
    @IBOutlet weak var lemonsSupplyCount: UILabel!
    @IBOutlet weak var iceSupplyCount: UILabel!
    
    @IBOutlet weak var lemonPurchaseCount: UILabel!
    @IBOutlet weak var icePurchaseCount: UILabel!
    
    
    @IBOutlet weak var lemonMixCount: UILabel!
    @IBOutlet weak var iceMixCount: UILabel!
    
    var supply = Supplies(aMoney: 1000, aLemons: 1, aIceCubes: 1)
    var price = Price()
    
    var lemonsToPurchase = 0
    var iceCubesToPurchase = 0
    var lemonsToMix = 0
    var iceCubesToMix = 0
    
    var weatherArray: [[Int]] = [[-9,-2,-5,-3], [3,7,1,0], [27,22,19,25]]
    var weatherToday: [Int] = [0,0,0,0]
    
    var weatherImageView = UIImageView(frame: CGRectMake(20, 50, 50, 50))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.addSubview(weatherImageView)
        generateWeather()
        
        updateMainView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func purchaseLemonButtonPressed(sender: AnyObject) {
        if supply.money >= price.lemon {
            supply.lemons++
            supply.money -= price.lemon
            lemonsToPurchase++
            updateMainView()
        }
        else {
            showAlertWithText(message: "Not enough money!")
        }
    }

    @IBAction func purchaseIceCubeButtonPressed(sender: AnyObject) {
        if supply.money >= price.iceCube {
            supply.iceCubes++
            supply.money -= price.iceCube
            iceCubesToPurchase++
            updateMainView()
        }
        else {
            showAlertWithText(message: "Not enough money!")
        }
    }
    
    @IBAction func unpurchaseLemonButtonPressed(sender: AnyObject) {
        if lemonsToPurchase > 0 {
            supply.lemons--
            supply.money += price.lemon
            lemonsToPurchase--
            updateMainView()
        }
        else {
            showAlertWithText(message: "No lemons at all!")
        }
    }
    
    @IBAction func unpurchaseIceCubeButtonPressed(sender: AnyObject) {
        if iceCubesToPurchase > 0 {
            supply.iceCubes--
            supply.money += price.iceCube
            iceCubesToPurchase--
            updateMainView()
        }
        else {
            showAlertWithText(message: "No ice cubes at all!")
        }
    }
    
    
    @IBAction func mixLemonButtonPressed(sender: AnyObject) {
        if supply.lemons > 0 {
            supply.lemons--
            lemonsToMix++
            updateMainView()
        }
        else {
            showAlertWithText(message: "No lemons to mix!")
        }
    }
    
    @IBAction func mixIceCubeButtonPressed(sender: AnyObject) {
        if supply.iceCubes > 0 {
            supply.iceCubes--
            iceCubesToMix++
            updateMainView()
        }
        else {
            showAlertWithText(message: "No ice cubes to mix!")
        }
    }
    
    @IBAction func unmixLemonButtonPressed(sender: AnyObject) {
        if lemonsToMix > 0 {
            supply.lemons++
            lemonsToMix--
            updateMainView()
        }
        else {
            showAlertWithText(message: "No lemons to mix!")
        }
    }
    
    @IBAction func unmixIceCubeButtonPressed(sender: AnyObject) {
        if iceCubesToMix > 0 {
            supply.iceCubes++
            iceCubesToMix--
            updateMainView()
        }
        else {
            showAlertWithText(message: "No ice cubes to mix!")
        }
    }
    
    
    @IBAction func starDayButtonPressed(sender: AnyObject) {
        let average = findAverage(weatherToday)
        
        let customers = Int(arc4random_uniform(UInt32(average)))
        let lemonadeRation = Float(lemonsToMix) / Float(iceCubesToMix)
        
        for x in 0...customers {
            let preference = Double(arc4random_uniform(UInt32(100))) / 100
            if preference < 0.4 && lemonadeRation > 1 {
                supply.money++
            }
            else if preference > 0.6 && lemonadeRation < 1 {
                supply.money++
            }
            else if preference <= 0.6 && preference >= 0.4 && lemonadeRation == 1 {
                supply.money++
            }
        }
        
        lemonsToPurchase = 0
        iceCubesToPurchase = 0
        lemonsToMix = 0
        iceCubesToMix = 0
        
        generateWeather()
        
        updateMainView()
    }
    
    func updateMainView() {
        moneySupplyCount.text = "\(supply.money) руб"
        lemonsSupplyCount.text = "\(supply.lemons) лимон"
        iceSupplyCount.text = "\(supply.iceCubes) льда"
        
        lemonPurchaseCount.text = "\(lemonsToPurchase)"
        icePurchaseCount.text = "\(iceCubesToPurchase)"
        
        lemonMixCount.text = "\(lemonsToMix)"
        iceMixCount.text = "\(iceCubesToMix)"
    }
    
    func generateWeather() {
        let index = Int(arc4random_uniform(UInt32(weatherArray.count)))
        weatherToday = weatherArray[index]
        
        switch index {
        case 0: weatherImageView.image = UIImage(named: "Cold")
        case 1: weatherImageView.image = UIImage(named: "Mild")
        case 2: weatherImageView.image = UIImage(named: "Warm")
        default: weatherImageView.image = UIImage(named: "Mild")
        }
    }
    
    func findAverage(cdata: [Int]) -> Int {
        var average: Double = 0
        for item in cdata {
            average += Double(item)
        }
        average = ceil(average / Double(cdata.count))
        
        return Int(average)
    }
    
    //Helpers
    
    func showAlertWithText(header: String = "Warning", message: String) {
        var alert = UIAlertController(title: header, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
}

