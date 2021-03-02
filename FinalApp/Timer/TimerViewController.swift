//
//  TimerViewController.swift
//  FinalApp
//
//  Created by Alikhan Khassen on 17.12.2020.
//

import UIKit

class TimerViewController: UIViewController, CAAnimationDelegate {
//        let shapeLayer = CAShapeLayer()
//    var focusTime = 25
//    var breakTime = 5
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var modeLabel: UILabel!
    @IBOutlet weak var roundLabel: UILabel!
    private var isWorkTime: Bool = true {
        didSet {
            if(isWorkTime == false){
                currentModeTime = breakTime
                currentModeColor = UIColor.green.cgColor
                modeLabel.text = "BREAK"
            }
            else{
                currentModeTime = workTime
                currentModeColor = UIColor.red.cgColor
                currentRound += 1
                roundLabel.text = String(currentRound) + "/" + String(round!)
                modeLabel.text = "WORK"
            }
        }
    }
    let foreProgressLayer = CAShapeLayer()
    let backProgressLayer = CAShapeLayer()
    let animation = CABasicAnimation(keyPath: "strokeEnd")
    private var currentModeColor = UIColor.red.cgColor
    var timer = Timer()
    var isTimerStarted = false
    var isAnimationStarted = false
    var time = 65
    var breakTime: Int?
    var workTime: Int?
    var round: Int?
    var currentRound: Int = 0
    var currentModeTime: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        currentModeTime = workTime!
        drawBackLayer()
        setup()
//        addCircle()

        // Do any additional setup after loading the view.

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        navigationController?.popViewController(animated: true)

        dismiss(animated: true, completion: nil)
    }
    
    private func setup() {
        
        roundLabel.layer.cornerRadius = 6
        roundLabel.layer.masksToBounds = true
        startButton.layer.cornerRadius = startButton.frame.size.height/2
        time = currentModeTime! * 60
        if currentModeTime! == 60 {
            timerLabel.text = "1:00:00"
        }else{
            timerLabel.text = String(currentModeTime!) + ":00"
        }
        roundLabel.text = "0/" + String(round!)
        
    }
