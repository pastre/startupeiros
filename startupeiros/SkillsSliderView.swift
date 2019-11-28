//
//  BarsView.swift
//  startupeiros
//
//  Created by Bruno Pastre on 20/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation
import UIKit


class SkillsSliderView: UIView {

    let colors: [UIColor] = [.blue, .brown, .green, .magenta, .yellow]
    var sliders: [UISlider]?
    var timeViews: [UIView]?
    var widthConstraints: [NSLayoutConstraint]?
    var timeBar: UIView?
    
    func getBar(colored color: UIColor) -> UISlider {
        let slider = UISlider()
        
        slider.translatesAutoresizingMaskIntoConstraints = false
        
        slider.maximumValue = 100
        slider.minimumValue = 0
        slider.tintColor = color
        slider.thumbTintColor = color
        slider.value = 0
//        slider.transform = slider.transform.rotated(by: CGFloat.pi / 2)
        slider.addTarget(self, action: #selector(self.onSliderChanged(_:)), for: .valueChanged)
        return slider
    }
    
    func getBaseView(colored color: UIColor? = nil) -> UIView {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        if let color = color  {
            view.backgroundColor = color
        }
        
        return view
    }
    
    func setupSliders() -> UIView{
        let view = self.getBaseView()
        var prevView: UIView?
        var sliders: [UISlider] = []
        
        for color in colors {
            let slider = self.getBar(colored: color)
            view.addSubview(slider)
            sliders.append(slider)
        }

        for slider in sliders {
            slider.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            slider.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            
            
            slider.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1 / CGFloat(self.colors.count)).isActive = true
            
            if let prev = prevView {
                slider.leadingAnchor.constraint(equalTo: prev.trailingAnchor).isActive = true
            } else {
                slider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
            }
            
            prevView = slider
        }
        
        self.sliders = sliders
        return view
    }
    
    func setupTimeBar() -> UIView{
        let view = self.getBaseView()
        
        var views: [UIView] = []
        var widthConstraints: [NSLayoutConstraint] = []
        
        var lastView: UIView?
        
        
        for color in self.colors {
            let newView = self.getBaseView(colored: color)
            newView.backgroundColor = color
            view.addSubview(newView)
            views.append(newView)
        }
        
        for timeView in views {
            timeView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            timeView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            
            if let last = lastView {
                timeView.leadingAnchor.constraint(equalTo: last.trailingAnchor).isActive = true
            } else {
                timeView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            }
            
            let wConstraint = timeView.widthAnchor.constraint(equalToConstant: 1)
            
            widthConstraints.append(wConstraint)
                    
            wConstraint.isActive = true
            
            lastView =  timeView
        }
        
        self.widthConstraints = widthConstraints
        self.timeViews = views
        
        return view
    }
    
    func getColorCount() -> CGFloat {
        return CGFloat(self.colors.count)
    }
    
    func updateTimeBar() {
        guard let constraints = self.widthConstraints else { return }
        guard let views = self.timeViews else  { return }
        guard let sliders = self.sliders else { return }
        guard let view = self.timeBar else  { return }
        
        var fullSpace:CGFloat = view.frame.width
        var r: CGFloat = fullSpace
        var n: CGFloat = self.getColorCount()
        
        let multipliers = sliders.map { (slider) -> CGFloat in
            return CGFloat(slider.value) / CGFloat(100)
        }
        
        var widths: [CGFloat] = []
        var remainders: [CGFloat] = []
        var multRemainders = Array<CGFloat>.init(repeating: 0, count: self.colors.count)
        
        for multiplier in multipliers {
            let rawWidth = multiplier * fullSpace // / n
            let remainder = (fullSpace / 1) - rawWidth
            
            widths.append(rawWidth)
            remainders.append(remainder)
            
        }
        
        for (j, remainder) in remainders.enumerated() {
            let prop = remainder / (self.getColorCount() - 1)
            
            for i in 0..<multRemainders.count {
                if i == j { continue }
                multRemainders[i] += prop
            }
        }
        
        for (i,  constraint) in constraints.enumerated() {
            print("w, mr", widths[i], multRemainders[i])
            constraint.constant = widths[i] + multRemainders[i]
            
            print( constraint.constant)
            
            views[i].setNeedsLayout()
        }
        
        print("-----------")
        self.layoutIfNeeded()
    }
    
    func getDefaultTimeViewWidth() -> CGFloat {
        
        return self.timeBar!.frame.width / self.getColorCount()
    }
    
    func setup() {
        let slidersView = self.setupSliders()
        let timeBar = self.setupTimeBar()
        
        self.addSubview(timeBar)
        self.addSubview(slidersView)
        
        slidersView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        slidersView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        slidersView.trailingAnchor.constraint(equalTo: self.trailingAnchor,  constant:  -40).isActive = true
        slidersView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5).isActive = true
        
        timeBar.topAnchor.constraint(equalTo: slidersView.bottomAnchor).isActive = true
        timeBar.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        timeBar.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        timeBar.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.2).isActive = true
        
        timeBar.backgroundColor = .gray
        
        self.timeBar = timeBar
        
    }
    
    @objc func onSliderChanged(_ slider: UISlider){
        guard let sliders = self.sliders else { return }
//        print("Slider changed!",  sliders.firstIndex(of: slider))
        
        self.updateTimeBar()
    }
    
}
