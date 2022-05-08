import Scenes
import Igis

  /*
     This class is responsible for the interaction Layer.
     Internally, it maintains the RenderableEntities for this layer.
   */


class InteractionLayer : Layer {

    let handHandler : HandHandler

    var time = 0
    var endTime : Int? = nil
    var winCondition = false
    var gameOver = false

    let playerID: Int
    
    init(_ playerID: Int) {
        handHandler = HandHandler(playerID)
        self.playerID = playerID
        // Using a meaningful name can be helpful for debugging
        super.init(name:"Interaction")

        // We insert our RenderableEntities in the constructor
        insert(entity: handHandler.handPairs[0].hands[0], at: .front)
        insert(entity: handHandler.handPairs[0].hands[1], at: .front)

        insert(entity: handHandler.handPairs[1].hands[0], at: .front)
        insert(entity: handHandler.handPairs[1].hands[1], at: .front)
        
        insert(entity: handHandler, at: .front)
    }

    override func preCalculate(canvas: Canvas) {
        time += 1
        if let winner = HandHandler.winner, !winCondition {
            endTime = time
            winCondition = true
            Global.winner = winner
        }else if let endTime = self.endTime, !gameOver {
            if time > 30+endTime {
                remove(entity: handHandler)
                insert(entity:EndScreen(playerID), at: .front)
                gameOver = true
                print("ending game...")
            }
        }
    }
}
