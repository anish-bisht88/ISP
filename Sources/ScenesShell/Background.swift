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

    var clearRect = Rect()
    var clearRectangle : Rectangle
    let whiteFill = FillStyle(color: Color(.white))


    init() {
        guard let minionImageURL = URL(string:"https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Minion.png/640px-Minion.png") else {
            fatalError("Could not get minionImage")
        }
        minionImage = Image(sourceURL: minionImageURL)

        clearRectangle = Rectangle(rect: clearRect, fillMode: .fill)
        
        // Using a meaningful name can be helpful for debugging
        super.init(name:"Background")


    }

    override func setup(canvasSize: Size, canvas: Canvas) {
        dispatcher.registerKeyDownHandler(handler: self)
        clearRect = Rect(topLeft: Point(x: 0, y: 0), size: canvasSize)
        clearRectangle = Rectangle(rect: clearRect, fillMode: .fill)
        canvas.setup(minionImage)

    }

    override func teardown() {
        dispatcher.unregisterKeyDownHandler(handler: self)
    }

    override func render(canvas: Canvas) {
        if minionImage.isReady && minionState == minionKeys.count {
             minionImage.renderMode = .destinationPoint(Point(x:100, y:200))
             canvas.render(minionImage)
             minionDrawn = true
        }
        canvas.render(whiteFill, clearRectangle)
    }

    func onKeyDown(key:String, code:String, ctrlKey:Bool, shiftKey:Bool, altKey:Bool, metaKey:Bool) {
        if !minionDrawn {
            if key == minionKeys[minionState] {
                minionState += 1
                print("state: \(minionState), next letter: \(minionKeys[minionState]), total: \(minionKeys.count)")
            } else {
                minionState = 0
            }
        }
        
    }
}
