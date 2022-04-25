import Scenes
import Igis

  /*
     This class is responsible for the interaction Layer.
     Internally, it maintains the RenderableEntities for this layer.
   */


class InteractionLayer : Layer {
    let handHandler = HandHandler()

    
    init() {
        // Using a meaningful name can be helpful for debugging
        super.init(name:"Interaction")

        // We insert our RenderableEntities in the constructor

        
        
        insert(entity: handHandler.playerHands, at: .front)
        insert(entity: handHandler.playerHands.rightHand, at: .front)
        insert(entity: handHandler.playerHands.leftHand, at: .front)

        insert(entity: handHandler.opponentHands, at: .front)
        insert(entity: handHandler.opponentHands.rightHand, at: .front)
        insert(entity: handHandler.opponentHands.leftHand, at: .front)

        insert(entity: handHandler, at: .front)
        
    }
}
