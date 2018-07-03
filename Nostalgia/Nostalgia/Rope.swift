//
//  Rope.swift
//  Nostalgia
//
//  Created by Vincenzo Ajello on 11/03/18.
//  Copyright © 2018 mskaline. All rights reserved.
//

import UIKit
import SpriteKit

enum RopeType:Int
{
    case standard = 0
    case attachable = 1
}

class Rope: SKSpriteNode
{
    let ropeTexture = SKTexture.init(image: UIImage.init(named: "Rope_Launch")!)
    let attachedRopeTexture = SKTexture.init(image: UIImage.init(named: "Rope_Attached")!)
    let ropeSize = CGSize.init(width: 10, height: 237)
    var isAttached = false
    var ropeLives = 4
    var type:RopeType
    
    init(type:RopeType)
    {
        self.type = type
        super.init(texture: ropeTexture, color: .clear, size: ropeSize)
        updatePhisicBody()
        
        if self.type == .attachable
        {
            startDegrading()
        }
    }
    
    func shoot(toY:CGFloat)
    {
        let moveAction = SKAction.moveTo(y:toY, duration: 1.0)
        
        switch type
        {
            case RopeType.standard:
                self.run(moveAction)
                {
                    self.isAttached = true
                    self.removeFromParent()
                }
            case RopeType.attachable:
                self.run(moveAction)
                {
                    self.texture = self.attachedRopeTexture
                    self.updatePhisicBody()
                    self.isAttached = true
                }
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
        
        self.physicsBody?.categoryBitMask = CategoryTypes.Rope.rawValue
        self.physicsBody?.collisionBitMask = CollisionTypes.None.rawValue
        self.physicsBody!.contactTestBitMask = CategoryTypes.Ball.rawValue
    }
    
    func startDegrading()
    {
        let pauser = SKAction.wait(forDuration: 1.0)
        let trigger = SKAction.perform(#selector(degrade), onTarget: self)
        let pauseThenTrigger = SKAction.sequence([ pauser, trigger ])
        let repeatForever = SKAction.repeatForever(pauseThenTrigger)
        self.run( repeatForever )
    }
    
    @objc func degrade()
    {
        let modifier = 1.0 / CGFloat(ropeLives)
        self.alpha = self.alpha - modifier
        ropeLives = ropeLives - 1
        if ropeLives <= 0
        {
            self.removeFromParent()
        }
    }
    
    required init?(coder aDecoder: NSCoder)
    {self.type = RopeType.standard; super .init(coder: aDecoder)}
}
