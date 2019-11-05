import SpriteKit
import GameplayKit
import WatchConnectivity

class GameScene: SKScene, WCSessionDelegate {
    
    var Value:String = "";
    /////watch code
    
    var session: WCSession!
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
    if(WCSession.isSupported()) {
    
    let session = WCSession.default
    session.delegate = self
    session.activate()
    }
    else{
        
    //  getMessage.text = ("Phone can not connect to the watch")
        }
        
    }

    
    //sending message to watch
//    @IBAction func sendFirstMessage(_ sender: Any) {
    func SendMessage(value:String){
        let msg = ["Key": value]
        WCSession.default.sendMessage(msg, replyHandler: nil)
    }
    //end watch code
    
    var startTime = 25
    var GameTimer = Timer()
    
    let cat = SKSpriteNode(imageNamed: "character1")
    let sushiBase = SKSpriteNode(imageNamed:"roll")
    
    //Life Bar
    let life_bg = SKSpriteNode(imageNamed: "life_bg")
    let life = SKSpriteNode(imageNamed: "life")
    //Game Over
    let gameover = SKSpriteNode(imageNamed: "gameOver")
    
    // Make a tower
    var sushiTower:[SushiPiece] = []
    let SUSHI_PIECE_GAP:CGFloat = 80
    
    let scoreLabel = SKLabelNode(text:"Score: ")
     var score = 0
    // Make variables to store current position
    var catPosition = "left"
    
    //TIMER FUNCTION
    
    @objc func timerrun(){
      
        life.size.width -= 5.44
       startTime -= 1
        if(startTime == 15)
        {
            SendMessage(value: "15 Seconds Left")
        }
        if(startTime == 10)
        {
             SendMessage(value: "10 Seconds Left")
        }
        if(startTime == 5) {
             SendMessage(value: "5 Seconds Left")
        }
        if(startTime == 0)
        {
              SendMessage(value: "Game Over")
            GameTimer.invalidate()
            startTime = 0
            life.size.width = 0
            gameover.position = CGPoint(x:self.size.width / 2, y:self.size.height / 2)
            gameover.zPosition = 1
            addChild(gameover)
        }
        
    }
    
    
    func spawnSushi() {
        
        // -----------------------
        // MARK: PART 1: ADD SUSHI TO GAME
        // -----------------------
        
        // 1. Make a sushi
        let sushi = SushiPiece(imageNamed:"roll")
        
        // 2. Position sushi 10px above the previous one
        if (self.sushiTower.count == 0) {
            // Sushi tower is empty, so position the piece above the base piece
            sushi.position.y = sushiBase.position.y
                + SUSHI_PIECE_GAP
            sushi.position.x = self.size.width*0.5
        }
        else {
            // OPTION 1 syntax: let previousSushi = sushiTower.last
            // OPTION 2 syntax:
            let previousSushi = sushiTower[self.sushiTower.count - 1]
            sushi.position.y = previousSushi.position.y + SUSHI_PIECE_GAP
            sushi.position.x = self.size.width*0.5
        }
        
        // 3. Add sushi to screen
        addChild(sushi)
        
        // 4. Add sushi to array
        self.sushiTower.append(sushi)
    }
        
        // Add this if you cannot see the chopsticks
        // sushi.zPosition = -1
    
    
    override func didMove(to view: SKView) {
        
        //RUNNING THE TIMER
        GameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameScene.timerrun), userInfo: nil, repeats: true)
        
        // add background
        let background = SKSpriteNode(imageNamed: "background")
        background.size = self.size
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        background.zPosition = -1
        addChild(background)
        
        // add cat
        cat.position = CGPoint(x:self.size.width*0.25, y:100)
        addChild(cat)
        
        // add base sushi pieces
        sushiBase.position = CGPoint(x:self.size.width*0.5, y: 100)
        addChild(sushiBase)
        
        
       
        
        // build the tower
        self.buildTower()
        
        //add life
        life_bg.position = CGPoint(x:self.size.width / 2, y:self.size.height - 100)
//        life_bg.anchorPoint = CGPoint(x: 0,y: 0)
        addChild(life_bg)
        life.position = CGPoint(x: (self.size.width/2 - life_bg.size.width/2) + 10, y:self.size.height - 110)
        life.anchorPoint = CGPoint(x: 0,y: 0)
