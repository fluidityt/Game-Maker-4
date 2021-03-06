//: Playground - noun: a place where people can play

import SpriteKit
import PlaygroundSupport

print("hi")

//
// IGE init:
//

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
    
    // Super Config:
    anchorPoint              = CGPoint.zero
    isUserInteractionEnabled = true
    
    sys.igeCounter += 1
    name = (myType + ": " + title + String(sys.igeCounter))
  }
  
  required init?(coder aDecoder: NSCoder) { fatalError("fe")}
};

// IGE touches:
extension IGE {
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    sys.currentNode = self
    print("tb:", sys.currentNode?.name as Any)
    
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    position = touches.first!.location(in: scene!)
  }
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
  }
};

// Prompts:
final class Prompt: IGE {
  
  var childs: [Choice] = []
  
  func draw() {
    
  var y = CGFloat(0)
    for child in childs {
      child.position = position
      child.position.y += y
      child.position.x += frame.width + 10
      y += 30
    }
    y = 0
  }
  
  override func addChild(_ node: SKNode) {
    if let child = node as? Choice {
      childs.append(child)
      scene!.addChild(child)
      draw()
      resize()
    } else { print("addChild: not a choice") }
    
  }
  
  
  func resize() {
    size = CGSize(width: size.width, height: CGFloat((childs.count ) * 30))
    switch (childs.count) {
      case 0:  print("resize: no childs found")
      default: print("resize: no case found")
    }
    sys.frames[name!] = frame
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    position = touches.first!.location(in: scene!)
    draw()
  }
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    draw()
  }
 
}

// Choice:
final class Choice: IGE {

};

//
//  Buttons.swift
//

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
    
    ///////////////////////////    ///////////////////////////    ///////////////////////////    ///////////////////////////    ///////////////////////////    ///////////////////////////    ///////////////////////////    ///////////////////////////
    if curNode is Prompt {
      curNode.addChild(Choice(title: "added prompt"))
      (curNode as! Prompt).draw()
    }
    if curNode is Choice { scene!.addChild(Prompt(title: "added choice")) }
    
    
  }
};

//
//  Enums.swift
//

import SpriteKit

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
  currentNode: IGE?,                    // NP
  frames: [String: CGRect] = [:]
  
  /// Use this at various times... when sorting / swapping / deleting / adding iges.
  static func render(from ige: IGE) { // NP
    // Basically just a bunch of algos that adjust iges position.
    // So it isn"t overwhelming.. just render them at the correct Choice and then work on constraints later.
  }
};

//
//  GameScene.swift
//

import SpriteKit

// Gamescene:
class GameScene: SKScene {
  
  private func initialize() {
    // Laundry list:
    sys.scene = self
    let addButton = AddButton(color: .green, size: CGSize(width: 200, height: 200))
    addButton.position.x = frame.minX
    addButton.position.y -= 300
    addChild(addButton)
    
    let bkg = SKSpriteNode(color: .gray, size: size)
    bkg.isUserInteractionEnabled = true
    bkg.zPosition -= 1
    bkg.name = "bkg"
    addChild(bkg)
  }
  
  private func test() {
    let zip = Prompt(title: "new prompt"); ZIPSTUFF: do {
      addChild(zip)
      zip.position.x = frame.minX
      zip.resize()
      sys.currentNode = zip
    }
  }
  
  override func didMove(to view: SKView) {
    initialize()
    test()
  }
  
  override func didSimulatePhysics() {
    for child in children {
      if child.name == "bkg" { continue }
      if child.name == sys.currentNode!.name { continue }
      if sys.currentNode!.frame.intersects(child.frame) {
        print("hit detected")
      }
    }
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
  }
};


// 
// PG.notswift
//

let view = SKView(frame: CGRect(x: 0, y: 0, width: 600, height: 650))
let scene = GameScene(size: CGSize(width: 600, height: 650))
scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
view.presentScene(scene)
PlaygroundPage.current.liveView = view


