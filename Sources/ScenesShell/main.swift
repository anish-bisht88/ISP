import Igis

/*
 This main code is responsible for starting Igis and initializing
 the Director.
 It rarely needs to be altered.
 */

enum Global {
    static let imageSize = Size(width: 256, height: 256)
    static let kentImageSize = Size(width: 600, height: 800)
        
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

print("Starting...")
do {
    let igis = Igis()
    try igis.run(painterType:ShellDirector.self)
} catch (let error) {
    print("Error: \(error)")
}

