import SpriteKit

extension SKNode {
  
  func addChildren(_ children: [SKNode]) {
    for child in children {
      addChild(child)
    }
  }
}

