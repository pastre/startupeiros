//
//  CreateTeamViewController.swift
//  startupeiros
//
//  Created by Bruno Pastre on 22/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import UIKit

class CreateTeamViewController: CreateNameViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .gray
        // Do any additional setup after loading the view.
    }
    
    override func onNext() {
        NewTeamDatabaseFacade.createRoom(named: self.textView.text) { (error) in
            if let error  = error {
                print("Erro ao criar a sala", error)
                return
            }

            self.dismiss(animated: true)  {
                guard let navParent = self.navParent as? NewTeamViewController else { return }
                navParent.joinRoom(NewTeamDatabaseFacade.newRoomId!)
            }
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
