
import Scenes
import Igis

/*
 This class is responsible for the foreground Layer.
 Internally, it maintains the RenderableEntities for this layer.
 */


class MainMenu : Layer {

    static var players = 0
    let playerID : Int
    
    let list : List
    let waitTextBox = TextBox("Waiting for other player")
    static let voteTextBox = TextBox("Press the spacebar to toggle your vote for self-immolation mode!", locationRatios: [0.5, 0.9])

    static var arrayInitialized = false
    static var immolationVotes = [false, false]

    init(_ playerID: Int) {
        if !MainMenu.arrayInitialized {
            Global.playerSkins = [nil, nil]
            MainMenu.arrayInitialized = true
        }
        self.playerID = playerID

        list = List(labels: ["kent", "minion", "black"], images: [Global.kentURL, Global.minionURL, Global.blackURL], sizes: Array(repeating: Global.sheetSize, count: 3), title: "Welcome to Sticks!", subtitle: "Click the text corresponding to your desired skin to select it!",  playerID: playerID)

        
        // Using a meaningful name can be helpful for debugging
        super.init(name:"MainMenu")

        // We insert our RenderableEntities in the constructor
        if playerID < 2 {
            insert(entity: list, at: .front)
            insert(entity: MainMenu.voteTextBox, at: .front)
        } else {
            insert(entity: waitTextBox, at: .front)
            
        }
    }

    override func postCalculate(canvas: Canvas) {
        if playerID < 2 {
            if Global.playerSkins[playerID] != nil {
                insert(entity: waitTextBox, at: .front)
            }
        } 
    }

    public static func updateVotes() {
        MainMenu.voteTextBox.changeText("Press space to toggle your vote for self-immolation mode! (current votes: \(MainMenu.immolationVotes))")
    }


    

    func onKeyDown(key:String, code:String, ctrlKey:Bool, shiftKey:Bool, altKey:Bool, metaKey:Bool) {
        if playerID < Global.playerSkins.count {
            if let skin = getSkin(key) { 
                Global.playerSkins[playerID] = skin
            } else if code == "Space" {
                remove(entity: MainMenu.voteTextBox)
                MainMenu.immolationVotes[playerID].toggle()
                MainMenu.updateVotes()
                insert(entity: MainMenu.voteTextBox, at: .front)
            }
        }
    }

    func getSkin(_ str: String) -> String? {
        switch str {
        case "k":
            return "kent"
        case "m":
            return "minion"
        case "b":
            return "black"
        default:
            return nil
        }
    }

    
}
