//
//  RolesCollectionViewCell.swift
//  startupeiros
//
//  Created by Maykon Meneghel on 08/12/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import UIKit

class RolesCollectionViewCell: UICollectionViewCell {
    
    let cardView: UIView = {
        let view  = UIView()
        view.alpha = 0.5
        view.backgroundColor = .clear
        return view
    }()
    
    let imageView: UIImageView = {
        let image = UIImage()
        return UIImageView(image: image)
    }()
    
    let labelView: UILabel = {
        let label = UILabel()
        label.backgroundColor = .black
        label.font = UIFont.systemFont(ofSize: 24.0, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    func setup() {
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        self.contentView.widthAnchor.constraint(equalToConstant: 145).isActive = true
        
        self.contentView.addSubview(self.cardView)
        self.cardView.translatesAutoresizingMaskIntoConstraints = false
        self.cardView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        self.cardView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        self.cardView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor).isActive = true
        self.cardView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor).isActive = true
        
        self.cardView.addSubview(self.imageView)
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.topAnchor.constraint(equalTo: self.cardView.topAnchor).isActive = true
        self.imageView.centerXAnchor.constraint(equalTo: self.cardView.centerXAnchor).isActive = true
        self.imageView.heightAnchor.constraint(equalTo: self.cardView.heightAnchor, multiplier: 0.85).isActive = true
        self.imageView.widthAnchor.constraint(equalTo: self.cardView.widthAnchor).isActive = true
        
        self.cardView.addSubview(self.labelView)
        self.labelView.translatesAutoresizingMaskIntoConstraints = false
        self.labelView.topAnchor.constraint(equalTo: self.imageView.bottomAnchor).isActive = true
        self.labelView.centerXAnchor.constraint(equalTo: self.cardView.centerXAnchor).isActive = true
        self.labelView.heightAnchor.constraint(equalTo: self.cardView.heightAnchor, multiplier: 0.15).isActive = true
        self.labelView.widthAnchor.constraint(equalTo: self.cardView.widthAnchor).isActive = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
