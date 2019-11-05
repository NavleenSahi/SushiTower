
import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {

    
  
        func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
            
        }
        
        @IBOutlet weak var Labbel: WKInterfaceLabel!
        // 1: Session property
        private var session = WCSession.default
        
      
        
        
        //Requirement 1, receiving message from phone
        func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
            
            Labbel.setText(message["Key"] as? String)
        }
      
        
        override func awake(withContext context: Any?) {
            super.awake(withContext: context)
        }
        
        override func willActivate() {
            super.willActivate()
            
            if WCSession.isSupported() {
                let session = WCSession.default
                session.delegate = self
                session.activate()
                
                print("watch session")
            }
            
            // 1. Tell watch how many rows you want
            // blue = name of table outlet
            // pink = name of your data source
            // yellow = id for your row
            
            
        }
        
    @IBAction func MoveLeft() {
        
        let mainMessage = ["Value":"1"]
        print("Moving Left")
        if (WCSession.default.isReachable) {
            session.sendMessage(mainMessage,
                                replyHandler: nil, errorHandler: {error in
                // catch any errors here
                print("error received is \(error)")
            })
        }
     
        
    }
    @IBAction func MoveRight() {
        
        let mainMessage = ["Value":"2"]
        print("Moving Right")
        if (WCSession.default.isReachable) {
            session.sendMessage(mainMessage,
                                replyHandler: nil , errorHandler: {error in
                // catch any errors here
                print("error received is \(error)")
            })
        }
    }
    //Requirement 2 , sending message to phone and receiving an ACK in return
    
}

