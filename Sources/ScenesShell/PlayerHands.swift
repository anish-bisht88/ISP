import Scenes
import Igis
import Foundation

class PlayerHands : RenderableEntity {

    var hands = [Hand]()
    
    var fingers = [1, 1]
    var selectedHand : Int? = nil

    init(type: String) {
        hands[0] = Hand(type: type, isRight: false)
        hands[1] = Hand(type: type, isRight: true)
        super.init(name: "player")
    }

    func setContainsSet(_ set: ContainmentSet, _ elements: ContainmentSet) -> Bool {
        return set.intersection(elements) == (elements)
    }
    
    override func boundingRect() -> Rect {
        return Rect(size: Size(width: Int.max, height: Int.max))
    }

    func selectRight() {
        hands[1].isSelected = true
        hands[0].reset()
        selectedHand = 1
    }

    func selectLeft() {
        hands[1].isSelected = true
        hands[0].reset()
        selectedHand = 0
    }

    func deselectAll() {
        hands[0].isSelected = false
        hands[1].isSelected = false
        selectedHand = nil
    }
        


}
