//
//  IGEs.swift

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
    
    // Config:
    anchorPoint = CGPoint.zero
    isUserInteractionEnabled = true
    
    sys.igeCounter += 1
    name = (myType + ": " + title + String(sys.igeCounter))
    
    physicsBody = SKPhysicsBody.init(rectangleOf: size); PBCONFIG: do { // Make sexy { body in ... }
      physicsBody!.categoryBitMask    = bodies.prompt
      physicsBody!.collisionBitMask   = bodies.prompt
      physicsBody!.contactTestBitMask = bodies.prompt
    }
  }
  
  required init?(coder aDecoder: NSCoder) { fatalError("fe")}
};

// IGE touches:
extension IGE {
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
    sys.currentNode = self
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    position = touches.first!.location(in: scene!)
  }
};

// IGE funcs:
extension IGE {
};


// Prompts addChild:
final class Prompt: IGE {
  
  var mutableChildren: [Choice] = []
  
  func resize() { /// Used in .addChild().
    size = CGSize(width: size.width, height: CGFloat(children.count * 30))
    switch (children.count) {
      case 0: print("no childs found")
      default: print("no case found")
    }
  }
  
  override func addChild(_ node: SKNode) {
    guard let choice = node as? Choice else { print("addChild: not a choice"); return }
    
    super.addChild(node)
    
    if let highestChoice = mutableChildren.last {
      choice.position = CGPoint(x: highestChoice.position.x,
                                y: highestChoice.position.y + 30)
    } else { choice.position = CGPoint(x: frame.maxX + 10, y: frame.minY) }
    
    mutableChildren.append(choice)
    
    resize()
  }
};


// Choice:
final class Choice: IGE {
};

