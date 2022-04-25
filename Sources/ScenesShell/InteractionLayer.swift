import Scenes
import Igis

  /*
     This class is responsible for the interaction Layer.
     Internally, it maintains the RenderableEntities for this layer.
   */


class InteractionLayer : Layer {
    let playerHands = PlayerHands(type: "test")
    let opponentHands = OpponentHands(type: "test")

    static var players = 0
    let player : Int

    
    init() {
        InteractionLayer.players += 1
        player = InteractionLayer.players
        print("new player: \(player)")
        // Using a meaningful name can be helpful for debugging
        super.init(name:"Interaction")

        // We insert our RenderableEntities in the constructor
        insert(entity: playerHands, at: .front)
        insert(entity: playerHands.rightHand, at: .front)
        insert(entity: playerHands.leftHand, at: .front)

        insert(entity: opponentHands, at: .front)
        insert(entity: opponentHands.rightHand, at: .front)
        insert(entity: opponentHands.leftHand, at: .front)
        
    }

    override func preSetup(canvasSize: Size, canvas: Canvas) {
        switch player {
        case 1:
            print("player 1 gets first move")
            playerHands.enableInput()
        case 2:
            playerHands.disableInput()
        default:
            fatalError()
        }
    }




}
