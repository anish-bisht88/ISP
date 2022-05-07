import Scenes
import Igis
import Foundation

/*
 This class is responsible for rendering the background.
 */


class MenuBackground : RenderableEntity {
    var clearRect = Rect()
    var clearRectangle = Rectangle(rect: Rect())
    let whiteFill = FillStyle(color: Color(.white))


    init() {
        // Using a meaningful name can be helpful for debugging
        super.init(name:"Background")
    }

    override func setup(canvasSize: Size, canvas: Canvas) {
        clearRect = Rect(topLeft: Point.zero, size: canvasSize)
        clearRectangle = Rectangle(rect: clearRect, fillMode: .fill)
    }

    override func render(canvas: Canvas) {
        canvas.render(whiteFill, clearRectangle)
    }

    
}
