//
//  FlappyGameScene.swift
//  startupeiros
//
//  Created by Maykon Meneghel on 28/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import SpriteKit

class FlappyGameScene: SKScene, SKPhysicsContactDelegate{
    let verticalPipeGap = 150.0
    
    var bird:SKSpriteNode!
    var skyColor:SKColor!
    var pipeTextureUp:SKTexture!
    var pipeTextureDown:SKTexture!
    var movePipesAndRemove:SKAction!
    var moving:SKNode!
    var pipes:SKNode!
    var canRestart = Bool()
    var scoreLabelNode:SKLabelNode!
    var score = NSInteger()
    
    let birdCategory: UInt32 = 1 << 0
    let worldCategory: UInt32 = 1 << 1
    let pipeCategory: UInt32 = 1 << 2
    let scoreCategory: UInt32 = 1 << 3
    var verticalMove: Float = 0
    
    override func didMove(to view: SKView) {
        canRestart = true
        
        // setup physics
        self.physicsWorld.gravity = CGVector( dx: 0.0, dy: -4.0 )
        self.physicsWorld.contactDelegate = self
        
        // setup background color
        skyColor = SKColor(red: 45.0/255.0, green: 49.0/255.0, blue: 77.0/255.0, alpha: 1.0)
        self.backgroundColor = skyColor
        
        moving = SKNode()
        self.addChild(moving)
        pipes = SKNode()
        moving.addChild(pipes)
        
        // ground
//        let groundTexture = SKTexture(image: (UIImage(named: "land")?.maskWithColor(color: UIColor(red: 45.0/255.0, green: 49.0/255.0, blue: 77.0/255.0, alpha: 1.0))!)!)
//        let groundTexture = SKTexture(imageNamed: "land")
//
//
//        groundTexture.filteringMode = .nearest // shorter form for SKTextureFilteringMode.Nearest
//
//        let moveGroundSprite = SKAction.moveBy(x: -groundTexture.size().width * 2.0, y: 0, duration: TimeInterval(0.02 * groundTexture.size().width * 2.0))
//        let resetGroundSprite = SKAction.moveBy(x: groundTexture.size().width * 2.0, y: 0, duration: 0.0)
//        let moveGroundSpritesForever = SKAction.repeatForever(SKAction.sequence([moveGroundSprite,resetGroundSprite]))
////
//        for i in 0 ..< 2 + Int(self.frame.size.width / ( groundTexture.size().width * 2 )) {
//            let i = CGFloat(i)
//            let sprite = SKSpriteNode(texture: groundTexture)
//            sprite.setScale(1.0)
//            sprite.position = CGPoint(x: i * sprite.size.width, y: sprite.size.height)
//            sprite.run(moveGroundSpritesForever)
//            moving.addChild(sprite)
//        }
        
        // skyline
        let skyTexture = SKTexture(imageNamed: "sky2")
        skyTexture.filteringMode = .nearest
        
        let moveSkySprite = SKAction.moveBy(x: -skyTexture.size().width * 2.0, y: 0, duration: TimeInterval(0.1 * skyTexture.size().width * 2.0))
        let resetSkySprite = SKAction.moveBy(x: skyTexture.size().width * 2.0, y: 0, duration: 0.0)
        let moveSkySpritesForever = SKAction.repeatForever(SKAction.sequence([moveSkySprite,resetSkySprite]))
        
//        for i in 0 ..< 2 + Int(self.frame.size.width / ( skyTexture.size().width * 2 )) {
//            let i = CGFloat(i)
//            let sprite = SKSpriteNode(texture: skyTexture)
//            sprite.setScale(1.0)
//            sprite.zPosition = -20
//            sprite.position = CGPoint(x: i * sprite.size.width, y: sprite.size.height / 2.0 + groundTexture.size().height * 2.0)
//            sprite.run(moveSkySpritesForever)
//            moving.addChild(sprite)
//        }
        
        // create the pipes textures
        pipeTextureUp = SKTexture(imageNamed: "maoegrana")
        pipeTextureUp.filteringMode = .nearest
        pipeTextureDown = SKTexture(imageNamed: "PipeDown")
        pipeTextureDown.filteringMode = .nearest
        
        // create the pipes movement actions
        let distanceToMove = CGFloat(self.frame.size.width + 2.0 * pipeTextureUp.size().width)
        let movePipes = SKAction.moveBy(x: -distanceToMove, y:0.0, duration:TimeInterval(0.01 * distanceToMove))
        let removePipes = SKAction.removeFromParent()
        movePipesAndRemove = SKAction.sequence([movePipes, removePipes])
        
        // spawn the pipes
        let spawn = SKAction.run(spawnPipes)
        let delay = SKAction.wait(forDuration: TimeInterval(2.0))
        let spawnThenDelay = SKAction.sequence([spawn, delay])
        let spawnThenDelayForever = SKAction.repeatForever(spawnThenDelay)
        self.run(spawnThenDelayForever)
        
        // setup our bird
        let birdTexture1 = SKTexture(imageNamed: "mala")
        birdTexture1.filteringMode = .nearest
        let birdTexture2 = SKTexture(imageNamed: "mala")
        birdTexture2.filteringMode = .nearest
        
        let anim = SKAction.animate(with: [birdTexture1, birdTexture2], timePerFrame: 0.2)
        let flap = SKAction.repeatForever(anim)
        
        bird = SKSpriteNode(texture: birdTexture1)
        bird.setScale(0.5)
        bird.position = CGPoint(x: self.frame.size.width / 2.5, y: self.frame.midY)
        bird.run(flap)
        
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.height / 2.0)
        bird.physicsBody?.isDynamic = true
        bird.physicsBody?.allowsRotation = false
        
