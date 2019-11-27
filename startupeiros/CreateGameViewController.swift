//
//  CreateGameViewController.swift
//  startupeiros
//
//  Created by Maykon Meneghel on 27/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import UIKit

class CreateGameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.createGame()
        // Do any additional setup after loading the view.
    }
    
    func createGame(){
        let entities =  DatabaseTask(name: "Entities", icon: "entities.png")
        let attributes =  DatabaseTask(name: "Attributes", icon: "attributes.png")
        let relationship =  DatabaseTask(name: "Relationship", icon: "relationship.png")
        let classDiagram =  DatabaseTask(name: "Class Diagram", icon: "classDiagram.png")
        let performance =  DatabaseTask(name: "Performance", icon: "performance.png")

        let modelling = DatabaseSkill(name: "Modelling", icon: "modelling.png", tasks: [entities, attributes, relationship, classDiagram, performance])

        // Back-End
        let programmingBack =  DatabaseTask(name: "Programming", icon: "programmingBack.png")
        let functions =  DatabaseTask(name: "Functions", icon: "functions.png")
        let classes =  DatabaseTask(name: "Classes", icon: "classes.png")
        let inheritance =  DatabaseTask(name: "Inheritance", icon: "inheritance.png")
        let protocols =  DatabaseTask(name: "Protocols", icon: "protocols.png")
        let refactor =  DatabaseTask(name: "Refactor", icon: "refactor.png")
        let api =  DatabaseTask(name: "API", icon: "api.png")
        let polimorfism =  DatabaseTask(name: "Polimorfism", icon: "polimorfism.png")
        let reactive =  DatabaseTask(name: "Reactive Programming", icon: "reactive.png")

        let backEnd = DatabaseSkill(name: "Back-End", icon: "backend.png", tasks: [programmingBack, functions, classes, inheritance, protocols, refactor, api, polimorfism, reactive])

        // Front-End
        let programmingFront =  DatabaseTask(name: "Programming", icon: "programmingFront.png")
        let outlets =  DatabaseTask(name: "Outlets", icon: "outlets.png")
        let screens =  DatabaseTask(name: "Screens", icon: "screens.png")
        let views =  DatabaseTask(name: "Views", icon: "views.png")
        let constraints =  DatabaseTask(name: "Constraints", icon: "constraints.png")

        let frontEnd = DatabaseSkill(name: "Front-End", icon: "backend.png", tasks: [programmingFront, outlets, screens, views, constraints])

        // Embedded Eletronics
        let design =  DatabaseTask(name: "Design", icon: "design.png")
        let datasheet = DatabaseTask(name: "Datasheet", icon: "datasheet.png")
        let schematic = DatabaseTask(name: "Schematic", icon: "schematic.png")
        let prototyping = DatabaseTask(name: "Prototyping", icon: "prototyping.png")
        let testing = DatabaseTask(name: "Testing", icon: "testing.png")
        let layout = DatabaseTask(name: "Layout", icon: "layout.png")
        let manufacture = DatabaseTask(name: "Manufacture", icon: "manufacture.png")
        let assembly = DatabaseTask(name: "Assembly", icon: "assembly.png")

        let embeddedEletronics = DatabaseSkill(name: "Embedded Electronics", icon: "embeddedEletronics.png", tasks: [design, datasheet, schematic, prototyping, testing, layout, manufacture, assembly])

        // Create a JOB
        let mvp = DatabaseJob(name: "Create a Minimal Viable Product (MVP)", icon: "mvp.png", hackerSkills: [backEnd, frontEnd, embeddedEletronics, modelling], hustlerSkills: [], hipsterSkills: [])
        
//        mvp.saveGame()
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
