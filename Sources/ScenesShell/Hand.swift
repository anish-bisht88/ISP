import Scenes
import Igis
import Foundation

class Hand : RenderableEntity {

    let hand : Image
    let imageSize = Size(width: 0, height: 0)
    
    var sourceRect = Rect()
    var destRect = Rect(size: Size(width: 0, height: 0))
    
    var isSelected = false
    var isReady = false

    
    init(color: String, imageSize: Size) {
        switch color {
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
        default:
            fatalError("Invalid skin color given")
        }
        
        sourceRect.topLeft = Point(x: 0, y: 0)
        
        super.init(name:"Hand")
    }

    override func setup(canvasSize: Size, canvas: Canvas) {
        canvas.setup(hand)
        changeHand(1)
    }

    func move(_ point: Point) {
        if isSelected {
            destRect.topLeft = point
        }
        render()
    }

    func add(_ n: Int) {
        sourceRect.topLeft.x = imageSize.width * n
        render()
    }

    func render() {
        if hand.isReady {
            hand.renderMode = .sourceAndDestination(sourceRect: sourceRect, destinationRect: destRect)
            canvas.render(hand)
        }
    }
    

}
