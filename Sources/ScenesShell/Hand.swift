import Scenes
import Igis
import Foundation

class Hand : RenderableEntity {

    let hand : Image
    let imageSize = Size(width: 0, height: 0)
    var fingers = 1
    let isRight : Bool
    
    var sourceRect = Rect()
    var destRect = Rect(topLeft: Point(x: 0, y: 0), size: Size(width: 100, height: 100))
    
    var isSelected = false
    var isUpdated = false
    var isEnabled = false
    let upsideDown : Bool

    var originalPos = Point()

    init(type: String, isRight: Bool, upsideDown : Bool = false) {
        self.upsideDown = upsideDown
        self.isRight = isRight
        let imageSize = GlobalVars.imageSize
        switch type {
        case "minion":
            guard let handURL = URL(string: "") else {
                fatalError("Failed to create URL for minion hand")
            }
            hand = Image(sourceURL: handURL)
        case "white":
            guard let handURL = URL(string: "") else {
                fatalError("Failed to create URL for white hand")
            }
            hand = Image(sourceURL: handURL)
        case "brown":
            guard let handURL = URL(string: "") else {
                fatalError("Failed to create URL for brown hand")
            }
            hand = Image(sourceURL: handURL)
        case "black":
            guard let handURL = URL(string: "") else {
                fatalError("Failed to create URL for black hand")
            }
            hand = Image(sourceURL: handURL)
        case "test":
            guard let handURL = URL(string: "https://codermerlin.com/users/anish-bisht/test.png") else {
                fatalError("Failed to create URL for test hand")
            }
            hand = Image(sourceURL: handURL)
        default:
            fatalError("Invalid skin color given")
        }
        sourceRect = Rect(topLeft: Point(x: 0, y: 0), size: Size(width: imageSize.width, height: imageSize.height))
        super.init(name:"Hand")
    }

    override func render(canvas: Canvas) {
        if !isUpdated && hand.isReady {
            hand.renderMode = .sourceAndDestination(sourceRect: sourceRect, destinationRect: destRect)
            canvas.render(hand)
        }
    }
    
    override func setup(canvasSize: Size, canvas: Canvas) {
        canvas.setup(hand)
        changeHand(1)
        if !upsideDown {
            originalPos = Point(x: (canvasSize.width/3)*(isRight ? 2 : 1), y: 3*canvasSize.height/4)
        } else {
            originalPos = Point(x: (canvasSize.width/3)*(isRight ? 2 : 1), y: canvasSize.height/4)
        }
        
        move(originalPos)
    }

    func changeHand(_ n: Int) {
        sourceRect.topLeft.x = imageSize.width * n
        fingers = n
    }

    func move(_ point: Point) {
        destRect.topLeft = point - Point(x: destRect.size.width/2, y: destRect.size.height/2)
    }

    func reset() {
        isSelected = false
        move(originalPos)
    }

}
