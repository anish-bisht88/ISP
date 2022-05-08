import Scenes
import Igis
import Foundation

class HandHandler : RenderableEntity, EntityMouseClickHandler, MouseMoveHandler {

    var numberToSplit = 1

    let handPairs = [Hands(type: "test", positionRatios: [[0.25, 0.25], [0.25, 0.75]]), Hands(type: "test", positionRatios: [[0.75, 0.25], [0.75, 0.75]], initialNumbers: [1,1])]
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
                    if containment.contains(.containedFully) && (handPairs[playerID].selectedHand == nil) && !(HandHandler.handValues[playerID][index] == 0)  {
                        handPairs[playerID].select(index)
                        alreadyReset = true
                        break decideAction
                    }
                    else if containment.contains(.containedFully) && handPairs[playerID].hands[other(index)].isSelected && self.numberToSplit <= handPairs[playerID].handValues[other(index)]{
                        let selectedHand = other(index)
                        print("splitting \(self.numberToSplit)")
                        handPairs[playerID].subtract(self.numberToSplit, from: selectedHand)
                        handPairs[playerID].add(self.numberToSplit, to: index)
                        self.syncHands(playerID)
                        self.changeRound()
                    }
                }
                if let selectedHand = handPairs[playerID].selectedHand {
                    
                    opponenthandCheck: for index in 0..<handPairs[otherPlayer].hands.count {
                        let containment = handPairs[otherPlayer].hands[index].destRect.containment(target: globalLocation)
                        if containment.contains(.containedFully) && (HandHandler.handValues[playerID][selectedHand] != 0) && (HandHandler.handValues[otherPlayer][index] != 0) {
                            handPairs[otherPlayer].add(HandHandler.handValues[playerID][selectedHand], to: index)
                            HandHandler.handValues[otherPlayer][index] = handPairs[otherPlayer].handValues[index]
                            handPairs[playerID].deselect()
                            alreadyReset = true
                            self.changeRound()
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
        for playerIndex in 0..<handPairs.count {
            handPairs[playerIndex].handValues = HandHandler.handValues[playerIndex]
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
            let text2 = Text(location: canvasSize.center + Point(x: 100, y: 100), text: "handPos:\(HandHandler.handPositions)")
            let text3 = Text(location: canvasSize.center + Point(x: 100, y: 200), text: "handValues:\(HandHandler.handValues)")
            let text4 = Text(location: canvasSize.center + Point(x: 100, y: 250), text: "local handValues:\([handPairs[0].handValues, handPairs[1].handValues])")
            let splitText = Text(location: Point(x: canvasSize.width/2, y: canvasSize.height/5), text: "Amount to split: \(self.numberToSplit)")
            splitText.font = "12pt Arial"
            splitText.alignment = .center
            let fillStyle = FillStyle(color: Color(.black))
            canvas.render(fillStyle, splitText, text, text2, text3, text4)
        }
    }

    func syncHands(_ playerID : Int) {
        HandHandler.handValues[playerID] = handPairs[playerID].handValues
    }
    func changeRound() {
        HandHandler.round += 1
        HandHandler.activePlayer = other(self.playerID)
    }
    
    public func onKeyDown(key:String, code:String, ctrlKey:Bool, shiftKey:Bool, altKey:Bool, metaKey:Bool) {
        print(key, code)
        if let num = Int(key) {
            if num <= 5 && num > 0 {
                self.numberToSplit = num
            }
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
