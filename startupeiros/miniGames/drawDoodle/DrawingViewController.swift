//
//  DrawingViewController.swift
//  startupeiros
//
//  Created by Maykon Meneghel on 30/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import UIKit
import Vision
import CoreML

class DrawingViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var currentEmojiLabel: UILabel!
    
    @IBOutlet weak var toDoCollectionView: UICollectionView!
    @IBOutlet weak var doneCollectionView: UICollectionView!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    var classification: String? = nil
    private var strokes: [CGMutablePath] = []
    private var currentStroke: CGMutablePath? { return strokes.last }
    private var imageViewSize: CGSize { return imageView.frame.size }
    private let classifier = Doodle_1()
    
    var todoEmojis: [String]! = []
    var doneEmojis: [String]! = []
    
    var currentGuess: String?
    var currentEmoji: String?
    
    var currentTimer: Int = 30
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.todoEmojis = getClasses().shuffled()
        
        self.setupToDoCollectionView()
        
        self.doneCollectionView.delegate = self
        self.doneCollectionView.dataSource = self
        
        undoButton.disable()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (_) in
            self.passEmoji()
            self.runTimer()
        }
    }
    
    func setupToDoCollectionView() {
       
        self.toDoCollectionView.delegate = self
        self.toDoCollectionView.dataSource = self
        
        self.toDoCollectionView.layer.borderWidth = 2
        self.toDoCollectionView.layer.borderColor = UIColor.gray.cgColor
        
        self.toDoCollectionView.layer.cornerRadius = self.toDoCollectionView.frame.height / 2
    }
    
    // MARK: - Timer methods
    
    func runTimer(){
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            self.updateTimerLabel()
            self.currentTimer -= 1
            
            if self.currentTimer == 0 {
                timer.invalidate()
                self.gameOver()
            }
        }
    }
    
    func updateTimerLabel() {
        self.timerLabel.text = "\(self.currentTimer)"
    }
    
    //MARK: - Game mechanics
    
    func gameOver() {
        print("GAME OVER BRO!")
        self.dismiss(animated: true, completion: nil)
    }
    
    func passEmoji() {
        let newEmoji = self.todoEmojis.removeFirst()
       
        self.currentEmoji = newEmoji
        
        self.currentEmojiLabel.text = classToEmoji(className: newEmoji)
        self.toDoCollectionView.deleteItems(at: [IndexPath(item: 0, section: 0)])
        
        self.toDoCollectionView.reloadData()
    }
    
    func checkMatch() {
        if self.currentGuess == self.currentEmoji {
            self.onMatch()
        }
    }
    
    func onMatch() {
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut], animations: {
            self.currentEmojiLabel.transform =
                self.currentEmojiLabel.transform.rotated(by:  2 * CGFloat.pi)
        }) { (_) in
            self.completeChallenge()
            self.passEmoji()
        }
    }
    
    func skip(){
        guard let currentEmoji = self.currentEmoji else { return }
        
        self.passEmoji()
        self.todoEmojis.append(currentEmoji)
        self.clear()
        self.toDoCollectionView.reloadData()
    }
    
    func completeChallenge() {
        self.clear()
        self.doneEmojis.append(self.currentEmoji!)
        self.doneCollectionView.reloadData()
    }
    
    // MARK: - CollectionView Delegate & Datasource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.toDoCollectionView {
            return self.todoEmojis.count
        }
        
        return doneEmojis.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "labelCell", for: indexPath) as! LabelCollectionViewCell
        
        var cellContent: String!
        
        if collectionView == self.toDoCollectionView {
            cellContent = self.todoEmojis[indexPath.item]
        } else {
            cellContent = self.doneEmojis[indexPath.item]
        }

        cell.label.text = classToEmoji(className: cellContent)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.size
        return CGSize(width: size.width * 0.1, height: size.height * 0.9)
    }
    
    
    // MARK: - Touches overrides
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        
        guard let touch = touches.first else { return }
        
        let newStroke = CGMutablePath()
        newStroke.move(to: touch.location(in: imageView))
        strokes.append(newStroke)
        refresh()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        
        guard let touch = touches.first,
            let currentStroke = self.currentStroke else {
                return
        }
        
        currentStroke.addLine(to: touch.location(in: imageView))
        refresh()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        
        guard let touch = touches.first,
            let currentStroke = self.currentStroke else {
                return
        }
        
        currentStroke.addLine(to: touch.location(in: imageView))
        refresh()
        
        self.classify()
    }
    
    // MARK: - Canvas related functions
    
    func undo() {
        let _ = strokes.removeLast()
        print("Undid")
        refresh()
    }
    
    func clear() {
        strokes = []
        classification = nil
        refresh()
    }
    
    func refresh() {
        if self.strokes.isEmpty { self.imageView.image = nil }
        
        let drawing = makeImage(from: self.strokes)
        self.imageView.image = drawing
        
        if classification != nil {
            undoButton.disable()
            clearButton.enable()
        } else if !strokes.isEmpty {
            undoButton.enable()
            clearButton.enable()
        } else {
            undoButton.disable()
            clearButton.disable()
        }
        
        classLabel.text = classification ?? ""
    }
    
    
    func makeImage(from strokes: [CGMutablePath]) -> UIImage? {
        let image = CGContext.create(size: imageViewSize) { context in
            context.setStrokeColor(UIColor.black.cgColor)
            context.setLineWidth(8.0)
            context.setLineJoin(.round)
            context.setLineCap(.round)
            
            for stroke in strokes {
                context.beginPath()
                context.addPath(stroke)
                context.strokePath()
            }
        }
        
        return image
    }
    
    func onPrediction(_ result: [PredictionResult]) {
        let ordered = result.sorted { (p1, p2) -> Bool in
            return p1.getConfidence() > p2.getConfidence()
        }
        
        guard let bestPrediction = ordered.first else { return }
        
        if bestPrediction.getIdentifier() == self.currentEmoji && bestPrediction.getConfidence() > 0.4 {
            self.currentGuess = bestPrediction.getIdentifier()
            self.classLabel.text = bestPrediction.getEmoji()
        }

        if bestPrediction.getConfidence() > 0.5 {
            self.currentGuess = bestPrediction.getIdentifier()
            self.classLabel.text = bestPrediction.getEmoji()
        } else {
            self.classLabel.text = "❓"
            print("Confidence is too low", bestPrediction.getIdentifier(), bestPrediction.getConfidence())
        }
        
        self.checkMatch()
    }
    
    func classify() {
        guard let image = self.imageView.image else { return }
        
        let rescaled = image.resize(to: CGSize(width: 299, height: 299))
        
        guard let grayScale = rescaled.applying(filter: .noir) else { return }
        
        guard let ciImage = CIImage(image: grayScale) else { return }
        
        if let model = try?  VNCoreMLModel(for: self.classifier.model) {
            
            let request = VNCoreMLRequest(model: model) {
                (vnrequest, error) in
                
                if let results = vnrequest.results as? [VNClassificationObservation] {
                    let mapped = results.map { (observation) -> PredictionResult in
                        return PredictionResult(observation.identifier, confidence: observation.confidence)
                    }
                    
                    self.onPrediction(mapped)
                }
                
            }
            
            let handler = VNImageRequestHandler(ciImage: ciImage)
            
            do{
                try handler.perform([request])
            } catch let error {
                print("Error performing request!", error)
            }
        }
    }
    
    // MARK: - Button callbacks
    
    @IBAction func onSkip(_ sender: Any) {
        self.skip()
    }
    @IBAction func onUndo(_ sender: Any) {
        self.undo()
    }
    @IBAction func onClear(_ sender: Any) {
        self.clear()
    }
}
