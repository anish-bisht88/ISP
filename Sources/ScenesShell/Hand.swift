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

    let initialNumber : Int

    var frame = 0

    init(type: String, positionRatio: [Double], initialNumber : Int = 1) {
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
        default:
            fatalError("Invalid skin color given")
        }
        let imageSize = Global.imageSize
        sourceRect.topLeft = Point.zero
        sourceRect.size = Size(width: imageSize.width, height: imageSize.height)
        super.init(name:"Hand")
        print("creating new hand with positionRatio \(positionRatio)")
    }

    override func calculate(canvasSize: Size) {
        print("\(sourceRect.topLeft)")p
        self.changeHand(Int.random(in: 0..<5))
    }
    
    override func render(canvas: Canvas) {
        if hand.isReady { //&& !isUpdated {
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

    func changeHand(_ n: Int) {
        print("changing hand to \(n), new x: \(sourceRect.size.width*n/5)")
        sourceRect.topLeft.x = sourceRect.size.width*n/5
        isUpdated = false
    }

    func move(_ point: Point) {
        destRect.topLeft = point - Point(x: destRect.size.width/2, y: destRect.size.height/2)
        isUpdated = false
    }

    func reset() {
        isSelected = false
        move(originalPos)
    }

}
