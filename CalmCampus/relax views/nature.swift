import SwiftUI
import SpriteKit

struct GameScenePreview: View {
    @State private var isPopupPresented = true

    var body: some View {
        ZStack {
            RepresentableGameView(isPopupPresented: $isPopupPresented)
                .edgesIgnoringSafeArea(.all)
            if isPopupPresented {
                InfoPopup(isPresented: $isPopupPresented)
            }
        }
    }
}

struct RepresentableGameView: UIViewRepresentable {
    @Binding var isPopupPresented: Bool

    func makeUIView(context: Context) -> SKView {
        let skView = SKView(frame: .zero)
        let scene = GameScene(size: CGSize(width: 400, height: 600), isPopupPresented: $isPopupPresented)
        scene.scaleMode = .fill
        skView.presentScene(scene)
        return skView
    }

    func updateUIView(_ uiView: SKView, context: Context) {
        // Update the view if needed
    }
}

class GameScene: SKScene {
    @Binding var isPopupPresented: Bool

    init(size: CGSize, isPopupPresented: Binding<Bool>) {
        self._isPopupPresented = isPopupPresented
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {
        // Set background image
        let background = SKSpriteNode(imageNamed: "grass")
        background.size = self.size
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        background.zPosition = -1 // Ensure the background is behind other nodes
        addChild(background)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isPopupPresented {
            isPopupPresented = false
        } else {
            // Handle player input
            for touch in touches {
                let location = touch.location(in: self)
                plantObject(at: location)
            }
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

struct InfoPopup: View {
    @Binding var isPresented: Bool

    var body: some View {
        VStack(spacing: 20) {
            Text("Flower Hunt!")
                .font(.title)
                .fontWeight(.bold)
                .padding()

            Image("flower11") // Replace with the appropriate flower image
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)

            Text("The flower above has a 1/1000 chance of spawning. Try and be the one to plant it!")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()
                .lineLimit(nil) // Allow unlimited lines

            Button(action: {
                isPresented = false
            }) {
                Text("Got it!")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(20)
        .shadow(radius: 10)
        .frame(width: 300) // Remove fixed height to allow content to expand
    }
}

struct GameScene_Previews: PreviewProvider {
    static var previews: some View {
        GameScenePreview()
    }
}