//        life.size.width -= 80;
        //136
         print(life.size.width)
        life.zPosition = 2
        addChild(life)
        
        self.scoreLabel.position.x = 50
        self.scoreLabel.position.y = size.height - 150
        self.scoreLabel.fontName = "Avenir"
        self.scoreLabel.fontSize = 30
        self.scoreLabel.zPosition = 3
        addChild(scoreLabel)
        
        
    }
    
    func buildTower() {
        for _ in 0...10 {
            self.spawnSushi()
        }
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
    }
    
    
    
    //receiving message from watch
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        //handle received message
        Value = message["Value"] as! String

        
        // ------------------------------------
        // MARK: UPDATE THE SUSHI TOWER GRAPHICS
        //  When person taps mouse,
        //  remove a piece from the tower & redraw the tower
        // -------------------------------------
        if(startTime > 0)
        {
            let pieceToRemove = self.sushiTower.first
            if (pieceToRemove != nil) {
                // SUSHI: hide it from the screen & remove from game logic
                pieceToRemove!.removeFromParent()
                self.sushiTower.remove(at: 0)
                
                // SUSHI: loop through the remaining pieces and redraw the Tower
                for piece in sushiTower {
                    piece.position.y = piece.position.y - SUSHI_PIECE_GAP
                }
                
                // To make the tower inifnite, then ADD a new piece
                self.spawnSushi()
            }
        }
        // ------------------------------------
        // MARK: SWAP THE LEFT & RIGHT POSITION OF THE CAT
        //  If person taps left side, then move cat left
        //  If person taps right side, move cat right
        // -------------------------------------
        
        // 1. detect where person clicked
       // let middleOfScreen  = self.size.width / 2
        if (Value == "1" && startTime > 0) {
            print("TAP LEFT")
            // 2. person clicked left, so move cat left
            cat.position = CGPoint(x:self.size.width*0.25, y:100)
            
            // change the cat's direction
            let facingRight = SKAction.scaleX(to: 1, duration: 0)
            self.cat.run(facingRight)
            
            // save cat's position
            self.catPosition = "left"
        }
        else if (Value == "2" && startTime > 0) {
            print("TAP RIGHT")
            // 2. person clicked right, so move cat right
            cat.position = CGPoint(x:self.size.width*0.85, y:100)
            
            // change the cat's direction
            let facingLeft = SKAction.scaleX(to: -1, duration: 0)
            self.cat.run(facingLeft)
            
            // save cat's position
            self.catPosition = "right"
        }
        
        // ------------------------------------
        // MARK: ANIMATION OF PUNCHING CAT
        // -------------------------------------
        
        // show animation of cat punching tower
        let image1 = SKTexture(imageNamed: "character1")
        let image2 = SKTexture(imageNamed: "character2")
        let image3 = SKTexture(imageNamed: "character3")
        
        let punchTextures = [image1, image2, image3, image1]
        
        let punchAnimation = SKAction.animate(
            with: punchTextures,
            timePerFrame: 0.1)
        
        self.cat.run(punchAnimation)
        
        
        // ------------------------------------
        // MARK: WIN AND LOSE CONDITIONS
        // -------------------------------------
        if (self.sushiTower.count > 0) {
            // 1. if CAT and STICK are on same side - OKAY, keep going
            // 2. if CAT and STICK are on opposite sides -- YOU LOSE
            let firstSushi:SushiPiece = self.sushiTower[0]
            let chopstickPosition = firstSushi.stickPosition
            
            if (catPosition == chopstickPosition && startTime != 0) {
                // cat = left && chopstick == left
                // cat == right && chopstick == right
                print("Cat Position = \(catPosition)")
                print("Stick Position = \(chopstickPosition)")
                print("Conclusion = LOSE")
                print("------")
                SendMessage(value: "Game Over")
                GameTimer.invalidate()
                startTime = 0
               // life.size.width = 0
                gameover.position = CGPoint(x:self.size.width / 2, y:self.size.height / 2)
                gameover.zPosition = 1
                addChild(gameover)
                
             
            }
            else if (catPosition != chopstickPosition &&  startTime != 0) {
                // cat == left && chopstick = right
                // cat == right && chopstick = left
                print("Cat Position = \(catPosition)")
                print("Stick Position = \(chopstickPosition)")
                print("Conclusion = WIN")
                print("------")
                
                self.score = self.score + 1
                self.scoreLabel.text = "Score: \(self.score)"
                
            }
        }
            
        else {
            print("Sushi tower is empty!")
        }
        
        
        
    }
    
}

