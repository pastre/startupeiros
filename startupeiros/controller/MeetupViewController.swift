//
//  MeetupViewController.swift
//  startupeiros
//
//  Created by Bruno Pastre on 06/12/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import UIKit

class PickingJob {
    
    internal init(name: String?, whoPicked: PlayerClass?) {
        self.name = name
        self.whoPicked = whoPicked
    }
    
    var name: String!
    var whoPicked: PlayerClass?
}

class MeetupCollectionViewCell: UICollectionViewCell {
    
}

class MeetupViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    
    
    var jobs: [PickingJobs] = []

    let registerId = "register"
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(MeetupCollectionViewCell.self, forCellWithReuseIdentifier: self.registerId)
        
        view.delegate = self
        view.dataSource = self
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - CollectionView Data source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.jobs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.registerId, for: indexPath)
        
        return cell
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
