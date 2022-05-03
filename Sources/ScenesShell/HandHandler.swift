import Scenes
import Igis
import Foundation

class HandHandler : RenderableEntity, EntityMouseClickHandler, MouseMoveHandler {

    //make the below arrays !!


    let handPairs = [Hands(type: "test", positionRatios: [[0.25, 0.25], [0.25, 0.75]], initialNumbers: [0, 1]), Hands(type: "test", positionRatios: [[0.75, 0.25], [0.75, 0.75]], initialNumbers: [2, 3])]
    static var activePlayer = 0
    static var handPositions = Array(repeating: Array(repeating: Point.zero, count: 2), count: 2)
    static var originalHandPositions = Array(repeating: Array(repeating: Point.zero, count: 2), count: 2)


    static var players = 0
    let playerID : Int

    static var round = 1
    
    static var joinedPlayers = [false, false]
    static var joinedPlayerIDs = [0, 1]

    var activeState = false

    
    init() {
        playerID = HandHandler.players
        HandHandler.players += 1
        playerCheck: for index in 0..<HandHandler.joinedPlayers.count {
            if !HandHandler.joinedPlayers[index] {
                HandHandler.joinedPlayerIDs[index] = self.playerID
                HandHandler.joinedPlayers[index] = true
                break playerCheck
            }
        }
        super.init(name: "Hand Handler")
    }

    override func setup(canvasSize: Size, canvas: Canvas) {
        dispatcher.registerEntityMouseClickHandler(handler:self)
        dispatcher.registerMouseMoveHandler(handler:self)
    }

    func onEntityMouseClick(globalLocation:Point) {
        var alreadyReset = false
        if HandHandler.activePlayer == playerID {
            let otherPlayer = other(playerID)
            playerHandCheck:  for index in 0..<handPairs[playerID].hands.count {
                let containment = handPairs[playerID].hands[index].destRect.containment(target: globalLocation)
                if containment.contains(.containedFully) && !handPairs[playerID].hands[index].isSelected  {
                    handPairs[playerID].select(index)
                    print("selected hand", index)
                    alreadyReset = true
                }
            }
            opponenthandCheck: for index in 0..<handPairs[otherPlayer].hands.count {
                let containment = handPairs[otherPlayer].hands[index].destRect.containment(target: globalLocation)
                if containment.contains(.containedFully) {
                    //placeholder add to hand
                    print("tapped opponent")
                    handPairs[playerID].deselect()
                    alreadyReset = true
                    HandHandler.activePlayer = otherPlayer
                    HandHandler.round += 1
                }
            }
            if !alreadyReset {
                handPairs[playerID].deselect()
            }
        }
        
    }

    func onMouseMove(globalLocation:Point, movement:Point) {
        if HandHandler.activePlayer == playerID {
            if let selectedHand = handPairs[HandHandler.activePlayer].selectedHand {
                handPairs[HandHandler.activePlayer].hands[selectedHand].move(globalLocation)
            }
        }
    }


    override func calculate(canvasSize: Size) {
        activeState = HandHandler.activePlayer == playerID
        if HandHandler.activePlayer == playerID {
            for index  in 0..<handPairs[HandHandler.activePlayer].hands.count {
                HandHandler.handPositions[HandHandler.activePlayer][index] = handPairs[HandHandler.activePlayer].hands[index].destRect.topLeft
            }
            
        }
        else {
            for playerIndex in 0..<handPairs.count {
                for index in 0..<handPairs[playerIndex].hands.count {
                    HandHandler.handPositions[playerID][index] = HandHandler.handPositions[playerID][index]
                }
            }
        }
    }
    

    override func render(canvas: Canvas) {
        if let canvasSize = canvas.canvasSize {
            let text = Text(location: canvasSize.center-Point(x: 200, y: 0), text: "you\(playerID), active\(HandHandler.activePlayer), isActive: \(HandHandler.activePlayer == playerID)")
            let text2 = Text(location: Point.zero + Point(x: 100, y: 100), text: "handPos:\(HandHandler.handPositions)")
            text.font = "12pt Arial"
            let fillStyle = FillStyle(color: Color(.black))
            canvas.render(fillStyle, text, text2)
        }
    }


    override func teardown() {
        dispatcher.unregisterEntityMouseClickHandler(handler:self)
        dispatcher.unregisterMouseMoveHandler(handler:self)
    }

    override func boundingRect() -> Rect {
        return Rect(size: Size(width: Int.max, height: Int.max))
    }

    func setContainsSet(_ set: ContainmentSet, _ elements: ContainmentSet) -> Bool {
        return set.intersection(elements) == (elements)
    }

    func other(_ n : Int) -> Int {
        switch n {
        case 0:
            return 1
        case 1:
            return 0
        default:
            fatalError()
        }
    }
}
