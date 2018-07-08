//
//  GameSKcene.swift
//  Nostalgia
//
//  Created by Vincenzo Ajello on 05/03/18.
//  Copyright © 2018 mskaline. All rights reserved.
//

import UIKit
import SpriteKit

protocol GameEventDelegate
{
    func GameOver(points:Int)
    func savePlayerScore(points:Int,nickName:String)
}

enum CategoryTypes:UInt32
{
    case Rect = 0b10            // 2
    case Ball = 0b100           // 4
    case Player = 0b1000       // 8
    case Rope = 0b10000          // 16
    case PowerUp = 0b100000     // 32
}

enum CollisionTypes:UInt32
{
    case None = 0b10            // 4
}

class GameSKcene: SKScene, SKJoystickDelegate,SKPhysicsContactDelegate
{
    var player:Player!
    var gameFrame:CGRect!
    var rope:Rope!
    
    var lives = 3
    var livesArray:[SKNode] = []
    var isGameOver = false
    
    var points:Int = 0
    var pointsLabel:SKLabelNode!
    
    var currentRopeType:RopeType!
    
    var gameDelegate:GameEventDelegate!
    
    override func didMove(to view: SKView)
    {
        self.backgroundColor = .clear
        
        currentRopeType = RopeType.init(rawValue: 0)
        
        gameFrame = CGRect.init(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        setupPointLabel()
        setupLives()
        
        self.physicsWorld.gravity = CGVector.init(dx: 0, dy: -3)
        self.physicsWorld.contactDelegate = self
        
        let borderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: frame.width, height: frame.height))
        //borderView.center = (self.view?.center)!
        borderView.layer.borderColor = UIColor.white.cgColor
        borderView.layer.borderWidth = 2
        borderView.layer.cornerRadius = 2
        self.view?.addSubview(borderView)
        
        // Prepare physic frame
        let borders = SKSpriteNode.init(color: .clear, size: gameFrame.size)
        borders.position = CGPoint.init(x: 0, y: 0)
        borders.zPosition = 1
        
        // Set physics
        let rectPath = UIBezierPath.init(rect: CGRect.init(x:0, y:0, width: gameFrame.width, height: gameFrame.height))
        let pBody = SKPhysicsBody(edgeLoopFrom: rectPath.cgPath)
        self.physicsBody = pBody
        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.usesPreciseCollisionDetection = true
        self.physicsBody!.isDynamic = false
        self.physicsBody!.mass = 0
        self.physicsBody!.friction = 0
        self.physicsBody!.linearDamping = 0
        self.physicsBody!.angularDamping = 0
        self.physicsBody!.restitution = 0.988

        self.physicsBody!.categoryBitMask = CategoryTypes.Rect.rawValue
        self.physicsBody!.collisionBitMask = CollisionTypes.None.rawValue
        
        self.addChild(borders)
        addPlayer()

        let wait = SKAction.wait(forDuration: 15)
        let run = SKAction.run { self.addBall() }
        let sequence = SKAction.sequence([run,wait])
        let forever = SKAction.repeatForever(sequence)
        self.run(forever)
        
