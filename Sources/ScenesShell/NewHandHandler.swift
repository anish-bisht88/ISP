import Scenes
import Igis
import Foundation

class NewHandHandler : RenderableEntity, EntityMouseClickHandler, MouseMoveHandler {

    static let leftHands = LeftHands()
    static let rightHands = RightHands()

    
    static var players = 0
    let playerID : Int
    let playerCounter : PlayerCounter
    
    
    
    init() {
        self.playerID = NewHandHandler.players
        NewHandHandler.players += 1
        playerCounter = PlayerCounter(self.playerID)
    }

    func onEntityMouseClick(globalLocation:Point) {
        switch playerCounter.playerID {
        case PlayerCounter.joinedPlayerIDs[0]:
            playerOneClick()
        case PlayerCounter.joinedPlayerIDs[1]:
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
    }
    override func boundingRect() -> Rect {
        return Rect(size: Size(width: Int.max, height: Int.max))
    }




}