//    private func addCircle(){
//        var center = view.center
//            center.y = center.y - timerLabel.bounds.height / 2
//        let tracklayer = CAShapeLayer()
//
//        let circularPath = UIBezierPath(arcCenter: center, radius: 100, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
//        tracklayer.path = circularPath.cgPath
//        tracklayer.strokeColor = UIColor.lightGray.cgColor
//        tracklayer.fillColor = UIColor.clear.cgColor
//        tracklayer.lineWidth = 13
//        tracklayer.lineCap = .round
//
//        view.layer.addSublayer(tracklayer)
//
//
//    //    let circularPath = UIBezierPath(arcCenter: center, radius: 100, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
//            shapeLayer.path = circularPath.cgPath
//            shapeLayer.strokeColor = UIColor.red.cgColor
//            shapeLayer.fillColor = UIColor.clear.cgColor
//            shapeLayer.lineWidth = 13
//
//            shapeLayer.lineCap = .round
//
//            shapeLayer.strokeEnd = 0
//
//            view.layer.addSublayer(shapeLayer)
//
//            view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
//    }
//
//    @objc private func handleTap() {
//        print("working")
//
//        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
//        basicAnimation.toValue = 1
//        basicAnimation.duration = 2
//
//        basicAnimation.fillMode = .forwards
//        basicAnimation.isRemovedOnCompletion = false
//        shapeLayer.add(basicAnimation, forKey: "urSoBasic")
//
//    }
//
//    @IBAction func startButtonPressed(_ sender: UIButton) {
//    }
    
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        cancelButton.isEnabled = true
        cancelButton.alpha = 1.0
        if !isTimerStarted{
            drawForeLayer()
            startResumeAnimaton()
            startTimer()
            isTimerStarted = true
//            startButton.setTitle("Pause", for: .normal)
//            startButton.setTitleColor(UIColor.orange, for: .normal)
            startButton.setImage(UIImage(named: "pause.png"), for: .normal)
        }else{
            pauseAnimation()
            timer.invalidate()
            isTimerStarted = false
//            startButton.setTitle("Resume", for: .normal)
//            startButton.setTitleColor(UIColor.green, for: .normal)
            startButton.setImage(UIImage(named: "play.png"), for: .normal)
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        stopAnimation()
        isWorkTime = true
        cancelButton.isEnabled = false
        cancelButton.alpha = 0.5
        roundLabel.text = "0/" + String(round!)
//        startButton.setTitle("Start", for: .normal)
//        startButton.setTitleColor(UIColor.green, for: .normal)
        startButton.setImage(UIImage(named: "play.png"), for: .normal)
        timer.invalidate()
        time = currentModeTime! * 60
        isTimerStarted = false
        if currentModeTime! == 60 {
            timerLabel.text = "1:00:00"
        }else{
            timerLabel.text = String(currentModeTime!) + ":00"
        }
        
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if time < 1 {
            cancelButton.isEnabled = false
            isWorkTime.toggle()
            cancelButton.alpha = 0.5
//            startButton.setTitle("Start", for: .normal)
//            startButton.setTitleColor(UIColor.green, for: .normal)
            startButton.setImage(UIImage(named: "play.png"), for: .normal)
            timer.invalidate()
            time = currentModeTime! * 60
            isTimerStarted = false
            if currentModeTime! == 60 {
                timerLabel.text = "1:00:00"
            }else{
                timerLabel.text = String(currentModeTime!) + ":00"
            }
        }else {
            
            time -= 1
            timerLabel.text = formatTime()
        }
        
    }
    
    func formatTime() -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i", minutes, seconds)
        
    }
    
    func drawBackLayer() {
        backProgressLayer.path = UIBezierPath(arcCenter: CGPoint(x: view.frame.midX, y: timerLabel.frame.origin.y + timerLabel.bounds.height / 2) , radius: 100, startAngle: -90.degreesToRadiands, endAngle: 270.degreesToRadiands, clockwise: true).cgPath
        
        backProgressLayer.strokeColor = UIColor.gray.cgColor
        backProgressLayer.fillColor = UIColor.clear.cgColor
        
        backProgressLayer.lineWidth = 5
        
        view.layer.addSublayer(backProgressLayer)
    }
    func drawForeLayer() {
        foreProgressLayer.path = UIBezierPath(arcCenter: CGPoint(x: view.frame.midX, y: timerLabel.frame.origin.y + timerLabel.bounds.height / 2 - 1), radius: 100, startAngle: -90.degreesToRadiands, endAngle: 270.degreesToRadiands, clockwise: true).cgPath
        
        foreProgressLayer.strokeColor = currentModeColor
        foreProgressLayer.fillColor = UIColor.clear.cgColor
        foreProgressLayer.lineWidth = 13
        foreProgressLayer.lineCap = .round
        view.layer.addSublayer(foreProgressLayer)
    }
    func startResumeAnimaton() {
        if !isAnimationStarted {
            startAnimation()
        }else{
            resumeAnimation()
        }
    }
    func startAnimation() {
        resetAnimation()
        foreProgressLayer.strokeEnd = 0.0
        animation.keyPath = "strokeEnd"
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = CFTimeInterval(currentModeTime! * 60)
        animation.delegate = self
        animation.isRemovedOnCompletion = false
        animation.isAdditive = true
        animation.fillMode = .forwards
        foreProgressLayer.add(animation, forKey: "strokeEnd")
        isAnimationStarted = true
    }
    func resetAnimation() {
        foreProgressLayer.speed = 1.0
        foreProgressLayer.timeOffset = 0.0
        foreProgressLayer.beginTime = 0.0
        foreProgressLayer.strokeEnd = 0.0
        isAnimationStarted = false
    }
    
    func pauseAnimation() {
        let pausedTime = foreProgressLayer.convertTime(CACurrentMediaTime(), from: nil)
        foreProgressLayer.speed = 0.0
        foreProgressLayer.timeOffset = pausedTime
    }
    
    func resumeAnimation() {
        let pausedTime = foreProgressLayer.timeOffset
        foreProgressLayer.speed = 1.0
        foreProgressLayer.timeOffset = 0.0
        foreProgressLayer.beginTime = 0.0
        let timeSincePaused = foreProgressLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        foreProgressLayer.beginTime = timeSincePaused
    }
    
    func stopAnimation() {
        foreProgressLayer.speed = 1.0
            foreProgressLayer.timeOffset = 0.0
        foreProgressLayer.beginTime = 0.0
        foreProgressLayer.strokeEnd = 0.0
        foreProgressLayer.removeAllAnimations()
        isAnimationStarted = false
    }
    internal func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        stopAnimation()
    }
}

extension Int {
    var degreesToRadiands : CGFloat {
        return CGFloat(self) * .pi / 180
    }
}
