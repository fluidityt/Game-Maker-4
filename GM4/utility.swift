import SpriteKit

extension CGPoint { init(_ x: Int, _ y: Int) { self.init(x: x, y: y) } }

extension CGRect {  var center: CGPoint { return CGPoint(x: midX, y: midY) } }

extension SKNode {
  
  func addChildren(_ children: [SKNode]) {
    for child in children {
      addChild(child)
    }
  }
}


    
