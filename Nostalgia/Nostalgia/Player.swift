
//
//  Player.swift
//  Nostalgia
//
//  Created by Vincenzo Ajello on 10/03/18.
//  Copyright © 2018 mskaline. All rights reserved.
//

import UIKit
import SpriteKit

class Player: SKSpriteNode
{
    let playerSize = CGSize.init(width: 20, height: 29)
    let playerTexture = SKTexture.init(image: UIImage.init(named: "Player")!)
    var isBlinkng = false
    var direction:Sense!
    var flipFloat:CGFloat = -2
    
    init()
    {
        super.init(texture: playerTexture, color: .clear, size: playerSize)
                
        self.texture = playerTexture
        self.alpha = 0.9
        self.zPosition = 1
        
        // Set physics
        self.physicsBody = SKPhysicsBody.init(texture: playerTexture, size: playerSize)
        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.restitution = 0
        self.physicsBody!.linearDamping = 0
        self.physicsBody!.angularDamping = 0
        self.physicsBody!.friction = 0
        self.physicsBody?.isDynamic = false
        self.physicsBody!.mass = 0
        self.physicsBody!.allowsRotation = false
        
        self.physicsBody?.categoryBitMask = CategoryTypes.Player.rawValue
        self.physicsBody?.collisionBitMask = CollisionTypes.None.rawValue
        self.physicsBody!.contactTestBitMask = CategoryTypes.PowerUp.rawValue
    }
    
    func move(amount:CGFloat)
    {        
        flipDirection(amount: amount)
        let newPosition = self.position.x + amount
        self.position.x = newPosition
    }
    
    func flipDirection(amount:CGFloat)
    {
        if amount == flipFloat {return}
        flipFloat = amount
        self.xScale = self.xScale * -1
    }
    
    func blink()
    {
        self.alpha = 0.7
        self.isBlinkng = true
        let alpha_texture = SKTexture.init(image: UIImage.init(named: "AlphaPlayer")!)
        let textureArray:[SKTexture] = [alpha_texture,self.playerTexture]
        let blinkAction = SKAction.animate(with: textureArray, timePerFrame: 0.2)
        let alphaBlinksAction = SKAction.repeat(blinkAction, count: 5)
        self.run(alphaBlinksAction, completion: {
            
            self.isBlinkng = false
            self.alpha = 0.9
        })
    }
    
    required init?(coder aDecoder: NSCoder)
    {super.init(coder: aDecoder)}
}
