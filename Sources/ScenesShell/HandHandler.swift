import Scenes
import Igis
import Foundation

class HandHandler : RenderableEntity, EntityMouseClickHandler, MouseMoveHandler {

    var numberToSplit = 1

    let handPairs = [Hands(type: "test", positionRatios: [[0.25, 0.25], [0.25, 0.75]], rotationIndexes: [0, 1]), Hands(type: "test", positionRatios: [[0.75, 0.25], [0.75, 0.75]], rotationIndexes: [2, 3])]
    static var activePlayer = 0
    static var handPositions = Array(repeating: Array(repeating: Point.zero, count: 2), count: 2)
    static var originalHandPositions = Array(repeating: Array(repeating: Point.zero, count: 2), count: 2)
    static var handValues = Array(repeating: Array(repeating: 1, count: 2), count: 2)

    
    let playerID : Int

    static var round = 1
    
    static var joinedPlayers = [false, false]
    static var joinedPlayerIDs = [0, 1]

    static var winner : Int? = nil

    let statusText = Text(location: Point.zero, text:"", fillMode: .fillAndStroke)
    let splitText = Text(location: Point.zero, text:"", fillMode: .fillAndStroke)
    let fillStyle = FillStyle(color: Color(.white))
    let strokeStyle = StrokeStyle(color: Color(.black))


    let plusButton : Image
    var plusRect = Rect()
    init(_ playerID: Int) {
        self.playerID = playerID
        playerCheck: for index in 0..<HandHandler.joinedPlayers.count {
            if !HandHandler.joinedPlayers[index] {
                HandHandler.joinedPlayerIDs[index] = self.playerID
                HandHandler.joinedPlayers[index] = true
                break playerCheck
            }
        }
        guard let plusButtonURL = URL(string: "https://codermerlin.com/users/anish-bisht/transparent.png") else {
            fatalError("could not get the url for the plus button")
        }
        plusButton = Image(sourceURL: plusButtonURL)

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
        splitText.location = Point(x: canvasSize.width/2, y: canvasSize.height/6)
        splitText.font = "32pt Arial"
        splitText.alignment = .center
        splitText.text = "Amount to split: 1"
        statusText.location = Point(x: canvasSize.center.x, y: canvasSize.height/10)
        statusText.font = "48pt Arial"
        statusText.alignment = .center
        canvas.setup(plusButton)
        plusRect = Rect(topLeft: Point(x: canvasSize.center.x-50, y: canvasSize.height/5), size: Size(width: 100, height: 100))
        
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
                    else if containment.contains(.containedFully) && handPairs[playerID].hands[other(index)].isSelected && self.numberToSplit <= handPairs[playerID].handValues[other(index)] && self.numberToSplit != 0{
                        let selectedHand = other(index)
                        print("splitting \(self.numberToSplit)")
                        handPairs[playerID].subtract(self.numberToSplit, from: selectedHand)
                        handPairs[playerID].add(self.numberToSplit, to: index)
                        self.syncHands(playerID)
                        self.changeRound()
                    }
                }
                if let selectedHand = handPairs[playerID].selectedHand {
                    let plusButtonContainment = plusRect.containment(target: globalLocation)
                    if plusButtonContainment.contains(.containedFully) {
                        handPairs[playerID].add(1, to:selectedHand)
                        self.syncHands(playerID)
                        self.changeRound()
                        break decideAction
                    }
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
            for index in 0..<HandHandler.handValues.count {
                if HandHandler.handValues[index] == [0,0] {
                    if Global.immolationMode == true {
                        HandHandler.winner = index
                    } else {
                        HandHandler.winner = other(index)
                    }
                }
            }
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
        calculateStatus()
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
        if plusButton.isReady {
            plusButton.renderMode = .destinationRect(plusRect)
            canvas.render(fillStyle, strokeStyle, statusText, plusButton)
        }
        if playerID == HandHandler.activePlayer {
            canvas.render(fillStyle, strokeStyle, splitText) //text, text2, text3, text4)
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
        if let num = Int(key), HandHandler.joinedPlayerIDs.contains(playerID){
            if num <= 5 && num > 0 {
                self.numberToSplit = num
                splitText.text = "Amount to split: \(self.numberToSplit)"
            }
        }
    }

    func calculateStatus() {
        let text: String
        switch playerID {
        case HandHandler.activePlayer:
            text = "Your turn (\(playerID == 0 ? "left" : "right"))"
        case other(HandHandler.activePlayer):
            text = "Opponent's turn (\(playerID != 0 ? "left" : "right"))"
        default:
            text = "You are spectating"
        }
        self.statusText.text = text
        
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
