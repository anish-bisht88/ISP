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
    var minionDrawn = false
    
    let bananaAudio : Audio
    let onSightAudio : Audio
    var isBackgroundPlaying = false

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

        guard let onSightAudioURL = URL(string:"https://codermerlin.com/users/anish-bisht/onsight.mp3") else{
            fatalError("Could not get bananaImage")
        }
        onSightAudio = Audio(sourceURL: onSightAudioURL, shouldLoop: true)  

        
        clearRectangle = Rectangle(rect: clearRect, fillMode: .fill)
        
        // Using a meaningful name can be helpful for debugging
        super.init(name:"Background")


    }

    override func setup(canvasSize: Size, canvas: Canvas) {
        dispatcher.registerKeyDownHandler(handler: self)
        clearRect = Rect(topLeft: Point.zero, size: canvasSize)
        clearRectangle = Rectangle(rect: clearRect, fillMode: .fill)
        canvas.setup(minionImage)
        canvas.setup(bananaAudio)
        canvas.setup(onSightAudio)
    }

    override func teardown() {
        dispatcher.unregisterKeyDownHandler(handler: self)
    }

    override func render(canvas: Canvas) {
        canvas.render(whiteFill, clearRectangle)
        if !isBackgroundPlaying && onSightAudio.isReady{
             canvas.render(onSightAudio)
             isBackgroundPlaying = true
        }
       

        if minionImage.isReady && bananaAudio.isReady && minionState == minionKeys.count {
             minionImage.renderMode = .destinationPoint(Point(x:100, y:200))
             canvas.render(minionImage, bananaAudio)
             minionDrawn = true
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
    }
}
