//
//  nature.swift
//  CalmCampus
//
//  Created by Harshal Dhaduk on 3/15/24.
//

//
//  nature.swift
//  CalmCampus
//
//  Created by Harshal Dhaduk on 3/15/24.
//

import SwiftUI
import SpriteKit

struct GameScenePreview: UIViewRepresentable {
    func makeUIView(context: Context) -> SKView {
        let skView = SKView(frame: CGRect(x: 0, y: 0, width: 400, height: 600))
        let scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .fill
        skView.presentScene(scene)
        return skView
    }

    func updateUIView(_ uiView: SKView, context: Context) {
        // Update the view if needed
    }
}

class GameScene: SKScene {
    // Game state
    
    override func didMove(to view: SKView) {
        // Set background image
        let background = SKSpriteNode(imageNamed: "grass")
        background.size = self.size
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        background.zPosition = -1 // Ensure the background is behind other nodes
        addChild(background)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Handle player input
        for touch in touches {
            let location = touch.location(in: self)
            plantObject(at: location)
        }
    }
    
    func plantObject(at location: CGPoint) {
        let images: [(String, Int)] = [
            ("flower1", 100),
            ("flower2", 100),
            ("flower3", 100),
            ("flower4", 100),
            ("flower5", 100),
            ("flower6", 100),
            ("flower7", 100),
            ("flower8", 100),
            ("flower9", 100),
            ("flower10", 100),
            ("flower11", 1) // 1 in 1000 chance
        ]

        let totalWeight = images.reduce(0) { $0 + $1.1 }
        let randomValue = Int.random(in: 0...totalWeight)

        var cumulativeWeight = 0
        for (image, weight) in images {
            cumulativeWeight += weight
            if randomValue < cumulativeWeight {
                let object = SKSpriteNode(imageNamed: image)
                object.position = location
                object.xScale = 1
                object.yScale = 1

                addChild(object)

                let randomScale = CGFloat.random(in: 0.07...0.11)
                let scaleDownAction = SKAction.scale(to: randomScale, duration: 0.5)
                scaleDownAction.timingMode = .easeOut

                object.run(scaleDownAction)
                return
            }
        }
    }
}

struct GameScene_Previews: PreviewProvider {
    static var previews: some View {
        GameScenePreview()
    }
}
