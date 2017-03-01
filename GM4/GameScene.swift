//
//  GameScene.swift

import SpriteKit

// Physics:
extension GameScene: SKPhysicsContactDelegate {
  
  func initPhysicsWorld() { /// Called in DMV
    physicsWorld.gravity = CGVector.zero
    physicsWorld.contactDelegate = self
    physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
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
      
      initPhysicsWorld()
    }
    
    func test() {
      let zip = Prompt(title: "new prompt"), zip2 = Choice(title: "new choice")
      addChildren([zip, zip2])
    }
    
    initialize()
    test()
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
    func test() {
      print(sys.currentNode?.name as Any)
    }
    
    test()
  }
};

