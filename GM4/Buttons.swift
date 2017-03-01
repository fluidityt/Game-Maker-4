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

