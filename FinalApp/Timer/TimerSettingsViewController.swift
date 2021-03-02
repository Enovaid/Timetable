//
//  TimerSettingsViewController.swift
//  FinalApp
//
//  Created by Alikhan Khassen on 18.12.2020.
//

import UIKit

class TimerSettingsViewController: UIViewController {

    @IBOutlet weak var workTimeLabel: UILabel!
    @IBOutlet weak var breakTimeLabel: UILabel!
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var goButton: UIButton!
    
    @IBOutlet weak var workTimeSlider: UISlider!
    @IBOutlet weak var breakTimeSlider: UISlider!
    @IBOutlet weak var roundSlider: UISlider!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    
    private func setup(){
        workTimeSlider.value = 5
        breakTimeSlider.value = 5
        roundSlider.value = 4
        goButton.layer.cornerRadius = goButton.frame.size.height/2
        workTimeLabel.layer.cornerRadius = 6
        workTimeLabel.layer.masksToBounds = true
        breakTimeLabel.layer.cornerRadius = 6
        breakTimeLabel.layer.masksToBounds = true
        roundLabel.layer.cornerRadius = 6
        roundLabel.layer.masksToBounds = true

    }
    
    @IBAction func workSliderDidChange(_ sender: UISlider) {
        if Int(sender.value)*5 == 60 {
            workTimeLabel.text = "1:00:00"
        }else{
            workTimeLabel.text = String(Int(sender.value)*5) + ":00"
        }
        
    }
    
    @IBAction func breakSliderDidChange(_ sender: UISlider) {
        breakTimeLabel.text = String(Int(sender.value)) + ":00"
    }
    
    
    @IBAction func roundSliderDidChange(_ sender: UISlider) {
        roundLabel.text = String(Int(sender.value))
    }
    
    @IBAction func ResetDefaultsDidTap(_ sender: UIButton) {
        workTimeSlider.value = 5
        breakTimeSlider.value = 5
        roundSlider.value = 4
        workTimeLabel.text = "25:00"
        breakTimeLabel.text = "5:00"
        roundLabel.text = "4"
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TimerSegue"{
            let destination = segue.destination as! TimerViewController
            destination.workTime = Int(workTimeSlider.value) * 5
//            destination.workTime = 1
            destination.breakTime = Int(breakTimeSlider.value)
            destination.round = Int(roundSlider.value)
    
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIButton {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }

    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}

