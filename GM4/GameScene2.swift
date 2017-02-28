//
//  GameScene2.swift
//  Game Maker 4
//
//  Created by justin fluidity on 2/28/17.
//  Copyright © 2017 justin fluidity. All rights reserved.
//

import SpriteKit


/// TODO: Figure out what next to do. Something about children and spacing.

enum sizes {
  static  let
  prompt = CGSize(width: 50, height: 25),
  choice = CGSize(width: 200, height: 5)
}

enum sys {
  
  static var
  scene: SKScene = SKScene(),
  igeCounter = 0,
  currentNode: IGE?                    // NP
  
  /// Use this at various times... when sorting / swapping / deleting / adding iges.
  static func render(from ige: IGE) { // NP
    // Basically just a bunch of algos that adjust iges position.
    // So it isn"t overwhelming.. just render them at the correct Choice and then work on constraints later.
  }
};


// IGEs:
class IGE: SKSpriteNode {
  
  init(title: String) {
    
    let myType = String(describing: type(of: self))
    
    func findColor(_ fromType: String) -> SKColor {
      if fromType == "Prompt" {
        return .blue
      } else { return .red }
    }
    
    if myType == "Prompt" {
      super.init(texture: nil, color: findColor(myType), size: sizes.prompt)
    } else { super.init(texture: nil, color: findColor(myType), size: sizes.choice) }
    
    SUPERCONFIG: do {
      sys.igeCounter += 1
      isUserInteractionEnabled = true
      name = (myType + ": " + title + String(sys.igeCounter))
      
      physicsBody = SKPhysicsBody.init(rectangleOf: size); PBCONFIG: do { // Make sexy { body in ... }
        physicsBody!.categoryBitMask    = GameScene.bodies.prompt
        physicsBody!.collisionBitMask   = GameScene.bodies.prompt
        physicsBody!.contactTestBitMask = GameScene.bodies.prompt
      }
    }
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
    sys.currentNode = self
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    position = touches.first!.location(in: scene!)
  }
  
  required init?(coder aDecoder: NSCoder) {fatalError()}
  
  deinit { print("bye from an ige") }
};

final class Prompt: IGE {
  
  var mutableChildren: [Choice] = []
  
  override func addChild(_ node: SKNode) {
    super.addChild(node)
    guard let choice = node as? Choice else { fatalError("not a choice") }
    
    if let highestChoice = mutableChildren.last {
      choice.position = CGPoint(x: highestChoice.position.x,
                                y: highestChoice.position.y + 30)
    } else { choice.position = CGPoint(x: frame.maxX + 10, y: frame.minY) }
    
    mutableChildren.append(choice)
    
    // TODO: Stretch the prompt sprite:
  }
};

final class Choice: IGE {
  
};


// Buttons:
class Button: SKSpriteNode {
  
  init(color: SKColor, size: CGSize) {
    super.init(texture: nil, color: color, size: size)
    isUserInteractionEnabled = true
  }
  
  required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented")  }
  
  func promptChoiceCode(theNode: SKNode, runIfPrompt: ()->(), runIfChoice: ()->() ) {
    if theNode is Prompt {
      runIfPrompt()
    } else if theNode is Choice {
      runIfChoice()
    } else { fatalError("not a correct type") }
  }
};

final class AddButton: Button {
  // Need to figure out based on Y value where to put new prompt at... will need a line.
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
    guard let curNode = sys.currentNode else { print("no node selected"); return }
    print("<<", curNode.name as Any, ">> is selected")
    
    func addNewNode(ige: IGE) {
      if ige is Prompt {
      } else {
        ige.anchorPoint = CGPoint.zero
        ige.position = CGPoint(x: curNode.frame.maxX + 10, y: curNode.frame.minY)
      }
      
      curNode.addChild(ige)
    }
    
    promptChoiceCode(theNode: curNode,
                     runIfPrompt: { addNewNode(ige: Choice(title: "added choice"))},
                     runIfChoice: { addNewNode(ige: Prompt(title: "added prompt"))})
  }
};

