import Scenes
import Igis
import Foundation

class HandHandler : RenderableEntity, EntityMouseClickHandler, MouseMoveHandler {

    //make it default to original position when it's not the active player


    let handPairs = [Hands(type: "test", positionRatios: [[0.25, 0.25], [0.25, 0.75]], initialNumbers: [1, 1]), Hands(type: "test", positionRatios: [[0.75, 0.25], [0.75, 0.75]], initialNumbers: [1,1])]
    static var activePlayer = 0
    static var handPositions = Array(repeating: Array(repeating: Point.zero, count: 2), count: 2)
    static var originalHandPositions = Array(repeating: Array(repeating: Point.zero, count: 2), count: 2)
    static var handValues = Array(repeating: Array(repeating: 1, count: 2), count: 2)


    static var players = 0
    let playerID : Int

    static var round = 1
    
    static var joinedPlayers = [false, false]
    static var joinedPlayerIDs = [0, 1]


    
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
        if playerID == HandHandler.activePlayer {
            for playerIndex in 0..<handPairs.count {
                for handIndex in 0..<handPairs[playerIndex].hands.count {
                    HandHandler.originalHandPositions[playerIndex][handIndex] = handPairs[playerIndex].hands[handIndex].globalLocation
                    print("assigning originalPositions index \(playerIndex),\(handIndex) value \(handPairs[playerIndex].hands[handIndex].globalLocation)")
                }
            }
            HandHandler.handPositions = HandHandler.originalHandPositions
        }
    }

    func onEntityMouseClick(globalLocation:Point) {
        var alreadyReset = false
        if HandHandler.activePlayer == playerID {
            decideAction: do {
                let otherPlayer = other(playerID)
                playerHandCheck:  for index in 0..<handPairs[playerID].hands.count {
                    let containment = handPairs[playerID].hands[index].destRect.containment(target: globalLocation)
                    if containment.contains(.containedFully) && !handPairs[playerID].hands[index].isSelected  {
                        handPairs[playerID].select(index)
                        print("selected hand", index)
                        alreadyReset = true
                        break decideAction
                    }
                }
                if let selectedHand = handPairs[playerID].selectedHand {
                    opponenthandCheck: for index in 0..<handPairs[otherPlayer].hands.count {
                        let containment = handPairs[otherPlayer].hands[index].destRect.containment(target: globalLocation)
                        if containment.contains(.containedFully) && !(HandHandler.handValues[playerID][selectedHand] == 0){
                            handPairs[otherPlayer].add(HandHandler.handValues[playerID][selectedHand], to: index)
                            HandHandler.handValues[otherPlayer][index] = handPairs[otherPlayer].handValues[index]
                            print("tapped opponent")
                            handPairs[playerID].deselect()
                            alreadyReset = true
                            HandHandler.activePlayer = otherPlayer
                            HandHandler.round += 1
                            break decideAction
                        }
                    }
                }
            }
            if !alreadyReset {
                handPairs[playerID].deselect()
            }
            resetHands()
        }
    }

    func onMouseMove(globalLocation:Point, movement:Point) {
        if HandHandler.activePlayer == playerID {
            if let selectedHand = handPairs[HandHandler.activePlayer].selectedHand {
                HandHandler.handPositions[playerID][selectedHand] = (globalLocation)
            }
        }
    }


    override func calculate(canvasSize: Size) {
        /*if HandHandler.activePlayer == playerID { //if you are the player update global position and fingers to your values
            let otherPlayer = other(playerID)
            for index  in 0..<handPairs[playerID].hands.count {
                HandHandler.handPositions[playerID][index] = handPairs[playerID].hands[index].globalLocation
                HandHandler.handValues[playerID] = handPairs[playerID].handValues
            }
            for index in 0..<handPairs[otherPlayer].hands.count {
                HandHandler.handPositions[otherPlayer][index] = HandHandler.originalhandPositions[otherPlayer][index]
            }
        } 
        else { //otherwise get the global values and use them*/
        for playerIndex in 0..<handPairs.count {
            if playerIndex == HandHandler.activePlayer {
                for handIndex in 0..<handPairs[playerIndex].hands.count {
                    handPairs[playerIndex].hands[handIndex].move(HandHandler.handPositions[playerIndex][handIndex])
                    handPairs[playerIndex].hands[handIndex].changeHand(HandHandler.handValues[playerIndex][handIndex])
                }
            } else {
                for handIndex in 0..<handPairs[playerIndex].hands.count {
                    handPairs[playerIndex].hands[handIndex].move(HandHandler.originalHandPositions[playerIndex][handIndex])
                    handPairs[playerIndex].hands[handIndex].changeHand(HandHandler.handValues[playerIndex][handIndex])
                }
            }
        }
    }

    func resetHands() {
        HandHandler.handPositions = HandHandler.originalHandPositions
    }
    

    override func render(canvas: Canvas) {
        if let canvasSize = canvas.canvasSize {
            let text = Text(location: canvasSize.center-Point(x: 200, y: 0), text: "you\(playerID), active\(HandHandler.activePlayer), isActive: \(HandHandler.activePlayer == playerID)")
            let text2 = Text(location: Point.zero + Point(x: 100, y: 100), text: "handPos:\(HandHandler.handPositions)")
            let text3 = Text(location: Point.zero + Point(x: 100, y: 200), text: "handValues:\(HandHandler.handValues)")
            text.font = "12pt Arial"
            let fillStyle = FillStyle(color: Color(.black))
            canvas.render(fillStyle, text, text2, text3)
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
