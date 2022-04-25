import Igis

/*
 This main code is responsible for starting Igis and initializing
 the Director.
 It rarely needs to be altered.
 */

struct GlobalVars {
    static let imageSize = Size(width: 256, height: 256)
}

print("Starting...")
do {
    let igis = Igis()
    try igis.run(painterType:ShellDirector.self)
} catch (let error) {
    print("Error: \(error)")
}