        //addBall()
    }
    
    
    func addPlayer()
    {
        player = Player.init()
        player.position = CGPoint.init(x: self.frame.midX, y: player.playerSize.height/2)
        self.addChild(player)
        
        spawnPowerUp(position: nil)
     }
    
    func addBall()
    {
        let ball = Ball.init(type:BallType.big)
        
        let randomX = arc4random_uniform(UInt32((self.frame.size.width-ball.size.width)-ball.size.width)) + UInt32(ball.size.width)
        
        ball.position = CGPoint.init(x: CGFloat(randomX), y: self.frame.size.height)
        self.addChild(ball)
        
        let moveTargets = SKAction.moveTo(y: gameFrame.size.height - ball.size.height, duration: 2.0)
        ball.run(moveTargets)
        
        self.perform(#selector(enableBall(ball:)), with: ball, afterDelay: 2.2)
    }
    
    @objc func enableBall(ball:SKNode)
    {
        let rnd = arc4random_uniform(10)
        var dx:CGFloat = -100
        if rnd % 2 == 0
        {dx = 100}
        
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.velocity.dx = dx
    }
    
    
    func shoot()
    {
        if self.isGameOver == true { return }
        
        if rope != nil
        {
            if rope.isAttached == false { print("rope is not yet attached"); return }
            
            switch rope.type
            {
                case RopeType.standard:
                    print("standard rope type")
                
                case RopeType.attachable:
                    if rope.isAttached == false
                    {
                        return
                    }
                    if rope.ropeLives <= 0
                    {
                        rope.removeFromParent()
                    }
                    else
                    {
                        rope.degrade()
                        return
                    }
                case RopeType.double:
                    var x = 0
                    for node in self.children
                    {
                        if node.name == "rope"
                        {
                            x = x + 1
                        }
                    }
                    if x >= 2 {return}

                case RopeType.rifle:
                    print("rifle rope tiype")
            }
        }
        
        rope = Rope.init(type:currentRopeType)
        
        var x = player.position.x - 8
        var y = -gameFrame.height/2
        var target = (gameFrame.height / 2) - 24
        
        if player.flipFloat > 0
        {x = player.position.x + 8}
        
        if rope.type == .rifle
        {y = player.size.height
        target = gameFrame.height}
        
        rope.position = CGPoint.init(x: x, y: y)
        rope.name = "rope"
        self.addChild(rope)
        
        rope.shoot(toY: target)

    }
    

    
    
    
    func joystickUpdatedDirection(sender: AnyObject)
    {
        if self.isGameOver == true {return}
        let stick = sender as! SKJoystick
        player.direction = stick.direction
    }
    
    func joystickReleased(sender: AnyObject)
    {
        player.direction = nil
    }
    
    func joystickButtonPressed(sender: AnyObject)
    {
        shoot()
    }
    
    func didBegin(_ contact: SKPhysicsContact)
    {
        checkCollisions(a: contact.bodyA, b: contact.bodyB)
    }
    
    func checkCollisions(a:SKPhysicsBody,b:SKPhysicsBody)
    {
        if (a.contactTestBitMask == 32 && b.contactTestBitMask == 8)
        {
            hit()
            return
        }
        
        if (a.contactTestBitMask == 32 && b.contactTestBitMask == 0)
        {
            pickPowerUp(pup: b.node!)
            return
        }
        
        if (a.contactTestBitMask == 4 && b.contactTestBitMask == 8)
        {
            ropeHitten(r:a.node!, ball: b.node!)
            return
        }

        print("# contact between A : \(a.contactTestBitMask)")
        print("and B : \(b.contactTestBitMask)")
    }
    
    func hit()
    {
        if self.isGameOver == true {return}
        if player.isBlinkng == true { return }
        
        // lives = lives - 1
        
        if lives < 0
        {
            gameOver()
            return
        }
        
        //livesArray[0].removeFromParent()
        //livesArray.remove(at: 0)
        
        player.blink()
    }
    
    func ropeHitten(r:SKNode, ball:SKNode)
    {
        if self.isGameOver == true {return}
        
        //print("ROPE WAS HITTEN")
        r.removeFromParent()
        rope = nil
        let b = ball as! Ball
        self.addPoints(pointsToAdd: b.pointsValue)
        ball.removeFromParent()
        if b.type != BallType.small
        {splitBalls(splitPostion: ball.position, ballType:b.type)}
    }
    
    func splitBalls(splitPostion:CGPoint, ballType:BallType)
    {
        spawnPowerUp(position: splitPostion)
        
        let nextType = nextBallType(currentType: ballType)
        let ballA = Ball.init(type: nextType)
        let ballB = Ball.init(type: nextType)

        ballA.position = CGPoint.init(x: splitPostion.x-(ballA.size.width/2), y: splitPostion.y)
        ballB.position = CGPoint.init(x: splitPostion.x+(ballA.size.width/2), y: splitPostion.y)

        self.addChild(ballA)
        self.addChild(ballB)
        
        ballA.physicsBody?.isDynamic = true
        ballB.physicsBody?.isDynamic = true
        
        ballA.physicsBody?.velocity.dx = -100
        ballB.physicsBody?.velocity.dx = 100
        ballA.physicsBody?.velocity.dy = 150
        ballB.physicsBody?.velocity.dy = 150
    }
    
    // MARK: Render Loop
    override func update(_ currentTime: TimeInterval)
    {
        guard let dir = player.direction else { return }
        moveToDirection(direction:dir)
    }
    
    func moveToDirection(direction:Sense)
    {
        if direction == Sense.LEFT || direction == Sense.UP_LEFT || direction == Sense.DOWN_LEFT
        {
            // move player left
            if player.position.x <= player.size.width - 7 { return }
            player.move(amount: -2)
        }
        if direction == Sense.RIGHT || direction == Sense.UP_RIGHT || direction == Sense.DOWN_RIGHT
        {
            // move player right
            if player.position.x >= self.gameFrame.width - player.size.width + 7 { return }
            player.move(amount: 2)
        }
    }
    
    func nextBallType(currentType:BallType) -> BallType
    {
        var nextType = currentType
        switch currentType
        {
            case BallType.big:
                nextType = BallType.large
            case BallType.large:
                nextType = BallType.medium
            case BallType.medium:
                nextType = BallType.small
            case BallType.small:
                nextType = BallType.small
        }
        return nextType
    }
    
    func setupLives()
    {
        let lifeTexture = SKTexture.init(image: UIImage.init(named: "heart")!)
        let spaceMod:CGFloat = 20
        for i in 1...lives
        {
            let life = SKSpriteNode.init(color: .clear, size: CGSize.init(width: 15, height: 15))
            life.texture = lifeTexture
            life.position = CGPoint.init(x: gameFrame.width - (spaceMod*CGFloat(i)), y: gameFrame.height - spaceMod)
            life.zPosition = 1
            self.addChild(life)
            
            livesArray.append(life)
        }
        livesArray = livesArray.reversed()
    }
    
    func setupPointLabel()
    {
        pointsLabel = SKLabelNode(fontNamed: "Pixel-Art")
        self.addPoints(pointsToAdd: 0)
        pointsLabel.position = CGPoint(x: 10, y: gameFrame.height - 10)
        pointsLabel.fontColor = UIColor.white
        pointsLabel.horizontalAlignmentMode = .left
        pointsLabel.verticalAlignmentMode = .top
        pointsLabel.fontSize = 16
        pointsLabel.zPosition = 2
        self.addChild(pointsLabel)
    }
    
    func addPoints(pointsToAdd:Int)
    {
        points = points + pointsToAdd
        pointsLabel.text = "Score: \(points)"
    }
    
    func gameOver()
    {
        self.isGameOver = true
        self.physicsWorld.speed = 0.05
        if self.rope != nil { self.rope.removeFromParent()}
        self.perform(#selector(terminateGame), with: nil, afterDelay: 2)
        player.blink()
    }
    
    @objc func terminateGame()
    {
        self.isPaused = true
        guard let _ = gameDelegate?.GameOver(points: points) else {return}
    }
}



extension GameSKcene
{
    func pickPowerUp(pup:SKNode)
    {
        let powerUp = pup as! PowerUp
        print("powerup picked \(powerUp.type)")
        
        switch powerUp.type
        {
            case PowerUps.standardWeapon:
                currentRopeType = RopeType.standard
            case PowerUps.attachableWeapon:
                currentRopeType = RopeType.attachable
            case PowerUps.doubleWeapon:
                currentRopeType = RopeType.double
            case PowerUps.rifleWeapon:
                currentRopeType = RopeType.rifle
        }
        powerUp.removeFromParent()
    }
    
    func spawnPowerUp(position:CGPoint!)
    {
        let rndPowerUpSpawn = arc4random_uniform(10)
        if rndPowerUpSpawn < 8
        {
            return
        }
        
        let rndPowerUp = arc4random_uniform(4)
        let rpup = PowerUps.init(rawValue: rndPowerUp)
        print("Spawn \(String(describing: rpup))")

        let powerUp = PowerUp.init(type: rpup!)
        
        if position == nil
        {
            // calculate random position
            let y = gameFrame.height - powerUp.size.height / 2
            let minX:CGFloat = powerUp.size.width
            let maxX:CGFloat = gameFrame.width - powerUp.size.width
            let rndX:CGFloat = CGFloat(arc4random_uniform(UInt32(maxX - minX)) + UInt32(minX))
            powerUp.position = CGPoint.init(x: rndX, y: y)
        }
        else { powerUp.position = position }
        
        self.addChild(powerUp)
        powerUp.fall(fromYPosition: powerUp.frame.origin.y)
    }
}
