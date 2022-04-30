import Scenes
import Igis

class PlayerCounter : RenderableEntity {
    
    static var joinedPlayers = [false, false]
    static var joinedPlayerIDs = [0, 1]
    let playerID : Int
    
    init(_ playerID: Int) {
        self.playerID = playerID
        playerCheck: for index in 0..<PlayerCounter.joinedPlayers.count {
            if !PlayerCounter.joinedPlayers[index] {
                PlayerCounter.joinedPlayerIDs[index] = self.playerID
                PlayerCounter.joinedPlayers[index] = true
                break playerCheck
            }
        }
        super.init(name: "Player Counter")
    }

    override func setup(canvasSize: Size, canvas: Canvas) {
        print("1st and 2nd player joined: \(PlayerCounter.joinedPlayers)")
        print("1st and 2nd player ID: \(PlayerCounter.joinedPlayerIDs)")
    }

    override func teardown() {
        for index in 0..<PlayerCounter.joinedPlayerIDs.count {
            if self.playerID == PlayerCounter.joinedPlayerIDs[index] {
                PlayerCounter.joinedPlayers[index] = false
            }
        }
    }
}
