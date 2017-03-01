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
 
