//
//  PowerUp.swift
//  Nostalgia
//
//  Created by msk on 03/07/18.
//  Copyright © 2018 mskaline. All rights reserved.
//

import UIKit
import SpriteKit

enum PowerUps:UInt32
{
    case standardWeapon = 0
    case attachableWeapon = 1
    //case rifleWeapon = 2
    //case barrier = 3
    //case bomb = 4
    //case timeFreezed = 5
    //case timeSlowed = 6
    //case life = 7
}


class PowerUp: SKSpriteNode
{
    var type:PowerUps
    var lifeSeconds:Int = 7
    
    init(type:PowerUps)
    {
        self.type = type
        let pupSize = CGSize.init(width: 13, height: 13)
        
        var textureImage = UIImage.init()
        switch type
        {
            case PowerUps.standardWeapon:
                textureImage = UIImage.init(named: "PowerUp_Standard")!
            case PowerUps.attachableWeapon:
                textureImage = UIImage.init(named: "PowerUp_Attachable")!
        }
        
        let pupTexture = SKTexture.init(image: textureImage)
        super.init(texture: pupTexture, color: .white, size: pupSize)
        
        self.alpha = 0.9
        self.zPosition = 1
        
        self.physicsBody = SKPhysicsBody.init(rectangleOf: self.size)
        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.restitution = 0
        self.physicsBody!.linearDamping = 0
        self.physicsBody!.angularDamping = 0
        self.physicsBody!.friction = 0
        self.physicsBody?.isDynamic = true
        self.physicsBody!.mass = 0
        self.physicsBody!.allowsRotation = false
    
        self.physicsBody?.categoryBitMask = CategoryTypes.PowerUp.rawValue
        self.physicsBody?.collisionBitMask = CollisionTypes.None.rawValue
        //self.physicsBody!.contactTestBitMask = CategoryTypes.Player.rawValue
        
        self.startDegrading()
    }
    
    func fall()
    {
        self.blinkTwoSeconds()
        let moveAction = SKAction.moveTo(y:(self.size.height/2)+2, duration: 2.0)
        self.run(moveAction)
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
        lifeSeconds = lifeSeconds - 1
        if lifeSeconds == 2
        {
            self.blinkTwoSeconds()
        }
        if lifeSeconds <= 0
        {
            self.removeFromParent()
        }
    }
    
    func blinkTwoSeconds()
    {
        let blink = SKAction.sequence([SKAction.fadeAlpha(to: 0, duration: 0.5),
                                       SKAction.fadeAlpha(to: 1, duration: 0.5),
                                       SKAction.fadeAlpha(to: 0, duration: 0.5),
                                       SKAction.fadeAlpha(to: 1, duration: 0.5)])
        self.run(blink)
    }
    
    required init?(coder aDecoder: NSCoder)
    { self.type = PowerUps.standardWeapon; super.init(coder: aDecoder) }
}
