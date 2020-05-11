//: A SpriteKit based Playground

import PlaygroundSupport
import SpriteKit
import Foundation



class IMProgressBar : SKNode{

var emptySprite : SKSpriteNode? = nil
var progressBar : SKCropNode
    
init(emptyImageName: String!,filledImageName : String)
{
    progressBar = SKCropNode()
    super.init()
    let filledImage  = SKSpriteNode(imageNamed: filledImageName)
    filledImage.size = CGSize(width: 400, height: 100)
    progressBar.addChild(filledImage)
    progressBar.maskNode = SKSpriteNode(color: UIColor.white,
        size: CGSize(width: filledImage.size.width * 2, height: filledImage.size.height * 2))

    progressBar.maskNode?.position = CGPoint(x: filledImage.size.width / 2,y: filledImage.size.height / 2)
    progressBar.zPosition = 0.1
    self.addChild(progressBar)

    if emptyImageName != nil{
        emptySprite = SKSpriteNode.init(imageNamed: emptyImageName)
        self.addChild(emptySprite!)
    }
}
func setXProgress(xProgress : CGFloat){
    var value = xProgress
    if xProgress < 0{
        value = 0
    }
    if xProgress > 1 {
        value = 1
    }
    progressBar.maskNode?.xScale = value
}

func setYProgress(yProgress : CGFloat){
    var value = yProgress
    if yProgress < 0{
        value = 0
    }
    if yProgress > 1 {
        value = 1
    }
    progressBar.maskNode?.yScale = value
}
required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
}
}



class GameScene: SKScene {
    
    private var label : SKLabelNode!
    
    override func didMove(to view: SKView) {
        let backgroundImage = SKSpriteNode(imageNamed: "Wallpaper.png")
        backgroundImage.size = self.frame.size
        backgroundImage.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        backgroundImage.isUserInteractionEnabled = true
        self.addChild(backgroundImage)
        
        
        // Present the scene
        
        /*let label = SKLabelNode(fontNamed: "Helvetica Neue")
        label.text = "Hi!"
        label.fontSize = 30
        label.fontColor = SKColor.orange
        label.position = CGPoint(x: self.frame.width/2.0 , y: self.frame.height/2.0)
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        self.addChild(label)*/
        let startButton = SKSpriteNode(imageNamed: "playButton.png")
        startButton.size = CGSize(width: 100, height: 100)
        startButton.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        startButton.name = "StartButton"
        startButton.zPosition = 1

        startButton.isHidden = false
        self.addChild(startButton)
        
    }
    
    

    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
       
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            if touchedNode.name == "StartButton" {
                print("start")
                if let game = PlayScene(fileNamed: "PlayScene") {
                    game.scaleMode = .aspectFill
                print("star2t")
            
                    sceneView.presentScene(game)
                }
            
                
                // Call the function here.
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchUp(atPoint: t.location(in: self)) }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

class PlayScene: SKScene {
    
    
    private var touchedNodes: [SKNode] = []
    private var pos: (x: CGFloat, y: CGFloat)?
    private var selectedNode: SKNode?
    private var touchLocation: CGPoint?
    private var positionOfNode: CGPoint?
    private var randomElem = ["plastic.png", "bio.png", "glas.png", "paper.png"]
    
    private var paperBin: SKSpriteNode?
    private var plasticBin: SKSpriteNode?
    private var trashBin: SKSpriteNode?
    private var cansBin: SKSpriteNode?
    
