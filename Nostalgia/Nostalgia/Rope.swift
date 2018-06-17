//
//  Rope.swift
//  Nostalgia
//
//  Created by Vincenzo Ajello on 11/03/18.
//  Copyright © 2018 mskaline. All rights reserved.
//

import UIKit
import SpriteKit

class Rope: SKSpriteNode
{
    let ropeTexture = SKTexture.init(image: UIImage.init(named: "Rope_Launch")!)
    let attachedRopeTexture = SKTexture.init(image: UIImage.init(named: "Rope_Attached")!)
    let ropeSize = CGSize.init(width: 10, height: 237)
    var isAttached = false
    
    init()
    {
        super.init(texture: ropeTexture, color: .clear, size: ropeSize)
        updatePhisicBody()
    }
    
    func shoot(toY:CGFloat)
    {
        let moveAction = SKAction.moveTo(y:toY, duration: 1.0)
        self.run(moveAction)
        {
            self.texture = self.attachedRopeTexture
            self.updatePhisicBody()
            self.isAttached = true
        }
    }
    
    func updatePhisicBody()
    {
        self.physicsBody = SKPhysicsBody.init(texture: self.texture!, size: self.size)
        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.restitution = 0
        self.physicsBody!.linearDamping = 0
        self.physicsBody!.angularDamping = 0
        self.physicsBody!.friction = 0
        self.physicsBody?.isDynamic = false
        self.physicsBody!.mass = 1.0
        self.physicsBody!.allowsRotation = false
        self.physicsBody!.categoryBitMask = CollisionTypes.Rope.rawValue
        self.physicsBody!.contactTestBitMask = CollisionTypes.Rope.rawValue
        self.physicsBody!.collisionBitMask = CollisionTypes.Rope.rawValue
    }
    
    required init?(coder aDecoder: NSCoder)
    {super .init(coder: aDecoder)}
}
