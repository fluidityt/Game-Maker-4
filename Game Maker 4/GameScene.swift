//
//  GameScene.swift
//  Game Maker 4
//
//  Created by justin fluidity on 2/26/17.
//  Copyright © 2017 justin fluidity. All rights reserved.
//

import SpriteKit
import GameplayKit

fileprivate let boxSize = CGSize(width: 25, height: 25)

enum sys {
  
  static var currentNode: SKNode?
  static var scene: SKScene = SKScene()
  static var igeCounter = 0
}

class IGE: SKSpriteNode {


  init(title: String) {
    
    
    let myType = ( String(describing: type(of: self)) + ": " )
    
    func findColor(_ fromType: String) -> SKColor {
      if fromType == "Prompt" {
        return .blue
      } else { return .red }
    }
    
    super.init(texture: nil, color: findColor(myType), size: boxSize)
    isUserInteractionEnabled = true
    sys.igeCounter += 1
    name = (myType + title + String(sys.igeCounter))
    position.x += CGFloat(sys.igeCounter * 25)
  }
  
  override func mouseDown(with event: NSEvent) {
    sys.currentNode = self
  }
  
  required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented")  }

}

class Prompt: IGE {

}

class Choice: IGE {
  
}

class Button: SKSpriteNode {
  
  init(color: SKColor, size: CGSize) {
    super.init(texture: nil, color: color, size: size)
    isUserInteractionEnabled = true
  }
  
  required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented")  }
}

class AddButton: Button {
  override func mouseDown(with event: NSEvent) {
    if let curNode = sys.currentNode {
      
      
      print(curNode.name as Any, "selected")
    } else { print("no node selected") }
  }
}

class GameScene: SKScene {

  override func didMove(to view: SKView) {
    
    func initialize() {
      // Laundry list:
      sys.scene = self
    }
    
    func test() {
      let zip = Prompt(title: "new prompt"), zip2 = Choice(title: "new choice")
      addChildren([zip, zip2])
    }
    
    initialize()
    test()
  }
  
  override func mouseDown(with event: NSEvent) {
    
    func test() {
      print(sys.currentNode?.name as Any)
    }
    
    test()

  }
  
  override func mouseDragged(with event: NSEvent) {

  }
  
  override func mouseUp(with event: NSEvent) {

  }
  
  override func keyDown(with event: NSEvent) {
    
    switch event.keyCode {
      default: print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
    }
  }
  
  
  override func update(_ currentTime: TimeInterval) {
    // Called before each frame is rendered
  }
}
