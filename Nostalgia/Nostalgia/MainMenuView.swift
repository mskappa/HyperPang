
//
//  MainMenuView.swift
//  Nostalgia
//
//  Created by Vincenzo Ajello on 07/03/18.
//  Copyright © 2018 mskaline. All rights reserved.
//

import UIKit

enum SelectedOption
{
    case newGame
    case leaderboard
    case quit
}

protocol MainMenuDelegate
{
    func mainMenuOptionSelected(selectedOption:SelectedOption)
}

class MainMenuView: UIView, SKJoystickDelegate
{
    var currentLabelIndex = 0
    var latestInputTime = NSDate().timeIntervalSince1970
    var options:[UILabel] = []
    var pointer:UIView!
    var delegate:MainMenuDelegate!
    var isLeaderboardDisplayed = false
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        let hyperPangLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 240, height: 40))
        hyperPangLabel.center = CGPoint.init(x: self.center.x, y: self.center.y - 70)
        hyperPangLabel.font = UIFont.init(name: "Pixel-Art", size: 34)
        hyperPangLabel.backgroundColor = UIColor.clear
        hyperPangLabel.textAlignment = NSTextAlignment.center
        hyperPangLabel.textColor = UIColor.white
        hyperPangLabel.text = "HyperPang"
        self.addSubview(hyperPangLabel)
        
        let optionsWrapper = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 200, height: 100))
        optionsWrapper.center = CGPoint.init(x: self.center.x, y: self.center.y + 20)
        optionsWrapper.layer.cornerRadius = 6
        optionsWrapper.layer.borderColor = UIColor.white.cgColor
        optionsWrapper.layer.borderWidth = 2
        self.addSubview(optionsWrapper)
        
        let newGameLabel = UILabel.init(frame: CGRect.init(x: 30, y: 10, width: optionsWrapper.frame.size.width-40, height: 20))
        newGameLabel.font = UIFont.init(name: "Pixel-Art", size: 22)
        newGameLabel.backgroundColor = UIColor.clear
        newGameLabel.textColor = UIColor.white
        newGameLabel.text = "New game"
        optionsWrapper.addSubview(newGameLabel)
        
        let leaderboardLabel = UILabel.init(frame: CGRect.init(x: 30, y: 40, width: optionsWrapper.frame.size.width-40, height: 20))
        leaderboardLabel.font = UIFont.init(name: "Pixel-Art", size: 18)
        leaderboardLabel.backgroundColor = UIColor.clear
        leaderboardLabel.textColor = UIColor.white
        leaderboardLabel.text = "Leaderboard"
        optionsWrapper.addSubview(leaderboardLabel)
        
        let quitLabel = UILabel.init(frame: CGRect.init(x: 30, y: 70, width: optionsWrapper.frame.size.width-40, height: 20))
        quitLabel.font = UIFont.init(name: "Pixel-Art", size: 18)
        quitLabel.backgroundColor = UIColor.clear
        quitLabel.textColor = UIColor.white
        quitLabel.text = "make me crash"
        optionsWrapper.addSubview(quitLabel)
        
        options.append(newGameLabel)
        options.append(leaderboardLabel)
        options.append(quitLabel)
        
        let devLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 240, height: 25))
        devLabel.center = CGPoint.init(x: self.center.x, y: self.center.y + 95)
        devLabel.font = UIFont.init(name: "Pixel-Art", size: 14)
        devLabel.backgroundColor = UIColor.clear
        devLabel.textAlignment = NSTextAlignment.center
        devLabel.textColor = UIColor.white
        devLabel.text = "crafted with *** by msk"
        self.addSubview(devLabel)
        
        let h = UIImageView.init(image: UIImage.init(named: "heart"))
        h.frame.origin = CGPoint.init(x: 146, y: 7)
        devLabel.addSubview(h)
        
        setSelectedOption(selected: 0)
    }
    
    func goToNextOption()
    {
        changeOption(mod: -1)
    }
    
    func goToPrevOption()
    {
        changeOption(mod: 1)
    }
    
    func changeOption(mod:Int)
    {
        var newIndex = currentLabelIndex + mod
        if newIndex < 0 { newIndex = options.count - 1 }
        if newIndex > options.count - 1 { newIndex = 0 }
        
        currentLabelIndex = newIndex
                
        setSelectedOption(selected: newIndex)
    }
    
    func setSelectedOption(selected:Int)
    {
        removeAllAnimations()
        let label = options[selected]
        
        placePointerOnLabel(label: label)

        UIView.animate(withDuration: TimeInterval(0.8), delay: 0, options: [.repeat], animations:
        {label.alpha = 0.5})
    }
    
    func placePointerOnLabel(label:UILabel)
    {
        if pointer != nil
        {pointer.removeFromSuperview()}
        pointer = UIView.init(frame: CGRect.init(x: -15, y: 10, width: 10, height: 10))
        pointer.backgroundColor = UIColor.white
        label.addSubview(pointer)
    }
    
    
    func removeAllAnimations()
    {
        for label in options
        {
            label.layer.removeAllAnimations()
            label.alpha = 1.0
        }
    }
    
    func joystickUpdatedDirection(sender: AnyObject)
    {
        if isLeaderboardDisplayed == true { return }
        guard let stick = sender as? SKJoystick else { return }
        let now = NSDate().timeIntervalSince1970
        if (latestInputTime + 1) >= now {return}
        latestInputTime = now
        
        let dir = stick.direction
        
        if dir == Sense.UP || dir == Sense.UP_RIGHT || dir == Sense.UP_LEFT
        {
            self.goToNextOption()
        }
        if dir == Sense.DOWN || dir == Sense.DOWN_LEFT || dir == Sense.DOWN_RIGHT
        {
            self.goToPrevOption()
        }
    }
    
    func joystickReleased(sender: AnyObject)
    {
        latestInputTime = 0
    }
    
    func joystickButtonPressed(sender: AnyObject)
    {
        let selectedOption = getCurrentOption()
        guard let _ = delegate?.mainMenuOptionSelected(selectedOption: selectedOption) else { return }
      
        self.pointer.centerYAnchor.constraint(equalTo: <#T##NSLayoutAnchor<NSLayoutYAxisAnchor>#>, constant: <#T##CGFloat#>)
        
        self.pointer.heightAnchor.constraint
        
        let a = UIImage.init(named: <#T##String#>)
    }
    
    func getCurrentOption() -> SelectedOption
    {
        switch currentLabelIndex
        {
            case 0:
                return SelectedOption.newGame
            case 1:
                return SelectedOption.leaderboard
            case 2:
                return SelectedOption.quit
            default:
                return SelectedOption.leaderboard
        }
    }
    
    required init?(coder aDecoder: NSCoder)
    {super.init(coder: aDecoder)}

}
