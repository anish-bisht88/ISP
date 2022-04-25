import Scenes
import Igis
import Foundation

class PlayerHands : RenderableEntity {

    let leftHand : Hand
    let rightHand : Hand

    init(type: String) {
        leftHand = Hand(type: type, isRight: false)
        rightHand = Hand(type: type, isRight: true)
        super.init(name: "player")
    }

    func setContainsSet(_ set: ContainmentSet, _ elements: ContainmentSet) -> Bool {
        return set.intersection(elements) == (elements)
    }
    
    override func boundingRect() -> Rect {
        return Rect(size: Size(width: Int.max, height: Int.max))
    }




}
