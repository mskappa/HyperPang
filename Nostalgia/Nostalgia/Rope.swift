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
    case double = 2
    case rifle = 3
}

class Rope: SKSpriteNode
{
    
    
    let attachable_rope_texture = SKTexture.init(image: UIImage.init(named: "Rope_Launch")!)
    let attachable_rope_attached_texture = SKTexture.init(image: UIImage.init(named: "Rope_Attached")!)
    let rifle_rope_texture = SKTexture.init(image: UIImage.init(named: "LaserRay")!)
    let standard_rope_size = CGSize.init(width: 10, height: 237)
    let rifle_rope_size = CGSize.init(width: 10, height: 10)
    var isAttached = false
    var ropeLives = 4
    var type:RopeType
    
    init(type:RopeType)
    {
        self.type = .double
        
        var texture:SKTexture!
        var size:CGSize!
        switch self.type
        {
            case RopeType.standard:
                texture = attachable_rope_texture
                size = standard_rope_size
            case RopeType.attachable:
                texture = attachable_rope_texture
                size = standard_rope_size
            case RopeType.double:
                texture = attachable_rope_texture
                size = standard_rope_size
            case RopeType.rifle:
                texture = rifle_rope_texture
                size = rifle_rope_size
        }
        
        super.init(texture: texture, color: .clear, size: size)
        
        if self.type == .attachable
        {
            startDegrading()
        }
        
        updatePhisicBody()
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
                    self.texture = self.attachable_rope_attached_texture
                    self.updatePhisicBody()
                    self.isAttached = true
                }
            case RopeType.double:
                print("Shoot whit double rifle")
                self.isAttached = true
                self.run(moveAction)
                {
                    self.texture = self.attachable_rope_attached_texture
                    self.updatePhisicBody()
                }
            
            case RopeType.rifle:
                self.isAttached = true
                moveAction.duration = 0.5
                self.run(moveAction)
                {
                    self.removeFromParent()
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
