import Scenes
import Igis
import Foundation

class Hand : RenderableEntity {

    var hand : Image
    var imageSize = Size()
    
    var sourceRect = Rect()
    var destRect = Rect(topLeft: Point(x: 0, y: 0), size: Size())
    var globalLocation = Point()
    
    var isSelected = false
    var isOut = false

    var originalPos = Point()
    let positionRatio : [Double]

    let initialNumber : Int

    var frame = 0

    init(type: String, positionRatio: [Double], initialNumber : Int = 1, rotationIndex: Int) {
        precondition(rotationIndex >= 0 && rotationIndex < 4, "invalid rotation index")
        self.initialNumber = initialNumber
        self.positionRatio = positionRatio
        guard let handURL = URL(string: "https://codermerlin.com/users/anish-bisht/test.png") else {
            fatalError("Failed to create URL for test hand")
        }
        hand = Image(sourceURL: handURL)
        imageSize = Global.imageSize
        
        sourceRect.topLeft = Point(x: 0, y: rotationIndex*imageSize.height)
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
        destRect.size = Size(width: canvasSize.width/6, height: canvasSize.width/6)
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

    func changeSkin(_ str: String) {
        let hand : Image
        switch str {
        case "minion":
            guard let handURL = URL(string: Global.minionURL) else {
                fatalError("Failed to create URL for minion hands")
            }
            hand = Image(sourceURL: handURL)
        case "test":
            guard let handURL = URL(string: "https://codermerlin.com/users/anish-bisht/test.png") else {
                fatalError("Failed to create URL for test hand")
            }
            hand = Image(sourceURL: handURL)
            imageSize = Global.imageSize
        case "kent":
            guard let handURL = URL(string: Global.kentURL) else {
                fatalError("failed to create URL for kent test hand")
            }
            imageSize = Global.imageSize
            hand = Image(sourceURL: handURL)
        case "black":
            guard let handURL = URL(string: Global.blackURL) else {
                fatalError("failed to get url for black hand")
            }
            hand = Image(sourceURL: handURL)
        default:
            fatalError("Invalid skin color given")
        }
        self.hand = hand
    }

}
