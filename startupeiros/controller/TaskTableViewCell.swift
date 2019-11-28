//
//  TaskTableViewCell.swift
//  startupeiros
//
//  Created by Bruno Pastre on 28/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var taskIcon: UIImageView!
    @IBOutlet weak var taskLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
