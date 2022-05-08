import Igis

/*
 This main code is responsible for starting Igis and initializing
 the Director.
 It rarely needs to be altered.
 */

enum Global {
    static let imageSize = Size(width: 336, height: 252)
    static let sheetSize = Size(width: 1680, height: 1008)
    static let kentImageSize = Size(width: 600, height: 800)

    static let kentURL = "https://codermerlin.com/users/anish-bisht/kentfull.png"

    static var playerSkins = [String?]()
    static var winner : Int? = nil

    static var immolationMode = false
        
    enum PlayerHand : Int {
        case leftHand
        case rightHand
    }
    enum PlayerType : Int {
        case playerOne
        case playerTwo
        case spectator
    }
}

struct Gameplay {
    var x : Int
}

print("Starting...")
do {
    let igis = Igis()
    try igis.run(painterType:ShellDirector.self)
} catch (let error) {
    print("Error: \(error)")
}

