import Scenes
import Igis

class EndScreen : RenderableEntity {
    let text = Text(location: Point.zero, text: "")
    let fillStyle = FillStyle(color: Color(.white))
    let strokeStyle = StrokeStyle(color: Color(.black))

    let playerID : Int

    init(_ n : Int) {
        self.playerID = n
    }
    
    override func setup(canvasSize: Size, canvas: Canvas) {
        if let winner = Global.winner {
            text.text = "You \(winner == playerID ? "Won" : "Lost")!"
        }
        text.location = canvasSize.center
        text.font = "128pt Helvetica Bold"
        text.alignment = .center
    }

    override func render(canvas: Canvas) {
        canvas.render(strokeStyle, fillStyle, text)
    }

}
