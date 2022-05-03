import Scenes
import Igis
import Foundation

/*
 This class is responsible for rendering the background.
 */


class Background : RenderableEntity, KeyDownHandler {

    var minionState = 0
    var minionKeys = ["m", "i", "n", "i", "o", "n", "1", "7", "3", "8"]
    let minionImage : Image
    let bananaAudio : Audio
    var minionDrawn = false

    var clearRect = Rect()
    var clearRectangle : Rectangle
    let whiteFill = FillStyle(color: Color(.white))


    init() {
        guard let minionImageURL = URL(string:"https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Minion.png/640px-Minion.png") else {
            fatalError("Could not get minionImage")
        }
        minionImage = Image(sourceURL: minionImageURL)

        guard let bananaAudioURL = URL(string:"https://www.codermerlin.com/users/anish-bisht/minions2.mp3") else{
            fatalError("Could not get bananaImage")
        }
        bananaAudio = Audio(sourceURL: bananaAudioURL, shouldLoop: true) 




        
        clearRectangle = Rectangle(rect: clearRect, fillMode: .fill)
        
        // Using a meaningful name can be helpful for debugging
        super.init(name:"Background")


    }

    override func setup(canvasSize: Size, canvas: Canvas) {
        dispatcher.registerKeyDownHandler(handler: self)
        clearRect = Rect(topLeft: Point(x: 0, y: 0), size: canvasSize)
        clearRectangle = Rectangle(rect: clearRect, fillMode: .fill)
        canvas.setup(minionImage)
        canvas.setup(bananaAudio)
    }

    override func teardown() {
        dispatcher.unregisterKeyDownHandler(handler: self)
    }

    override func render(canvas: Canvas) {
        canvas.render(whiteFill, clearRectangle)
        var isBackgroundPlaying = false
       

        if minionImage.isReady && minionState == minionKeys.count && !isBackgroundPlaying && bananaAudio.isReady{
             minionImage.renderMode = .destinationPoint(Point(x:100, y:200))
             canvas.render(minionImage)
             minionDrawn = true
             canvas.render(bananaAudio)
             isBackgroundPlaying = true
        }
        
    }

    func onKeyDown(key:String, code:String, ctrlKey:Bool, shiftKey:Bool, altKey:Bool, metaKey:Bool) {
        if !minionDrawn {
            if (minionState-1 <= minionKeys.count)&&(key == minionKeys[minionState]) {
                minionState += 1
            } else {
                minionState = 0
            }
        }
        print(minionState, minionDrawn)
        
    }
}
