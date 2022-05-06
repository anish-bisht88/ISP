import Scenes
import Igis
import Foundation

class Hand : RenderableEntity {

    let hand : Image
    var imageSize = Size()
    let rotation : Transform
    
    var sourceRect = Rect()
    var destRect = Rect(topLeft: Point(x: 0, y: 0), size: Size(width: 100, height: 100))
    var globalLocation = Point()
    
    var isSelected = false
    var isOut = false

    var originalPos = Point()
    let positionRatio : [Double]

    let initialNumber : Int

    var frame = 0

    init(type: String, positionRatio: [Double], initialNumber : Int = 1, rotation : Double = 0.0) {
        self.rotation = Transform(rotateRadians: rotation, mode: .toIdentity)
        self.initialNumber = initialNumber
        self.positionRatio = positionRatio
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
            imageSize = Global.imageSize
        case "kenttest":
            guard let handURL = URL(string: "https://codermerlin.com/users/anish-bisht/kenthand.png") else {
                fatalError("failed to create URL for kent test hand")
            }
            imageSize = Global.kentImageSize
            hand = Image(sourceURL: handURL)
        default:
            fatalError("Invalid skin color given")
        }
        
        sourceRect.topLeft = Point.zero
        sourceRect.size = Size(width: imageSize.width, height: imageSize.height)
        super.init(name:"Hand")
    }
    
    override func render(canvas: Canvas) {
        if hand.isReady {
            hand.renderMode = .sourceAndDestination(sourceRect: sourceRect, destinationRect: destRect)
            canvas.render(hand)
        }
    }
    
    override func setup(canvasSize: Size, canvas: Canvas) {
        canvas.setup(hand)
        originalPos = Point(x: Int(Double(canvasSize.width)*positionRatio[0]), y: Int(Double(canvasSize.height)*positionRatio[1]))
        changeHand(initialNumber)        
        move(originalPos)
    }

    func changeHand(_ n: Int, debug: Bool = false) {
        sourceRect.topLeft.x = sourceRect.size.width*n
        if debug {
            print("changing hand to \(n), newPos: \(sourceRect.topLeft)")
        }
    }

    func move(_ point: Point) {
        globalLocation = point
        destRect.topLeft = point - Point(x: destRect.size.width/2, y: destRect.size.height/2)
    }

    func reset() {
        isSelected = false
        move(originalPos)
    }

}
