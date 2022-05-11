import Scenes
import Igis

class EndScreen : RenderableEntity {
    let text = Text(location: Point.zero, text: "",fillMode:.fillAndStroke)
    let fillStyle = FillStyle(color: Color(.yellow))
    let strokeStyle = StrokeStyle(color: Color(.black))
    let lineWidth = LineWidth(width:5)

    let playerID : Int

    init(_ n : Int) {
        self.playerID = n
    }
    
    override func setup(canvasSize: Size, canvas: Canvas) {
        if let winner = Global.winner {
            if playerID < 2 {
                text.text = "You \(winner == playerID ? "Won" : "Lost")!"
            }
            if playerID >= 2 {
                print(winner)
                text.text = "\(winner == 1 ? "Right" : "Left") Player Won!"
            }
        }

        text.location = canvasSize.center
        text.font = "128pt Helvetica Bold"
        text.alignment = .center
    }

    override func render(canvas: Canvas) {
        canvas.render(strokeStyle, fillStyle, lineWidth, text)
    }

}
