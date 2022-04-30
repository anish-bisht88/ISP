import Scenes
import Igis
import Foundation

class NewHandHandler : RenderableEntity, EntityMouseClickHandler, MouseMoveHandler {

    static let leftHands = LeftHands()
    static let rightHands = RightHands()

    static var players = 0
    let playerID : Int
    
    static var joinedPlayers = [false, false]
    static var joinedPlayerIDs = [0, 1]

    
    
    
    init() {
        playerID = NewHandHandler.players
        NewHandHandler.players += 1

        playerCheck: for index in 0..<NewHandHandler.joinedPlayers.count {
            if !NewHandHandler.joinedPlayers[index] {
                NewHandHandler.joinedPlayerIDs[index] = self.playerID
                NewHandHandler.joinedPlayers[index] = true
                break playerCheck
            }
        }
        super.init(name: "Hand Handler")
    }

    func onEntityMouseClick(globalLocation:Point) {
        switch playerID {
        case NewHandHandler.joinedPlayerIDs[0]:
            playerOneClick()
        case NewHandHandler.joinedPlayerIDs[1]:
            playerTwoClick()
        default:
            break
        }
        
    }

    func onMouseMove(globalLocation:Point, movement:Point) {
    }

    func playerOneMove() {
    }

    func playerTwoMove() {
    }

    func playerOneClick() {
    }

    func playerTwoClick() {
    }
    
    func setContainsSet(_ set: ContainmentSet, _ elements: ContainmentSet) -> Bool {
        return set.intersection(elements) == (elements)
    }

    override func teardown() {
        dispatcher.unregisterEntityMouseClickHandler(handler:self)
        dispatcher.unregisterMouseMoveHandler(handler:self)

        for index in 0..<NewHandHandler.joinedPlayerIDs.count {
            if self.playerID == NewHandHandler.joinedPlayerIDs[index] {
                NewHandHandler.joinedPlayers[index] = false
            }
        }
    }
    override func boundingRect() -> Rect {
        return Rect(size: Size(width: Int.max, height: Int.max))
    }




}
