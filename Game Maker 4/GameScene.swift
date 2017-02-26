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
  
}

class Prompt: SKSpriteNode {

  init(title: String) {
    super.init(texture: nil, color: .blue, size: boxSize)
    isUserInteractionEnabled = true
    name = ("PROMPT: " + title)
  }
  
  override func mouseDown(with event: NSEvent) {
    sys.currentNode = self
  }
  
  required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented")  }
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

  private func initialize() {
    // Laundry list:
    sys.scene = self
  }
  
  override func didMove(to view: SKView) {
    initialize()
  }
  
  override func mouseDown(with event: NSEvent) {

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
