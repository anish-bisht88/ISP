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
        insert(entity: handHandler.handPairs[0].hands[0], at: .front)
        insert(entity: handHandler.handPairs[0].hands[1], at: .front)

        insert(entity: handHandler.handPairs[1].hands[0], at: .front)
        insert(entity: handHandler.handPairs[1].hands[1], at: .front)
        
        insert(entity: handHandler, at: .front)
    }
}
