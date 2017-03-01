//
//  IGEs.swift
/*  6:20 | 100% | 6.04 remain
    6:38 | 92 % | 4.20 remain
    6:48 | 88 % | 4.09 remain
 */

import SpriteKit

// IGE init:
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
    
    let adjustedPoint = CGPoint(x: frame.width/2, y: frame.height/2)
    physicsBody = SKPhysicsBody.init(rectangleOf: size, center: adjustedPoint); PBCONFIG: do { // Make sexy { body in ... }
      physicsBody!.categoryBitMask    = bodies.prompt
      physicsBody!.collisionBitMask   = bodies.prompt
      physicsBody!.contactTestBitMask = bodies.prompt
      physicsBody!.pinned             = true
      physicsBody!.allowsRotation     = false
    }
  }

  required init?(coder aDecoder: NSCoder) { fatalError("fe")}
};


// IGE touches:
extension IGE {
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    sys.currentNode = self
  }
  
};


// IGE funcs:
extension IGE {
};


// Prompts:
final class Prompt: IGE {
  
  func resize() {
    size = CGSize(width: size.width, height: CGFloat((children.count + 1) * 30))
    switch (children.count) {
      case 0:  print("resize: no childs found")
      default: print("resize: no case found")
    }
  }
  
  var mutableChildren: [Choice] = []
  
  override func addChild(_ node: SKNode) {
    guard let choice = node as? Choice else { print("addChild: not a choice"); return }
    
    resize()
    
    if let highestChoice = children.last { // Add on top or create first one if none:
      choice.position        = CGPoint(x: highestChoice.position.x,
                                       y: highestChoice.position.y + 30)
    } else { choice.position = CGPoint(x: frame.maxX + 10, y: frame.minY) }

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
    guard let prompt = node as? Prompt else { print("addChild: not a Prompt"); return }
    
    super.addChild(prompt)
    prompt.position.x = frame.maxX + 10
    prompt.position.y = frame.minY
    
  }
};
