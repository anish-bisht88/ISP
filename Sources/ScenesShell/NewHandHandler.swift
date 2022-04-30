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


    var canvasSize = Size()


    
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
        /*print("total joined: \(NewHandHandler.players-1)")
        print("playerID: \(playerID)")
        print("1st and 2nd player join status: \(NewHandHandler.joinedPlayers)")
        print("1st and 2nd player IDs: \(NewHandHandler.joinedPlayerIDs)")*/
    }

    deinit {
        print("test")
    }
        

    override func setup(canvasSize: Size, canvas: Canvas) {
        dispatcher.registerEntityMouseClickHandler(handler:self)
        dispatcher.registerMouseMoveHandler(handler:self)
        self.canvasSize = canvasSize
    }

    func onEntityMouseClick(globalLocation:Point) {
        print(playerID, NewHandHandler.joinedPlayerIDs)
        switch playerID {
        case NewHandHandler.joinedPlayerIDs[0]:
            playerOneClick(globalLocation)
        case NewHandHandler.joinedPlayerIDs[1]:
            playerTwoClick(globalLocation)
        default:
            break
        }
        
    }

    func onMouseMove(globalLocation:Point, movement:Point) {
        print(globalLocation)
    }


    func playerOneMove() {
    }

    func playerTwoMove() {
    }

    func playerOneClick(_ point: Point) {
        let leftHandContainment = RightHands.leftHand.destRect.containment(target: point)
        
    }

    func playerTwoClick(_ point: Point) {
    }
    
    

    override func teardown() {
        dispatcher.unregisterEntityMouseClickHandler(handler:self)
        dispatcher.unregisterMouseMoveHandler(handler:self)
        for index in 0..<NewHandHandler.joinedPlayerIDs.count {
            if self.playerID == NewHandHandler.joinedPlayerIDs[index] {
                NewHandHandler.joinedPlayers[index] = false
            }
        }
        print("player \(playerID-1) left)")
    }


    override func boundingRect() -> Rect {
        return Rect(size: Size(width: Int.max, height: Int.max))
    }

    override func hitTest(globalLocation: Point) -> Bool {
        let rect = Rect(topLeft: Point.zero, size: canvasSize)
        let containment = rect.containment(target: globalLocation)
        return !containment.contains(.containedFully)
    }

    func setContainsSet(_ set: ContainmentSet, _ elements: ContainmentSet) -> Bool {
        return set.intersection(elements) == (elements)
    }
}
