//
//  enums.swift
import SpriteKit

enum bodies {
  static let prompt = UInt32(1)
}

enum sizes {
  static  let
  prompt = CGSize(width: 50, height: 25),
  choice = CGSize(width: 200, height: 5)
  
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


