//
//  TaskTableViewCell.swift
//  startupeiros
//
//  Created by Bruno Pastre on 28/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var taskIcon: UIImageView!
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var taskProgressBarSpace: UIView!
    
    var currentTaskBar: TaskBar?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func runProgressBar(with task: Task) {
        if self.currentTaskBar != nil {
            self.currentTaskBar?.removeFromSuperview()
            self.currentTaskBar = nil
        }
        
        self.currentTaskBar = TaskBar()
        
        guard let bar = self.currentTaskBar else { return }
        
        bar.task = task
        bar.translatesAutoresizingMaskIntoConstraints = false
        
        self.taskProgressBarSpace.addSubview(bar)
        
        bar.leadingAnchor.constraint(equalTo: self.taskProgressBarSpace.leadingAnchor).isActive = true
        
        bar.bottomAnchor.constraint(equalTo: self.taskProgressBarSpace.bottomAnchor).isActive = true
        
        bar.trailingAnchor.constraint(equalTo: self.taskProgressBarSpace.trailingAnchor).isActive = true
        
        bar.topAnchor.constraint(equalTo: self.taskProgressBarSpace.topAnchor).isActive = true
        
        self.layoutIfNeeded()
        
        bar.startProgress()
        
    }
    
    func setup() {

        backgroundColor = UIColor.clear

        self.backView.layer.borderWidth = 1
        self.backView.layer.cornerRadius = 10
        self.backView.layer.borderColor = UIColor.clear.cgColor
        self.backView.layer.masksToBounds = true
        self.backView.backgroundColor = #colorLiteral(red: 0.3818710744, green: 0.6760137677, blue: 0.9938718677, alpha: 1)

//        self.layer.shadowOpacity = 0.6
////        self.layer.shadowOffset = CGSize(width: 0, height: 4)
//        self.layer.shadowRadius = 10
//        self.layer.shadowColor = UIColor.gray.cgColor
//        self.layer.masksToBounds = false
    }

}