        bird.physicsBody?.categoryBitMask = birdCategory
        bird.physicsBody?.collisionBitMask = worldCategory | pipeCategory
        bird.physicsBody?.contactTestBitMask = worldCategory | pipeCategory
        
        self.addChild(bird)
        
        // create the ground
        
        let ground = SKShapeNode(rectOf: CGSize(width: self.frame.size.width, height: self.frame.size.height * 0.1))
        ground.fillColor = .clear
        ground.strokeColor = .clear
        ground.position = CGPoint(x: 0, y: self.frame.size.height * 0.1)
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.size.width, height: self.frame.size.height * 0.1))
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.categoryBitMask = worldCategory
        ground.name = "ground"
        self.addChild(ground)
        
        
        // create the ceiling
        
        let ceiling = SKShapeNode(rectOf: CGSize(width: self.frame.size.width, height: self.frame.size.height * 0.1))
        
        ceiling.fillColor = .clear
        ceiling.strokeColor = .clear
        ceiling.position = CGPoint(x: 0, y: self.frame.size.height * 0.9)
        ceiling.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.size.width, height: self.frame.size.height * 0.1))
        ceiling.physicsBody?.isDynamic = false
        ceiling.physicsBody?.categoryBitMask = worldCategory
        ceiling.name = "ceiling"
        self.addChild(ceiling)
        
        // Initialize label and create a label which holds the score
        score = 0
        scoreLabelNode = SKLabelNode(fontNamed: UIFont.boldSystemFont(ofSize: 24).fontName)
        scoreLabelNode.fontColor = .white

        scoreLabelNode.fontSize = 40
        scoreLabelNode.position = CGPoint( x: self.frame.width * 0.6, y: self.frame.height * 0.05)
        scoreLabelNode.zPosition = 100
        self.updateScoreLabel()
        self.addChild(scoreLabelNode)
        
    }
    
    var modifiedScore: Double! = 0
    func updateScoreLabel() {
        self.modifiedScore += Double(self.score)
        modifiedScore = (Double(modifiedScore) + (0.05 * Double(modifiedScore)).rounded(toPlaces: 2))
        scoreLabelNode.text = "USD \(modifiedScore.rounded(toPlaces: 2))"
    }
    
    func spawnPipes() {
        let pipePair = SKNode()
        pipePair.position = CGPoint( x: self.frame.size.width + pipeTextureUp.size().width * 2, y: 0 )
        pipePair.zPosition = -10
        
        let height = UInt32( self.frame.size.height / 4)
        let y = Double(arc4random_uniform(height) + height)
        
        let pipeUp = SKSpriteNode(texture: pipeTextureUp)
        pipeUp.setScale(0.5)
        pipeUp.position = CGPoint(x: 0.0, y: y)
        pipeUp.zRotation = 0
        pipeUp.name = "pipeUp"
        
        pipeUp.physicsBody = SKPhysicsBody(rectangleOf: pipeUp.size)
        pipeUp.physicsBody?.isDynamic = false
        pipeUp.physicsBody?.categoryBitMask = pipeCategory
        pipeUp.physicsBody?.contactTestBitMask = birdCategory
        pipePair.addChild(pipeUp)
        
        
        let pipeDown = (pipeUp.copy() as! SKSpriteNode)
        
        pipeUp.name = "pipeDown"
        pipeUp.zRotation = .pi
        pipeDown.position = CGPoint(x: 0.0, y: y + Double(pipeDown.size.height) + verticalPipeGap)
        
        pipeDown.physicsBody = SKPhysicsBody(rectangleOf: pipeDown.size)
        pipeDown.physicsBody?.isDynamic = false
        pipeDown.physicsBody?.categoryBitMask = pipeCategory
        pipeDown.physicsBody?.contactTestBitMask = birdCategory
        pipePair.addChild(pipeDown)
        
        
        let contactNode = SKNode()
        contactNode.position = CGPoint( x: pipeDown.size.width + bird.size.width / 2, y: self.frame.midY )
        contactNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize( width: pipeUp.size.width, height: self.frame.size.height ))
        contactNode.physicsBody?.isDynamic = false
        contactNode.physicsBody?.categoryBitMask = scoreCategory
        contactNode.physicsBody?.contactTestBitMask = birdCategory
        pipePair.addChild(contactNode)
        
        pipePair.run(movePipesAndRemove)
        pipes.addChild(pipePair)
        
    }
    
    func resetScene (){
        // Move bird to original position and reset velocity
        bird.position = CGPoint(x: self.frame.size.width / 2.5, y: self.frame.midY)
        bird.physicsBody?.velocity = CGVector( dx: 0, dy: 0 )
        bird.physicsBody?.collisionBitMask = worldCategory | pipeCategory
        bird.speed = 1.0
        bird.zRotation = 0.0
        
        // Remove all existing pipes
        pipes.removeAllChildren()
        
        // Reset _canRestart
        canRestart = false
        
        // Reset score
        score = 0
        scoreLabelNode.text = String(score)
        
        // Restart animation
        moving.speed = 1
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if moving.speed > 0  {
            for _ in touches { // do we need all touches?
                bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 10))
            }
        } else if canRestart {
            self.resetScene()
        }
    }
    var hasStarted: Bool! = false
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        
        if self.hasStarted {
            let value = bird.physicsBody!.velocity.dy * ( bird.physicsBody!.velocity.dy < 0 ? 0.003 : 0.001 )
            bird.zRotation = min( max(-1, value), 0.5 )
        }
    }
    var currentHands: SKNode?
    func updateHands() {
        if let curr = self.currentHands {
            curr.removeFromParent()
        }
        
        let currentHands = self.pipes.children.first!
        guard let up = currentHands.childNode(withName: "pipeUp") else { return }
        guard let down = currentHands.childNode(withName: "pipeDown") else { return }
        

        let upTexture = SKTexture(imageNamed: "mao")
        upTexture.filteringMode = .nearest
        
        
        let upAction = SKAction.setTexture(upTexture)
        
            
        up.run(upAction)
        down.run(upAction)
        
        self.currentHands = currentHands
    }
    var vc: MiniGameViewController!
    func gameOver() {
        self.vc.onGameOver(self.modifiedScore)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if contact.bodyA.categoryBitMask == self.worldCategory || contact.bodyB.categoryBitMask == self.worldCategory { return }
        if moving.speed > 0 {
            if ( contact.bodyA.categoryBitMask & scoreCategory ) == scoreCategory || ( contact.bodyB.categoryBitMask & scoreCategory ) == scoreCategory {
                // Bird has contact with score entity
                score += 1
                self.updateScoreLabel()
                
                self.updateHands()
                // Add a little visual feedback for the score increment
                scoreLabelNode.run(SKAction.sequence([SKAction.scale(to: 1.5, duration:TimeInterval(0.1)), SKAction.scale(to: 1.0, duration:TimeInterval(0.1))]))
                
            } else {
                
                moving.speed = 0
                
                bird.physicsBody?.collisionBitMask = worldCategory
                bird.run(  SKAction.rotate(byAngle: CGFloat(Double.pi) * CGFloat(bird.position.y) * 0.01, duration:1), completion:{self.bird.speed = 0 })
                self.gameOver()
                
                // Flash background if contact is detected
//                self.removeAction(forKey: "flash")
//                self.run(SKAction.sequence([SKAction.repeat(SKAction.sequence([SKAction.run({
//                    self.backgroundColor = SKColor(red: 1, green: 0, blue: 0, alpha: 1.0)
//                    }),SKAction.wait(forDuration: TimeInterval(0.05)), SKAction.run({
//                        self.backgroundColor = self.skyColor
//                        }), SKAction.wait(forDuration: TimeInterval(0.05))]), count:4), SKAction.run({
//                            self.canRestart = true
//                            })]), withKey: "flash")
            }
        }
    }
}