    private var progressBar: IMProgressBar?
    

    
    override func didMove(to view: SKView) {
        let backgroundImage = SKSpriteNode(imageNamed: "Wallpaper.png" )
        backgroundImage.size = self.frame.size
        backgroundImage.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        backgroundImage.isUserInteractionEnabled = true
        self.addChild(backgroundImage)
        
        progressBar = IMProgressBar(emptyImageName: nil,filledImageName: "bar2.png")
        progressBar?.position = CGPoint(x: 200, y: 250)
              
        self.addChild(progressBar!)
    
        
        
        for _ in 1...10 {
                          createTrash()
                     }
        
        paperBin = placeBin(type: "paper-bin.png", pos: CGPoint(x: -120, y: -20))
        plasticBin = placeBin(type: "plastic-bin.png", pos: CGPoint(x: 30, y: -20))
        trashBin = placeBin(type: "trash-bin.png", pos: CGPoint(x: 180, y: -20))
        cansBin = placeBin(type: "cans-bin.png", pos: CGPoint(x: 330, y: -20))
        
    }
    
    func placeBin(type: String, pos: CGPoint) -> SKSpriteNode {
        let bin = SKSpriteNode(imageNamed: type)
        bin.zPosition = 1
        bin.size = CGSize(width: 150, height: 200)
        bin.position = pos
        bin.isUserInteractionEnabled = true
        self.addChild(bin)
        return bin
    }
    
    func createTrash() {
        let category = randomElem.randomElement()
        let trash = SKSpriteNode(imageNamed: category!)
        trash.zPosition = 2
        trash.size = CGSize(width: 100, height: 100)
        trash.position = randomPosition()
        trash.name = category!
        self.addChild(trash)

        

     }
    
    func randomPosition() -> CGPoint {
          
        let x = Double.random(in: Double(-((view?.bounds.maxX)!/2.0))..<Double((view?.bounds.maxX)!/2.0))
               
        let y = Double.random(in: Double(-((view?.bounds.maxY)!/2.0))..<Double(-(view?.bounds.maxY)!/3.7))
        
        return CGPoint(x: x, y: y)
      }
    

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNewNode = atPoint(location)
            self.selectedNode = touchedNewNode
        self.positionOfNode = touchedNewNode.position
    
            
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            
            self.selectedNode!.position = touch.location(in: self)
        }
        /*if let touch = touches.first, let node = self.selectedNode {
            let touchLocation = touch.location(in: self)
            node.position.x = touchLocation.x
            
    
              node.position = touchLocation
            
        
        }*/
            
    }
    
    func changePosition(node: SKSpriteNode, pos: CGPoint) {
        node.position = pos
        self.selectedNode = nil
            self.positionOfNode = nil
        
    }
    
    func putInBin(node: SKSpriteNode) {
        node.removeFromParent()
        self.selectedNode = nil
        self.positionOfNode = nil
        
        progressBar?.setXProgress(xProgress: 0.7)
        
    }

    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, self.selectedNode != nil {
            selectedNode!.position = touch.location(in: self)
            //self.selectedNode = nil
        }
        
        if let node = self.selectedNode {
            if let x = paperBin?.intersects(node), x == true, node.name == "paper.png" {
                putInBin(node: node as! SKSpriteNode)
            }
            else if let x = plasticBin?.intersects(node), x == true, node.name == "plastic.png" {
                putInBin(node: node as! SKSpriteNode)
            }
            else if let x = trashBin?.intersects(node), x == true, node.name == "bio.png" {
                putInBin(node: node as! SKSpriteNode)
                       }
            else if let x = cansBin?.intersects(node), x == true, node.name == "glas.png" {
                putInBin(node: node as! SKSpriteNode)
                       }
            else {
                
               
                let position = randomPosition()
                let action = SKAction.move(to: position, duration: 1)
                self.selectedNode?.run(action)
                 self.selectedNode = nil
   
                return
            
                //if Double(node.position.y) > Double(-(view?.bounds.maxY)!/2.0) {
                
            //}
        }
        }
    
    
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.selectedNode = nil
        self.positionOfNode = nil
     }
    
    
}

// Load the SKScene from 'GameScene.sks'
let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 700, height: 700))
sceneView.ignoresSiblingOrder = true


if let scene = GameScene(fileNamed: "GameScene") {
    // Set the scale mode to scale to fit the window
    scene.scaleMode = .aspectFill
    
    sceneView.presentScene(scene)
}

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
