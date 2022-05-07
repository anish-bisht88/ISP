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

    static var arrayInitialized = false

    init() {
        if !MainMenu.arrayInitialized {
            Global.playerSkins = [nil, nil]
            MainMenu.arrayInitialized = true
        }
        self.playerID = MainMenu.players
        MainMenu.players += 1

        list = List(labels: Array(repeating: "four", count: 4), images: Array(repeating: "https://i.ibb.co/VJZ5Bpn/four.png", count: 4), sizes: Array(repeating: Size(width: 1280, height: 1024), count: 4), playerID: playerID)
        
          // Using a meaningful name can be helpful for debugging
          super.init(name:"MainMenu")

          // We insert our RenderableEntities in the constructor
          if playerID < 2 {
              insert(entity: list, at: .front)
          } else {
              insert(entity: waitTextBox, at: .front)
          }
    }

    override func postCalculate(canvas: Canvas) {
        if playerID < 2 {
            if Global.playerSkins[playerID] != nil {
                remove(entity: list)
                insert(entity: waitTextBox, at: .front)
            }
        } 
    }


      

      func onKeyDown(key:String, code:String, ctrlKey:Bool, shiftKey:Bool, altKey:Bool, metaKey:Bool) {
          if let skin = getSkin(key), playerID < Global.playerSkins.count {
              Global.playerSkins[playerID] = skin
          }
      }

      func getSkin(_ str: String) -> String? {
          switch str {
          case "k":
              return "kent"
          case "t":
              return "test"
          default:
              return nil
          }
      }

     
  }
