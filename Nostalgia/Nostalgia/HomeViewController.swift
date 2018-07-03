//
//  HomeViewController.swift
//  Nostalgia
//
//  Created by Vincenzo Ajello on 05/03/18.
//  Copyright © 2018 mskaline. All rights reserved.
//

import UIKit
import SpriteKit

class HomeViewController: UIViewController, GameEventDelegate
{
    var width:CGFloat = 0.0
    var joystick:JoystickSKcene!
    var screen:ScreenView!
    var leaderboardView:LeaderboardView!
    var mainMenuView:MainMenuView!
    var setPlayerName:SetPlayerName!
    var coreData:CoreDataDefaultStorage!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.isMultipleTouchEnabled = true
        self.view.isExclusiveTouch = false
        
        width = self.view.frame.size.width - 20
        
        self.drawUI()

        self.leaderboardView.refreshData()
        joystick.stick.delegate = mainMenuView

        coreData = initCoreData()
    }
    
    //
    // MARK: GAME EVENTs DELEGATE
    //
    
    func GameOver(points: Int)
    {
        print("GAME OVER # \(points)")
        screen.stopGame()
        
        if points == 0
        {
            self.showLeaderBoard()
            return
        }
        
        joystick.stick.delegate = setPlayerName
        setPlayerName.setScore(score: points)
        screen.contentView.addSubview(setPlayerName)
    }
    
    //
    // MARK: UTILITY
    //

    override func didReceiveMemoryWarning()
    {super.didReceiveMemoryWarning()}
}






//
// MARK: MENU ACTIONS + DELEGATE
//

extension HomeViewController: MainMenuDelegate
{
    func mainMenuOptionSelected(selectedOption: SelectedOption)
    {
        
        if mainMenuView.isLeaderboardDisplayed == true
        {
            hideLeaderBoard()
            return
        }
        
        //print("Option Selected -> \(selectedOption)")
        switch selectedOption
        {
        case SelectedOption.newGame:
            newGame()
        case SelectedOption.leaderboard:
            showLeaderBoard()
        case SelectedOption.quit:
            makeMeCrash()
        }
    }
    
    func newGame()
    {
        print("-> Start new game")
        mainMenuView.removeFromSuperview()
        screen.startGame()
        joystick.stick.delegate = screen.gameScene
        screen.gameScene.gameDelegate = self
    }
    
    func showLeaderBoard()
    {
        print("-> Show leaderboard")
        mainMenuView.removeFromSuperview()
        setPlayerName.removeFromSuperview()
        screen.contentView.addSubview(leaderboardView)
        joystick.stick.delegate = mainMenuView
        mainMenuView.isLeaderboardDisplayed = true
    }
    
    func hideLeaderBoard()
    {
        print("<- Back to Main Menu")
        leaderboardView.removeFromSuperview()
        screen.contentView.addSubview(mainMenuView)
        mainMenuView.setSelectedOption(selected: mainMenuView.currentLabelIndex)
        mainMenuView.isLeaderboardDisplayed = false
    }
    
    func makeMeCrash()
    {
        // quit
        fatalError()
    }
}




//
// MARK: CORE DATA / SAVES
//

extension HomeViewController
{
    func initCoreData() -> CoreDataDefaultStorage
    {
        let store = CoreDataStore.named("NostalgiaData")
        let bundle = Bundle(for: self.classForCoder)
        let model = CoreDataObjectModel.merged([bundle])
        let defaultStorage = try! CoreDataDefaultStorage(store: store, model: model)
        return defaultStorage
    }
    
    func savePlayerScore(points: Int, nickName: String)
    {
        print("Save player score \(nickName) : \(points)")
        
        do
        {
            try coreData.operation
            {
                (context, save) throws -> Void in
                
                let newScore: Scores = try! context.create()
                newScore.nickname = nickName
                newScore.score = Int32(points)
                save()
                
                self.leaderboardView.refreshData()
                self.showLeaderBoard()
            }
        }
        catch
        {
            // There was an error in the save operation
        }
    }
}

//
// MARK: DRAW UI
//

extension HomeViewController
{
    func drawUI()
    {
        drawJoystickView()
        drawScreenView()
        drawMainMenu()
        drawLeaderboard()
        drawSetPlayerName()
    }
    
    func drawJoystickView()
    {
        let h = (self.view.frame.size.height / 2) - 50
        let y = self.view.frame.size.height-h - 10
        
        // Draw SpriteKit View for the joystick
        let skview = SKView.init(frame: CGRect.init(x: 0, y: y, width: width, height: h))
        skview.center.x = view.center.x
        skview.ignoresSiblingOrder = true
        skview.showsFPS = true
        skview.showsNodeCount = true
        skview.showsPhysics = false
        skview.showsDrawCount = true
        skview.allowsTransparency = true
        skview.layer.cornerRadius = 6
        skview.layer.masksToBounds = true
        skview.isMultipleTouchEnabled = true;
        self.view.addSubview(skview)
        
        // Draw Joystick
        joystick = JoystickSKcene(size:skview.bounds.size)
        joystick.scaleMode = .aspectFill
        skview.presentScene(joystick)
    }
    
    func drawScreenView()
    {
        screen = ScreenView.init(width: self.view.frame.size.width)
        self.view.addSubview(screen)
    }
    
    func drawMainMenu()
    {
        let h = screen.contentView.frame.height
        mainMenuView = MainMenuView.init(frame: CGRect.init(x: 0, y: 0, width: width, height: h))
        mainMenuView.delegate = self
        screen.contentView.addSubview(mainMenuView)
    }
    
    func drawLeaderboard()
    {
        let h = screen.contentView.frame.height
        leaderboardView = LeaderboardView.init(frame: CGRect.init(x: 0, y: 0, width: width, height: h))
    }
    
    func drawSetPlayerName()
    {
        let h = screen.contentView.frame.height
        setPlayerName = SetPlayerName.init(frame: CGRect.init(x: 0, y: 0, width: width, height: h))
        setPlayerName.delegate = self
    }
}
