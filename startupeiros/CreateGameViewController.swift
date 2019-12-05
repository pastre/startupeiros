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

//        self.createGame()
        // Do any additional setup after loading the view.
    }
    
//    func createGame(){
//
//        let moodboard =  DatabaseTask(name: "Moodboard", icon: "moodboard.png")
//        let benchmarking =  DatabaseTask(name: "Benchmarking", icon: "benchmarking.png")
//        let briefing =  DatabaseTask(name: "Briefing", icon: "briefing.png")
//        let brainstorming =  DatabaseTask(name: "Brainstorming", icon: "brainstorming.png")
//
//        let naming = DatabaseSkill(name: "Naming", icon: "naming.png", tasks: [moodboard, benchmarking, briefing, brainstorming])
//
//        let paletadecor =  DatabaseTask(name: "Paleta de cor", icon: "paletadecor.png")
//        let tipografia =  DatabaseTask(name: "Tipografia", icon: "tipografia.png")
//        let estilo =  DatabaseTask(name: "Estil", icon: "estilo.png")
//
//        let identidadevisual = DatabaseSkill(name: "Naming", icon: "naming.png", tasks: [moodboard, paletadecor, tipografia, estilo])
//
//        let jornadadousuário =  DatabaseTask(name: "Jornada do Usuário", icon: "jornadadousuário.png")
//        let serviceblueprint =  DatabaseTask(name: "Service Blueprint", icon: "serviceblueprint.png")
//        let grupofocal =  DatabaseTask(name: "Grupo Focal", icon: "grupofocal.png")
//        let userhistories =  DatabaseTask(name: "User Histories", icon: "userhistories.png")
//        let mapadaexperiência =  DatabaseTask(name: "Mapa da experiência", icon: "mapadaexperiência.png")
//
//        let ux = DatabaseSkill(name: "User Experience (UX)", icon: "ux.png", tasks: [jornadadousuário, grupofocal, userhistories, mapadaexperiência, serviceblueprint])
//
//
//        let wireframe =  DatabaseTask(name: "Wireframe", icon: "wireframe.png")
//        let wireflow =  DatabaseTask(name: "Wireflow", icon: "wireflow.png")
//        let mockup =  DatabaseTask(name: "Mockup", icon: "mockup.png")
//        let ilustração =  DatabaseTask(name: "Ilustração", icon: "ilustração.png")
//
//        let ui = DatabaseSkill(name: "User Interface (UI)", icon: "ui.png", tasks: [wireframe, wireflow, mockup, ilustração])
//
//        let entities =  DatabaseTask(name: "Entities", icon: "entities.png")
//        let attributes =  DatabaseTask(name: "Attributes", icon: "attributes.png")
//        let relationship =  DatabaseTask(name: "Relationship", icon: "relationship.png")
//        let classDiagram =  DatabaseTask(name: "Class Diagram", icon: "classDiagram.png")
//        let performance =  DatabaseTask(name: "Performance", icon: "performance.png")
//
//        let modelling = DatabaseSkill(name: "Modelling", icon: "modelling.png", tasks: [entities, attributes, relationship, classDiagram, performance])
//
//        // MARK: - Programing
//
//        // Back-End
//        let programmingBack =  DatabaseTask(name: "Programming", icon: "programmingBack.png")
//        let functions =  DatabaseTask(name: "Functions", icon: "functions.png")
//        let classes =  DatabaseTask(name: "Classes", icon: "classes.png")
//        let inheritance =  DatabaseTask(name: "Inheritance", icon: "inheritance.png")
//        let protocols =  DatabaseTask(name: "Protocols", icon: "protocols.png")
//        let refactor =  DatabaseTask(name: "Refactor", icon: "refactor.png")
//        let api =  DatabaseTask(name: "API", icon: "api.png")
//        let polimorfism =  DatabaseTask(name: "Polimorfism", icon: "polimorfism.png")
//        let reactive =  DatabaseTask(name: "Reactive Programming", icon: "reactive.png")
//
//        let backEnd = DatabaseSkill(name: "Back-End", icon: "backend.png", tasks: [programmingBack, functions, classes, inheritance, protocols, refactor, api, polimorfism, reactive])
//
//        // Front-End
//        let programmingFront =  DatabaseTask(name: "Programming", icon: "programmingFront.png")
//        let outlets =  DatabaseTask(name: "Outlets", icon: "outlets.png")
//        let screens =  DatabaseTask(name: "Screens", icon: "screens.png")
//        let views =  DatabaseTask(name: "Views", icon: "views.png")
//        let constraints =  DatabaseTask(name: "Constraints", icon: "constraints.png")
//
//        let frontEnd = DatabaseSkill(name: "Front-End", icon: "backend.png", tasks: [programmingFront, outlets, screens, views, constraints])
//
//        // Embedded Eletronics
//        let design =  DatabaseTask(name: "Design", icon: "design.png")
//        let datasheet = DatabaseTask(name: "Datasheet", icon: "datasheet.png")
//        let schematic = DatabaseTask(name: "Schematic", icon: "schematic.png")
//        let prototyping = DatabaseTask(name: "Prototyping", icon: "prototyping.png")
//        let testing = DatabaseTask(name: "Testing", icon: "testing.png")
//        let layout = DatabaseTask(name: "Layout", icon: "layout.png")
//        let manufacture = DatabaseTask(name: "Manufacture", icon: "manufacture.png")
//        let assembly = DatabaseTask(name: "Assembly", icon: "assembly.png")
//
//        let embeddedEletronics = DatabaseSkill(name: "Embedded Electronics", icon: "embeddedEletronics.png", tasks: [design, datasheet, schematic, prototyping, testing, layout, manufacture, assembly])
//
//
//
//        // MARK: - Hustler
//
//
//        let Pesquisar =  DatabaseTask(name: "Pesquisar", icon: "Pesquisar.png")
//        let Benchmarking =  DatabaseTask(name: "Benchmarking", icon: "Benchmarking.png")
//        let Networking =  DatabaseTask(name: "Networking", icon: "Networking.png")
//        let thegift =  DatabaseTask(name: "The Gift", icon: "TheGift.png")
//
//        let Visão = DatabaseSkill(name: "Visão", icon: "Visão.png", tasks: [Pesquisar, Benchmarking, Networking, thegift])
//
//
//        let Speaker =  DatabaseTask(name: "Speaker", icon: "Speaker.png")
//        let Keynote =  DatabaseTask(name: "Keynote", icon: "Keynote.png")
//        let Idea =  DatabaseTask(name: "Idea", icon: "Idea.png")
//        let Storytelling =  DatabaseTask(name: "Storytelling", icon: "Storytelling.png")
//
//        let pitch = DatabaseSkill(name: "Pitch Elevator", icon: "PitchElevator.png", tasks: [Speaker, Keynote, Idea, Storytelling])
//
//
//        let BusinessCanvas =  DatabaseTask(name: "Business Canvas", icon: "BusinessCanvas.png")
//        let Audience =  DatabaseTask(name: "Audience", icon: "Audience.png")
//        let Precificação =  DatabaseTask(name: "Precificação", icon: "Precificação.png")
//        let Rededevalor =  DatabaseTask(name: "Rede de valor", icon: "Rede de valor.png")
//
//        let modelodenegocio = DatabaseSkill(name: "Modelo de Negócio", icon: "ModelodeNegócio.png", tasks: [BusinessCanvas, Benchmarking, Audience, Precificação, Rededevalor])
//
//
//        let DataMining =  DatabaseTask(name: "Data Mining", icon: "Data Mining.png")
//        let Pesquisa =  DatabaseTask(name: "Pesquisa", icon: "Pesquisa.png")
//        let DataAnalysis =  DatabaseTask(name: "Data Analysis", icon: "Data Analysis.png")
//        let Beachead =  DatabaseTask(name: "Beachead", icon: "Beachead.png")
//
//        let AnálisesEstatísticas = DatabaseSkill(name: "Análises Estatísticas", icon: "AnálisesEstatísticas.png", tasks: [DataMining, Pesquisa, DataAnalysis, Beachead])
//
//
//
//
//        // Create a JOB
//        let mvp = DatabaseJob(name: "Create a Minimal Viable Product (MVP)", icon: "mvp.png", hackerSkills: [backEnd, frontEnd, embeddedEletronics, modelling], hustlerSkills: [Visão, pitch, modelodenegocio, AnálisesEstatísticas], hipsterSkills: [naming, identidadevisual, ux, ui])
//
//        DatabaseAdmin.shared.saveJob(job: mvp)
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
