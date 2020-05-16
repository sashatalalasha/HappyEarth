//: # HappyEarth
//:  ## Hello, User! This interactive playground is designed to help you learning how to sort garbage. We are responsible for our mother nature, so lets learn how to separate waste and make recycling easier!

import PlaygroundSupport
import SpriteKit
import AVFoundation


class GameScene: SKScene {
    
    private var label : SKLabelNode!
    
    override func didMove(to view: SKView) {
        
        let backgroundImage = SKSpriteNode(imageNamed: "Wallpaper.png")
        backgroundImage.size = self.frame.size
        backgroundImage.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        backgroundImage.isUserInteractionEnabled = true
        self.addChild(backgroundImage)
        
        let startButton = SKSpriteNode(imageNamed: "playButton.png")
        startButton.size = CGSize(width: 100, height: 100)
        startButton.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        startButton.name = "StartButton"
        startButton.zPosition = 1

        startButton.isHidden = false
        self.addChild(startButton)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            
            if touchedNode.name == "StartButton" {
                if let game = PlayScene(fileNamed: "PlayScene") {
                    game.scaleMode = .aspectFit
                    sceneView.presentScene(game)
                }
            }
        }
    }
}

class PlayScene: SKScene {
    
    private var player: AVPlayer?
    
    // An array of all trash nodes
    private var allNodes: [SKSpriteNode] = []
    private var selectedNode: SKNode?
    private var touchLocation: CGPoint?
    private var positionOfNode: CGPoint?
    private var randomElem = ["plastic.png", "bio.png", "can.png", "paper.png", "canCoke.png", "pear.png", "cardboard.png", "juice.png", "yogurt.png"]
    
    private var paperBin: SKSpriteNode?
    private var plasticBin: SKSpriteNode?
    private var trashBin: SKSpriteNode?
    private var cansBin: SKSpriteNode?
    
    // Number of health units
    private var num = 4
    
    
    override func didMove(to view: SKView) {
        print(Double(-self.frame.maxX/2.0))
        let backgroundImage = SKSpriteNode(imageNamed: "Wallpaper.png" )
        backgroundImage.size = self.frame.size
        backgroundImage.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        backgroundImage.isUserInteractionEnabled = true
        self.addChild(backgroundImage)
        let backButton = SKSpriteNode(imageNamed: "backButton.png")
        backButton.size = CGSize(width: 200, height: 50)
        backButton.position = CGPoint(x: self.frame.minX + 150, y: self.frame.maxY - 50)
        backButton.name = "BackButton"
        backButton.zPosition = 1
        backButton.isHidden = false
        self.addChild(backButton)
        
        placeHealth()
    
        for _ in 1...10 {
            allNodes.append(createTrash())
        }
        
        paperBin = placeBin(type: "paper-bin.png", pos: CGPoint(x: -300, y: -20))
        plasticBin = placeBin(type: "plastic-bin.png", pos: CGPoint(x: -100, y: -20))
        trashBin = placeBin(type: "trash-bin.png", pos: CGPoint(x: 100, y: -20))
        cansBin = placeBin(type: "cans-bin.png", pos: CGPoint(x: 300, y: -20))
    }
    
    func placeHealth() {
        for i in 1...4 {
            let heart = SKSpriteNode(imageNamed: "fullHeart.png")
            heart.zPosition = 2
            heart.size = CGSize(width: 75, height: 75)
            heart.position = CGPoint(x: -350 + 80*(i - 1), y: 250)
            heart.name = "heart\(i)"
            self.addChild(heart)
        }
    }
    
    func removeHealth(count: Int) {
       let child = childNode(withName: "heart\(count)")
        let position = child?.position
        child?.removeFromParent()
        let heart = SKSpriteNode(imageNamed: "emptyHeart.png")
        heart.zPosition = 2
        heart.size = CGSize(width: 75, height: 75)
        // replace health unit with empty one
        heart.position = position!
        self.addChild(heart)
        num-=1
    }
    
    func endGame(reason: String) {
        UserDefaults.standard.removeObject(forKey: "Status")
        // Set status of game (won or lost)
        UserDefaults.standard.set(reason, forKey: "Status")
        if let finish = EndScene(fileNamed: "EndScene") {
            finish.scaleMode = .aspectFit
            sceneView.presentScene(finish)
        }
    
    }
    
    func playSound(name: String) {
        let path = Bundle.main.path(forResource: name, ofType : "m4a")!
        let url = URL(fileURLWithPath : path)
        player = AVPlayer(url: url)
        player?.play()
    }
    
    func placeBin(type: String, pos: CGPoint) -> SKSpriteNode {
        let bin = SKSpriteNode(imageNamed: type)
        bin.zPosition = 1
        bin.size = CGSize(width: 140, height: 170)
        bin.position = pos
        bin.isUserInteractionEnabled = true
        self.addChild(bin)
        return bin
    }
    
    func createTrash() -> SKSpriteNode {
        let category = randomElem.randomElement()
        let trash = SKSpriteNode(imageNamed: category!)
        trash.zPosition = 2
        trash.size = CGSize(width: 60, height: 70)
        trash.position = randomPosition()
        trash.name = category!
        self.addChild(trash)
        return trash
     }
    
    func checkIfLost() {
        // If number of health units is 0, user looses the game
        if(num == 0) {
            endGame(reason: "lost")
        }
    }
    
