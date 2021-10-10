//
//  ViewController.swift
//  Safety Score Accelerometer
//
//  Created by Christopher Torrella on 9/28/21.

//  Contains the code for all three tabviews
//

import UIKit
import CoreMotion

class SettingsViewController: UIViewController {
    
    @IBOutlet var UpperAccelBoundaryLabel: UILabel!
    @IBOutlet var UpperAccelBoundarySlider: UISlider!
    
    @IBOutlet var UpperBoundaryToneLabel: UILabel!
    @IBOutlet var UpperBoundaryToneSlider: UISlider!
    
    @IBOutlet var LowerAccelBoundaryLabel: UILabel!
    @IBOutlet var LowerAccelBoundarySlider: UISlider!
    
    @IBOutlet var LowerBoundaryToneLabel: UILabel!
    @IBOutlet var LowerBoundaryToneSlider: UISlider!
    
    let myUnit = ToneOutputUnit()
    
    let UpperBoundAccelText = "Upper Bound, Accel.: "
    let UpperBoundToneText = "Upper Bound, Tone: "
    let LowerBoundAccelText = "Lower Bound, Accel.: "
    let LowerBoundToneText = "Lower Bound, Tone: "
    
    
    // These 4 funcs are called when a slider moves

    @objc
    func UpperAccelBoundarySliderChanged(slider:UISlider) {
        let value = round(Double(UpperAccelBoundarySlider.value) * 10) / 10.0
        
        let tabBar = tabBarController as! TabBarController
        tabBar.UpperAccelBoundaryValue = value
        
        UpperAccelBoundaryLabel.text = UpperBoundAccelText + String(value) + " g"
        
    }
    @objc
    func UpperBoundaryToneSliderChanged(slider:UISlider) {
        let value = Double(UpperBoundaryToneSlider.value)
        
        let tabBar = tabBarController as! TabBarController
        tabBar.UpperBoundaryToneValue = Int((value * 2500) + 500)
        
        UpperBoundaryToneLabel.text = UpperBoundToneText + String(tabBar.UpperBoundaryToneValue) + " Hz"
        
        myUnit.setFrequency(freq: Double(tabBar.UpperBoundaryToneValue))
        myUnit.setToneVolume(vol: 1)
        myUnit.enableSpeaker()
        myUnit.setToneTime(t: 1)

    }
    @objc
    func LowerAccelBoundarySliderChanged(slider:UISlider) {
        let value = round(Double(LowerAccelBoundarySlider.value) * 10) / 10.0
        
        let tabBar = tabBarController as! TabBarController
        tabBar.LowerAccelBoundaryValue = value
        
        LowerAccelBoundaryLabel.text = LowerBoundAccelText + String(value) + " g"

    }
    @objc
    func LowerBoundaryToneSliderChanged(slider:UISlider) {
        let value = Double(LowerBoundaryToneSlider.value)
        
        let tabBar = tabBarController as! TabBarController
        tabBar.LowerBoundaryToneValue = Int((value * 2500) + 500)
        
        LowerBoundaryToneLabel.text = LowerBoundToneText + String(tabBar.LowerBoundaryToneValue) + " Hz"
        
        myUnit.setFrequency(freq: Double(tabBar.LowerBoundaryToneValue))
        myUnit.setToneVolume(vol: 1)
        myUnit.enableSpeaker()
        myUnit.setToneTime(t: 1)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // attach listeners to the sliders
        UpperAccelBoundarySlider.addTarget(self, action: #selector(UpperAccelBoundarySliderChanged(slider:)), for: .valueChanged)
        UpperBoundaryToneSlider.addTarget(self, action: #selector(UpperBoundaryToneSliderChanged(slider:)), for: .valueChanged)
        LowerAccelBoundarySlider.addTarget(self, action: #selector(LowerAccelBoundarySliderChanged(slider:)), for: .valueChanged)
        LowerBoundaryToneSlider.addTarget(self, action: #selector(LowerBoundaryToneSliderChanged(slider:)), for: .valueChanged)
        
    }

}




class AccelerometerViewController: UIViewController {
    @IBOutlet var yAccelLabel: UILabel!
    @IBOutlet var yAccelBackground: UIView!

    
    let manager = CMMotionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myUnit = ToneOutputUnit()
        let tabBar = tabBarController as! TabBarController
        
        // Get device motion updates, and do actions based on values
        // Note that this manager was specifically chosen to cancel the raw acceleration due to gravity
        
        manager.startDeviceMotionUpdates(to: .main) {(motion, error) in
            if let motion = motion {
                
                let UpperAccelBoundaryValue = tabBar.UpperAccelBoundaryValue
                let UpperBoundaryToneValue = Double(tabBar.UpperBoundaryToneValue)
                let LowerAccelBoundaryValue = tabBar.LowerAccelBoundaryValue
                let LowerBoundaryToneValue = Double(tabBar.LowerBoundaryToneValue)
                
                let y = motion.userAcceleration.y
                
                // Fix label formatting so that text doesn't move erratically for negative numbers
                if y < 0 {
                    self.yAccelLabel.text = String(format: "%.2f", y)
                } else {
                    self.yAccelLabel.text = " " + String(format: "%.2f", y)
                }
                
                // Determine which tone and color to display/play based on accel of Y value
                if y > UpperAccelBoundaryValue {
                    
                    //Bad deceleration
                    self.yAccelBackground.backgroundColor = UIColor.systemRed
                    
                    myUnit.setFrequency(freq: UpperBoundaryToneValue)
                    myUnit.setToneVolume(vol: 1)
                    myUnit.enableSpeaker()
                    myUnit.setToneTime(t: 1)

                    
                } else if y > LowerAccelBoundaryValue && y <= UpperAccelBoundaryValue {
                    
                    //Good deceleration
                    self.yAccelBackground.backgroundColor = UIColor.systemGreen
                    
                    myUnit.setFrequency(freq: LowerBoundaryToneValue)
                    myUnit.setToneVolume(vol: 1)
                    myUnit.enableSpeaker()
                    myUnit.setToneTime(t: 1)
                    
                    
                } else {
                    
                    //Neutral deceleration
                    self.yAccelBackground.backgroundColor = UIColor.systemBackground
                    
                    myUnit.stop()
                    
                }
            }
        }
    }
}

