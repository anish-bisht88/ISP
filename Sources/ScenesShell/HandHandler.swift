import Scenes
import Igis
import Foundation

class HandHandler : RenderableEntity, EntityMouseClickHandler, MouseMoveHandler {

    let playerHands = PlayerHands(type: "test")
    let opponentHands = OpponentHands(type: "test")

    static var playersJoined = [false, false]
    static var hands = [[1, 1], [1, 1]]
    static var updateNeeded = true

    enum PlayerType : Int {
        case playerOne
        case playerTwo
        case spectator
    }



    var isTurn = false
    var player = PlayerType.spectator
    static var currentPlayer = PlayerType.playerOne

    init() {
        playerCheck: for index in 0..<HandHandler.playersJoined.count {
            if !HandHandler.playersJoined[index] {
                self.player = PlayerType(rawValue: index)!
                HandHandler.playersJoined[index] = true
                break playerCheck
            }
        }

        super.init(name: "hand handler")
    }

    func onEntityMouseClick(globalLocation:Point) {
        if isTurn {
            let rightHandContainment = playerHands.hands[1].destRect.containment(target: globalLocation)
            let leftHandContainment = playerHands.hands[0].destRect.containment(target: globalLocation)
            
            if rightHandContainment.contains(.containedFully) && !playerHands.hands[1].isSelected { // click on right hand
                playerHands.selectRight()
            } else if leftHandContainment.contains(.containedFully) && !playerHands.hands[0].isSelected { // click on left hand
                playerHands.selectLeft()
            } else if let selectedHand = playerHands.selectedHand {
                let opponentRightHandContainment = opponentHands.rightHand.destRect.containment(target: globalLocation)
                let opponentLeftHandContainment = opponentHands.leftHand.destRect.containment(target: globalLocation)
                if opponentRightHandContainment.contains(.containedFully) {
                    addToOpponent(to: 1, amount: playerHands.fingers[selectedHand])
                } else if opponentLeftHandContainment.contains(.containedFully) {
                    addToOpponent(to: 0, amount: playerHands.fingers[selectedHand])
                } else {
                playerHands.deselectAll()
                }
            }
        }
    }

    func addToOpponent(to hand: Int, amount: Int) {
        switch player {
        case .playerOne:
            HandHandler.hands[1][hand] += amount
            HandHandler.hands[1][hand] %= 5
        case .playerTwo:
            HandHandler.hands[0][hand] += amount
            HandHandler.hands[0][hand] %= 5
        default:
            fatalError("Cannot add to opponent as spectator")
        }
    }

    func onMouseMove(globalLocation:Point, movement:Point) {
        if let selectedHand = playerHands.selectedHand {
            playerHands.hands[selectedHand].move(globalLocation)
        } 
    }

    override func setup(canvasSize: Size, canvas: Canvas) {
        dispatcher.registerEntityMouseClickHandler(handler:self)
        dispatcher.registerMouseMoveHandler(handler:self)
        if player == .playerOne {
            isTurn = true
        } else if player == .playerTwo {
            isTurn = false
        }
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