    func randomPosition() -> CGPoint {
        let x = Double.random(in: (Double(-self.frame.maxX) + 100.0) ..< (Double(self.frame.maxX) - 100.0))
        let y = Double.random(in: (Double(-self.frame.maxY ) + 50.0)..<Double(-self.frame.maxY/3.7))
        return CGPoint(x: x, y: y)
    }
 
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNewNode = atPoint(location)
            if touchedNewNode.name == "BackButton" {
                if let game = GameScene(fileNamed: "GameScene") {
                    game.scaleMode = .aspectFit
                    sceneView.presentScene(game)
                }
            }
            else {
                self.selectedNode = touchedNewNode
                self.positionOfNode = touchedNewNode.position
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            self.selectedNode!.position = touch.location(in: self)
        }
    }
    
    func putInBin(node: SKSpriteNode) {
        node.removeFromParent()
        playSound(name: "clap")
        self.selectedNode = nil
        self.positionOfNode = nil
        // If all trash is sorted, user wins
        if(allNodes.map{ $0.parent == nil }.allSatisfy({ $0 == true })) {
            endGame(reason: "won")
        }
    }
    
    func moveToRandomPos(remove: Bool) {
        // If trash was put in a wrong bin, delete one heath unit
        if(remove) {
            removeHealth(count: num)
            playSound(name: "err")
        }
        let position = randomPosition()
        let action = SKAction.move(to: position, duration: 1)
        self.selectedNode?.run(action)
        self.selectedNode = nil
        checkIfLost()
        
    }

    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, self.selectedNode != nil {
            selectedNode!.position = touch.location(in: self)
        }
        
        if let node = self.selectedNode {
            if let x = paperBin?.intersects(node), x == true {
                node.name == "paper.png" || node.name == "cardboard.png" ? putInBin(node: node as! SKSpriteNode) : moveToRandomPos(remove: true)
            }
            else if let x = plasticBin?.intersects(node), x == true {
                node.name == "plastic.png" || node.name == "juice.png" || node.name == "yogurt.png" ? putInBin(node: node as! SKSpriteNode) : moveToRandomPos(remove: true)
            }
            else if let x = trashBin?.intersects(node), x == true {
                node.name == "bio.png" || node.name == "pear.png" ? putInBin(node: node as! SKSpriteNode) : moveToRandomPos(remove: true)
            }
            else if let x = cansBin?.intersects(node), x == true {
                node.name == "can.png" || node.name == "canCoke.png" ? putInBin(node: node as! SKSpriteNode) : moveToRandomPos(remove: true)
            }
            else {
                // If user drags trash somewhere else, place it in random location
                moveToRandomPos(remove: false)
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.selectedNode = nil
        self.positionOfNode = nil
     }
}

class EndScene: SKScene {
    
    override func didMove(to view: SKView) {
        let status = UserDefaults.standard.string(forKey: "Status")
        
        let backgroundImage: SKSpriteNode?
        let label = SKLabelNode(fontNamed: "Helvetica Neue")
        // If user wins the game
        if(status == "won") {
            backgroundImage = SKSpriteNode(imageNamed: "happyEarth.png" )
            backgroundImage!.size = self.frame.size
            backgroundImage!.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
            backgroundImage!.isUserInteractionEnabled = true
            self.addChild(backgroundImage!)
            label.text = "You won!Congratulations!"
            label.fontColor = UIColor(red: 0.0, green: 153.0, blue: 0.0, alpha: 1.0)
        }
        else { // If user looses the game
             backgroundImage = SKSpriteNode(imageNamed: "sadEarth.png" )
            backgroundImage!.size = self.frame.size
            backgroundImage!.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
            backgroundImage!.isUserInteractionEnabled = true
            self.addChild(backgroundImage!)
            label.text = "You lost!But you can try again to save the planet:)"
            label.fontColor = .red
        }
        label.fontSize = 40
        label.fontName = "AmericanTypewriter-Bold"
        label.position = CGPoint(x: self.frame.midX , y: self.frame.midY + 70)
        label.zPosition = 1
        self.addChild(label)
        
        let retryButton = SKSpriteNode(imageNamed: "retryButton.png")
        retryButton.size = CGSize(width: 100, height: 100)
        retryButton.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 15)
        retryButton.name = "RetryButton"
        retryButton.zPosition = 1
        retryButton.isHidden = false
        self.addChild(retryButton)
      }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           for touch in touches {
               let location = touch.location(in: self)
               let touchedNode = atPoint(location)
            // play one more time
               if touchedNode.name == "RetryButton" {
                   if let game = PlayScene(fileNamed: "PlayScene") {
                       game.scaleMode = .aspectFit
                       sceneView.presentScene(game)
                   }
               }
           }
    }
}


// Load the SKScene from 'GameScene.sks'
let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 700, height: 700))
sceneView.ignoresSiblingOrder = true
PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
// Create sharable status of game between scenes
var status = UserDefaults.standard
status.set("game", forKey: "Status")

var player: AVAudioPlayer?

let path = Bundle.main.path(forResource: "cave.m4a", ofType:nil)!
let url = URL(fileURLWithPath: path)

do {
    player = try AVAudioPlayer(contentsOf: url)
    //Play music through the whole game
    player?.numberOfLoops = -1
    player?.play()
} catch {
    print("Could not load file")
}


if let scene = GameScene(fileNamed: "GameScene") {
    // Set the scale mode to scale to fit the window
    scene.scaleMode = .aspectFit
    sceneView.presentScene(scene)
}
