import Scenes
import Igis

  /*
     This class is responsible for the interaction Layer.
     Internally, it maintains the RenderableEntities for this layer.
   */


class InteractionLayer : Layer {
    let handHandler = NewHandHandler()

    
    init() {
        
        // Using a meaningful name can be helpful for debugging
        super.init(name:"Interaction")

        // We insert our RenderableEntities in the constructor
        
        insert(entity: LeftHands.leftHand, at: .front)
        insert(entity: LeftHands.rightHand, at: .front)
        insert(entity: RightHands.leftHand, at: .front)
        insert(entity: RightHands.rightHand, at: .front)
        insert(entity: handHandler, at: .front)
            
        /*insert(entity: handHandler.playerHands, at: .front)
        insert(entity: handHandler.playerHands.hands[0], at: .front)
        insert(entity: handHandler.playerHands.hands[1], at: .front)

        insert(entity: handHandler.opponentHands, at: .front)
        insert(entity: handHandler.opponentHands.rightHand, at: .front)
        insert(entity: handHandler.opponentHands.leftHand, at: .front)

        insert(entity: handHandler, at: .front)*/
    }

    override func preTeardown() {
    }
}
