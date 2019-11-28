//
//  LoadingViewController.swift
//  startupeiros
//
//  Created by Bruno Pastre on 28/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        DatabaseAdmin.shared.loadJobs { (i, jobList) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "viewController") as! ViewController
            let skills = jobList[0].hackerSkills
            vc.skills = skills.map({ (skill) -> Skill in
                let parsedSkill = Skill(name: skill.name, iconName: skill.icon)
                
                let tasks = skill.tasks.map { (dbTask) -> Task in
                    return Task(name: dbTask.name, iconName: dbTask.icon)
                }
                parsedSkill.tasks = tasks
                return parsedSkill
            })
            
            vc.modalPresentationStyle = .overFullScreen
            
            self.present(vc, animated: true, completion: nil)
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
