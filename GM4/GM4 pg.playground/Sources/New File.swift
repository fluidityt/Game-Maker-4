import Foundation


// IGE init:
class IGE: SKSpriteNode {
  
  fileprivate func makePB() -> SKPhysicsBody {
    let adjustedPoint = CGPoint(x: frame.width/2, y: frame.height/2)
    let myPhysicsBody = SKPhysicsBody.init(rectangleOf: size, center: adjustedPoint); PBCONFIG: do { // Make sexy { body in ... }
      myPhysicsBody.categoryBitMask    = bodies.prompt
      myPhysicsBody.collisionBitMask   = bodies.prompt
      myPhysicsBody.contactTestBitMask = bodies.prompt
      //myPhysicsBody.pinned             = true
      myPhysicsBody.allowsRotation     = false
    }
    return myPhysicsBody
  }
  
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
    
    // Super Config:
    anchorPoint              = CGPoint.zero
    isUserInteractionEnabled = true
    
    sys.igeCounter += 1
    name = (myType + ": " + title + String(sys.igeCounter))
    
    physicsBody = makePB()
  }
  
  required init?(coder aDecoder: NSCoder) { fatalError("fe")}
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    sys.currentNode = self
    print("tb:", sys.currentNode?.name as Any)
  }
  // IGE touches: extension IGE {};
};


// Prompts:
final class Prompt: IGE {
  
  func resize() {
    size = CGSize(width: size.width, height: CGFloat((children.count + 1) * 30))
    switch (children.count) {
    case 0:  print("resize: no childs found")
    default: print("resize: no case found")
    }
    
    physicsBody = makePB()
  }
  
  var mutableChildren: [Choice] = []
  
  override func addChild(_ node: SKNode) {
    guard let choice = node as? Choice else { print("addChild: not a choice"); return }
    
    resize()
    
    if let highestChoice = children.last { // Add on top or create first one if none:
      choice.position  = CGPoint(x: highestChoice.position.x,
                                 y: highestChoice.position.y + 30)
    } else {
      choice.position.x += frame.width + 10
    }
    
    super.addChild(choice)
    mutableChildren.append(choice)
  }
}

// Prompt touches
extension Prompt {
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    physicsBody!.pinned = false
    position = touches.first!.location(in: scene!)
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    physicsBody!.pinned = true
  }
  
}


// Choice:
final class Choice: IGE {
  override func addChild(_ node: SKNode) {
    if children.count > 0 { return }
    guard let prompt = node as? Prompt else { print("addChild: not a Prompt"); return }
    
    super.addChild(prompt)
    prompt.position.x += frame.width + 10
    //  prompt.position.y = frame.minY
    
    
  }
};

//
//  GameScene.swift

import SpriteKit


// Physics:
extension GameScene: SKPhysicsContactDelegate {
  
  func initPhysicsWorld() { /// Called in DMV
    physicsWorld.gravity = CGVector.zero
    physicsWorld.contactDelegate = self
    //physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
  }
  
  func didEnd(_ contact: SKPhysicsContact) {
    
    
  }
  
  func didBegin(_ contact: SKPhysicsContact) {
    let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
    
    let prompt = bodies.prompt
    
    switch (contactMask) {
    case prompt | prompt: print("hi")
      
    default: print("not")
    }
  }
};


// Gamescene:
class GameScene: SKScene {
  
  override func didMove(to view: SKView) {
    
    func initialize() {
      // Laundry list:
      sys.scene = self
      let addButton = AddButton(color: .green, size: CGSize(width: 200, height: 200))
      addButton.position.x = frame.minX
      addButton.position.y -= 300
      addChild(addButton)
      
      let bkg = SKSpriteNode(color: .gray, size: size)
      bkg.isUserInteractionEnabled = true
      bkg.zPosition -= 1
      addChild(bkg)
      
      initPhysicsWorld()
    }
    
    func test() {
      let zip = Prompt(title: "new prompt"); ZIPSTUFF: do {
        addChild(zip)
        zip.resize()
        sys.currentNode = zip
      }
    }
    
    initialize()
    test()
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
  }
};




//
//  Buttons.swift

import SpriteKit

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
    
    guard let curNode = sys.currentNode else { print("tb: no node selected"); return }
    print("<<", curNode.name as Any, ">> is selected")
    
    super.promptChoiceCode(theNode: curNode, // VVV Uses overrided .addChild().
      runIfPrompt: { curNode.addChild(Choice(title: "added choice"))},
      runIfChoice: { curNode.addChild(Prompt(title: "added prompt"))})
  }
};



//
//  enums.swift
import SpriteKit

enum bodies {
  static let prompt = UInt32(1)
}

enum sizes {
  static  let
  prompt = CGSize(width: 50, height: 25),
  choice = CGSize(width: 200, height: 10)
  
  static func stretchedSize(numChildren: Int) -> CGSize {
    return CGSize(width: prompt.width, height: choice.height * 5.6)
  }
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
