//
//  DrawingViewController.swift
//  startupeiros
//
//  Created by Maykon Meneghel on 30/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import UIKit

struct Challenge {
    
    var drawList = [
        "key":"🗝",
        "rabbit":"🐇",
        "shoe":"👞",
        "penguin":"🐧",
        "camel":"🐫",
        "bridge":"🌉",
        "monkey":"🐒",
        "pig":"🐖",
        "shark":"🦈",
        "microphone":"🎤",
        "lantern":"🔦",
        "book":"📖",
        "pizza":"🍕",
        "bicycle":"🚲",
        "mouse":"🐁"
    ]
    
    var drawCurrent: (key: String, value: String)! = (key: "" , value: "" )
    
    init(){
        self.chooseChallenge()
    }
    
    mutating func chooseChallenge() {
        drawCurrent = drawList.randomElement()
    }
}


class DrawingViewController: UIViewController {

    var canvas = Canvas()
    var timerLabel: String = ""
    var seconds: Int = 30
    
    let returnButton: UIButton = {
        let button = UIButton()
        var image: UIImage = UIImage(named: "return")!
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(handleReturn), for: .touchUpInside)
        return button
    }()
    
    let labelCronometer: UILabel = {
//        var timer = Timer()
//        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(DrawingViewController.updateTimer)), userInfo: nil, repeats: true)
//        print(timer)
        let label = UILabel()
        label.text = "30"
        label.textColor = UIColor.white
        return label
    }()
    
    let label1: UILabel = {
       let label = UILabel()
        label.text =  Challenge.init().drawCurrent.value
        label.font = UIFont.systemFont(ofSize: 40.0, weight: .bold)
        label.textAlignment  = .center
        return label
    }()
    
    let label2: UILabel = {
       let label = UILabel()
        label.text =  Challenge.init().drawCurrent.value
        label.font = UIFont.systemFont(ofSize: 40.0, weight: .bold)
        label.textAlignment  = .center
        return label
    }()
    
    let label3: UILabel = {
       let label = UILabel()
        label.text =  Challenge.init().drawCurrent.value
        label.font = UIFont.systemFont(ofSize: 40.0, weight: .bold)
        label.textAlignment  = .center
        return label
    }()
    
    let label4: UILabel = {
       let label = UILabel()
        label.text =  Challenge.init().drawCurrent.value
        label.font = UIFont.systemFont(ofSize: 40.0, weight: .bold)
        label.textAlignment  = .center
        return label
    }()
    
    let drawView: UIView = {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.layer.cornerRadius = view.frame.width/2
        view.backgroundColor = .blue
        
        let label = UILabel()
        label.text =  Challenge.init().drawCurrent.value
        label.textAlignment  = .center
    
        view.addSubview(label)
        
        return view
    }()
    
    let undoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Desfazer", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14.0)
        button.addTarget(self, action: #selector(handleUndo), for: .touchUpInside)
        return button
    }()
    
    let clearButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Limpar", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14.0)
        button.addTarget(self, action: #selector(handleClear), for: .touchUpInside)
        return button
    }()
    
    let slider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 5
        slider.maximumValue = 15
        slider.addTarget(self, action: #selector(handleSliderChanged), for: .valueChanged)
        return slider
    }()
    
//    @objc func updateTimer() {
//        seconds -= 1     //This will decrement(count down)the seconds.
//        labelCronometer.text = "\(seconds)" //This will update the label.
//    }
    
    @objc func  handleReturn(){
        print("return")
    }
    
    @objc func handleSliderChanged(){
        canvas.setStrokeWidth(width: slider.value)
    }
    
    @objc func handleUndo(){
        canvas.undo()
    }
    
    @objc func handleClear(){
        canvas.clear()
    }
    
    override func loadView() {
        self.view = canvas
    }
    fileprivate func setupButtons() {
        let stackView = UIStackView(arrangedSubviews: [undoButton, slider, clearButton])
        view.addSubview(stackView)
        
        stackView.distribution = .fillEqually
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive =  true
        stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive =  true
        stackView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive =  true
        stackView.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    fileprivate func setupViews(){
        let stackView = UIStackView(arrangedSubviews: [returnButton, label1, label2, label3, label4])
        view.addSubview(stackView)
        
        stackView.distribution = .fillEqually
       
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive =  true
        stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive =  true
        stackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive =  true
        stackView.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    fileprivate func cronometerView() {
        drawView.addSubview(labelCronometer)
        labelCronometer.translatesAutoresizingMaskIntoConstraints = false
        labelCronometer.centerXAnchor.constraint(equalTo: self.drawView.centerXAnchor).isActive =  true
        labelCronometer.centerYAnchor.constraint(equalTo: self.drawView.centerYAnchor).isActive =  true
        labelCronometer.heightAnchor.constraint(equalTo: self.drawView.heightAnchor).isActive = true
        labelCronometer.widthAnchor.constraint(equalTo: self.drawView.widthAnchor, multiplier: 0.80).isActive = true
        
        
        self.view.addSubview(drawView)
        drawView.translatesAutoresizingMaskIntoConstraints = false
        drawView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 40).isActive =  true
        drawView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 150).isActive =  true
        drawView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        drawView.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        canvas.backgroundColor = UIColor.white
        setupButtons()
        setupViews()
        cronometerView()
    }
    
    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge{
        return .all
    }

}

extension UIView {
    var screenshot: UIImage{
        UIGraphicsBeginImageContext(self.bounds.size);
        let context = UIGraphicsGetCurrentContext();
        self.layer.render(in: context!)
        let screenShot = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return screenShot!
    }
}

