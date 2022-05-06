import Scenes
import Igis

class Hands : RenderableEntity {
    let hands : [Hand]
    var selectedHand : Int? = nil

    var handValues = [1, 1]
    
    init(type: String, positionRatios: [[Double]], initialNumbers : [Int] = [1, 1], rotations : [Double] = [0,0]) {
        var tempArray = [Hand]()
        for index  in 0..<positionRatios.count {
            tempArray.append(Hand(type: type, positionRatio: positionRatios[index], initialNumber: initialNumbers[index], rotation: rotations[index]))
        }
        self.hands = tempArray
    }

    func select(_ n: Int) {
        precondition(n < hands.count && n >= 0, "given value does not correspond to a hand")
        hands[n].isSelected = true
        selectedHand = n

        for index in 0..<hands.count {
            if index != n {
                hands[index].reset()
            }
        }
    }

    func add (_ n: Int, to handIndex: Int) {
        precondition(handIndex < hands.count && handIndex >= 0, "given value does not correspond to a hand")
        self.handValues[handIndex] = (self.handValues[handIndex]+n)%5
        self.hands[handIndex].changeHand(self.handValues[handIndex], debug: true)
        if handValues[handIndex] == 0 {
            self.hands[handIndex].isOut = true
        }
    }

    func deselect() {
        print("returning hands to original positionballs")
        for index in 0..<hands.count {
            hands[index].reset()
        }
        selectedHand = nil
    }

}
