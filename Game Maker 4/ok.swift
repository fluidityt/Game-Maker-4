//
//  ok.swift
//  Game Maker 4
//
//  Created by justin fluidity on 2/26/17.
//  Copyright © 2017 justin fluidity. All rights reserved.
//

import SpriteKit

extension SKNode {
  
  func addChildren(_ children: [SKNode]) {
    for child in children {
      addChild(child)
    }
  }
}


