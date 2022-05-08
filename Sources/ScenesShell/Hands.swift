import Scenes
import Igis

class Hands : RenderableEntity {
    let hands : [Hand]
    var selectedHand : Int? = nil

    var handValues = [1, 1]
    
    init(type: String, positionRatios: [[Double]], initialNumbers : [Int] = [1, 1], rotationIndexes : [Int] = [0,0]) {
        var tempArray = [Hand]()
        for index  in 0..<positionRatios.count {
            tempArray.append(Hand(type: type, positionRatio: positionRatios[index], initialNumber: initialNumbers[index], rotationIndex: rotationIndexes[index]))
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
        print("adding \(n) to hand \(handIndex), current value is \(self.handValues[handIndex])")
        self.handValues[handIndex] = (self.handValues[handIndex]+n)%5
        if handValues[handIndex] == 0 {
            self.hands[handIndex].isOut = true
        }
        print("new value is \(self.handValues[handIndex])")
    }
    
    func subtract (_ n: Int, from handIndex: Int) {
        precondition(handIndex < hands.count && handIndex >= 0, "given value does not correspond to a hand")
        if (handValues[handIndex] == 0)||(n > handValues[handIndex]) {
            return
        }
        print("subtracting \(n) from \(handIndex)")
        self.handValues[handIndex] = (self.handValues[handIndex]-n)
        if handValues[handIndex] == 0 {
            self.hands[handIndex].isOut = true
        }
    }

    func deselect() {
        for index in 0..<hands.count {
            hands[index].reset()
        }
        selectedHand = nil
    }

    func changeSkin(_ str: String) {
        for hand in hands {
            hand.changeSkin(str)
        }
    }

}
