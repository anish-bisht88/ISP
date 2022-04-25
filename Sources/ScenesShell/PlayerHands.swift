import Scenes
import Igis
import Foundation

class PlayerHands : RenderableEntity, EntityMouseClickHandler, MouseMoveHandler {

    let leftHand : Hand
    let rightHand : Hand

    init(type: String) {
        leftHand = Hand(type: type, isRight: false)
        rightHand = Hand(type: type, isRight: true)
        super.init(name: "player")
    }

    func onEntityMouseClick(globalLocation:Point) {
        let rightHandContainment = rightHand.destRect.containment(target: globalLocation)
        let leftHandContainment = leftHand.destRect.containment(target: globalLocation)
        if setContainsSet(rightHandContainment, [.containedFully]) && !rightHand.isSelected {
            rightHand.isSelected = true
            leftHand.reset()
        } else if setContainsSet(leftHandContainment, [.containedFully]) && !leftHand.isSelected {
            leftHand.isSelected = true
            rightHand.reset()
        } else {
            leftHand.reset()
            rightHand.reset()
        }
        
    }

    func onMouseMove(globalLocation:Point, movement:Point) {
        if rightHand.isSelected {
            rightHand.move(globalLocation)
        } else if leftHand.isSelected {
            leftHand.move(globalLocation)
        }
    }

    override func setup(canvasSize: Size, canvas: Canvas) {
        dispatcher.registerEntityMouseClickHandler(handler:self)
        dispatcher.registerMouseMoveHandler(handler:self)
    }

    func setContainsSet(_ set: ContainmentSet, _ elements: ContainmentSet) -> Bool {
        return set.intersection(elements) == (elements)
    }

    func disableInput() {
        leftHand.isEnabled = false
        rightHand.isEnabled = false
    }

    func enableInput() {
        leftHand.isEnabled = true
        rightHand.isEnabled = true
    }

    override func teardown() {
        dispatcher.unregisterEntityMouseClickHandler(handler:self)
        dispatcher.unregisterMouseMoveHandler(handler:self)
    }
    override func boundingRect() -> Rect {
        return Rect(size: Size(width: Int.max, height: Int.max))
    }




}
