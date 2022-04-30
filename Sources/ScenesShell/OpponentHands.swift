/*import Scenes
import Igis
import Foundation

class OpponentHands : RenderableEntity {

    let leftHand : Hand
    let rightHand : Hand
    
    var leftFingers = 1
    var rightFingers = 1

    var canvasSize = Size()

    init(type: String) {
        leftHand = Hand(type: type, isRight: false, upsideDown: true)
        rightHand = Hand(type: type, isRight: true, upsideDown: true)
        super.init(name: "opponent")
    }

    override func setup(canvasSize: Size, canvas: Canvas) {
        self.canvasSize = canvasSize
    }

    func flipCoords(_ point: Point) -> Point {
        return Point(x: point.x, y: canvasSize.height-point.y)
    }

    func setContainsSet(_ set: ContainmentSet, _ elements: ContainmentSet) -> Bool {
        return set.intersection(elements) == (elements)
    }


}
*/
