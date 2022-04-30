import Scenes
import Igis
import Foundation

class Hand : RenderableEntity {

    let hand : Image
    let imageSize = Size(width: 0, height: 0)
    
    var sourceRect = Rect()
    var destRect = Rect(topLeft: Point(x: 0, y: 0), size: Size(width: 100, height: 100))
    
    var isSelected = false
    var isUpdated = false

    var originalPos = Point()
    let positionRatio : [Double]

    init(type: String, positionRatio: [Double]) {
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
        default:
            fatalError("Invalid skin color given")
        }
        let imageSize = Global.imageSize
        sourceRect.size = Size(width: imageSize.width, height: imageSize.height)
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
        originalPos = Point(x: Int(Double(canvasSize.width)*positionRatio[0]), y: Int(Double(canvasSize.height)*positionRatio[1]))
        changeHand(1)        
        move(originalPos)
    }

    func changeHand(_ n: Int) {
        sourceRect.topLeft.x = imageSize.width * n
        isUpdated = false
    }

    func move(_ point: Point) {
        destRect.topLeft = point - Point(x: destRect.size.width/2, y: destRect.size.height/2)
    }

    func reset() {
        isSelected = false
        move(originalPos)
    }

}
