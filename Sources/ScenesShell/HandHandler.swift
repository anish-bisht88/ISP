import Scenes
import Igis
import Foundation

class HandHandler : RenderableEntity, EntityMouseClickHandler, MouseMoveHandler {

    let playerHands = PlayerHands(type: "test")
    let opponentHands = OpponentHands(type: "test")

    static var playersJoined = [false, false]

    enum PlayerType : Int {
        case playerOne
        case playerTwo
        case spectator
    }

    var isTurn = false

    var player = PlayerType.spectator

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
        print("isTurn: \(isTurn)")
        if isTurn {
            let rightHandContainment = playerHands.rightHand.destRect.containment(target: globalLocation)
            let leftHandContainment = playerHands.leftHand.destRect.containment(target: globalLocation)
            if setContainsSet(rightHandContainment, [.containedFully]) && !playerHands.rightHand.isSelected {
                playerHands.rightHand.isSelected = true
                playerHands.leftHand.reset()
            } else if setContainsSet(leftHandContainment, [.containedFully]) && !playerHands.leftHand.isSelected {
                playerHands.leftHand.isSelected = true
                playerHands.rightHand.reset()
            } else {
                playerHands.leftHand.reset()
                playerHands.rightHand.reset()
            }
        }
        
    }

    func onMouseMove(globalLocation:Point, movement:Point) {
        if playerHands.rightHand.isSelected {
            playerHands.rightHand.move(globalLocation)
        } else if playerHands.leftHand.isSelected {
            playerHands.leftHand.move(globalLocation)
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

