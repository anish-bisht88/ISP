import Igis
import Scenes
import Foundation

class TextBox : RenderableEntity {
    var text = Text(location: Point.zero, text: "")
    let fillStyle = FillStyle(color: Color(.black))
    
    init(_ text: String) {
        self.text.text  = text
        self.text.alignment = .center
        self.text.font = "32pt Arial"
    }

    override func setup(canvasSize: Size, canvas: Canvas) {
        self.text.location = canvasSize.center
    }

    override func render(canvas: Canvas)
    {
        canvas.render(self.fillStyle, self.text)
    }
    
}
