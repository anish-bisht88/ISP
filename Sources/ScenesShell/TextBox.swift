import Igis
import Scenes
import Foundation

class TextBox : RenderableEntity {
    var text = Text(location: Point.zero, text: "", fillMode: .fillAndStroke)
    let fillStyle = FillStyle(color: Color(.white))
    let strokeStyle = StrokeStyle(color: Color(.black))
    let locationRatios : [Double]
    
    init(_ text: String, locationRatios: [Double] = [0.5,0.5] ) {
        precondition(locationRatios.count == 2, "location ratio must have 2 numbers)")
        self.locationRatios = locationRatios
        self.text.text  = text
        self.text.alignment = .center
        self.text.font = "32pt Arial"
    }

    override func setup(canvasSize: Size, canvas: Canvas) {
        self.text.location = Point(x: Int(Double(canvasSize.width)*locationRatios[0]), y: Int(Double(canvasSize.height)*locationRatios[1]))
    }

    override func render(canvas: Canvas){
        canvas.render(self.fillStyle, self.strokeStyle, self.text)
    }

    public func changeText(_ text: String) {
        self.text.text = text
    }
    
}
