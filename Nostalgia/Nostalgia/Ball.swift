
//
//  Ball.swift
//  Nostalgia
//
//  Created by Vincenzo Ajello on 11/03/18.
//  Copyright © 2018 mskaline. All rights reserved.
//

import UIKit
import SpriteKit

enum BallType:CGFloat
{
    case small = 0.5
    case medium = 0.6
    case large = 0.7
    case big = 0.8
}

class Ball: SKSpriteNode
{
    var type:BallType!
    var ballTexture:SKTexture!
    var pointsValue = 0

    init(type:BallType)
    {
        self.type = type
        switch self.type!
        {
            case BallType.big:
                self.ballTexture = SKTexture.init(image: UIImage.init(named: "Ball_Big")!)
                self.pointsValue = 10
            case BallType.large:
                self.ballTexture = SKTexture.init(image: UIImage.init(named: "Ball_Large")!)
                self.pointsValue = 25
            case BallType.medium:
                self.ballTexture = SKTexture.init(image: UIImage.init(named: "Ball_Medium")!)
                self.pointsValue = 50
            case BallType.small:
                self.ballTexture = SKTexture.init(image: UIImage.init(named: "Ball_Small")!)
                self.pointsValue = 100
        }
        
        let ballSize = CGSize.init(width: ballTexture.size().width*self.type.rawValue, height: ballTexture.size().height*self.type.rawValue)
        super.init(texture: self.ballTexture, color: .clear, size: ballSize)
        
        self.alpha = 0.9
        self.zPosition = 1
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: ballSize.width/2)
        self.physicsBody!.affectedByGravity = true
        self.physicsBody!.restitution = 0
        self.physicsBody!.linearDamping = -0.001
        self.physicsBody!.angularDamping = 0
        self.physicsBody!.friction = 0
        self.physicsBody?.isDynamic = false
        self.physicsBody!.mass = 0.001
        self.physicsBody!.allowsRotation = false
        
        self.physicsBody!.categoryBitMask = CategoryTypes.Ball.rawValue
        self.physicsBody?.collisionBitMask = CollisionTypes.None.rawValue
        self.physicsBody!.contactTestBitMask = CategoryTypes.Player.rawValue
    }
    
    /*
    func checkSplit()
    {
        switch ballType!
        {
            case BallType.big:
                split(to: BallType.large)
            case BallType.large:
                split(to: BallType.medium)
            case BallType.medium:
                split(to: BallType.small)
            case BallType.small:
                print("DESTORY BALL")
        }
    }
    
    func split(to:BallType)
    {
        print("Split to (\to)")
        self.ballType = to
        let ballSize = CGSize.init(width: startSize*to.rawValue, height: startSize*to.rawValue)
        self.scale(to:ballSize)
    }
    */

    required init?(coder aDecoder: NSCoder)
    {super.init(coder: aDecoder)}
}
