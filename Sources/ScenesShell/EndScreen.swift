import Scenes
import Igis
import Foundation

class EndScreen : RenderableEntity {
    let text = Text(location: Point.zero, text: "",fillMode:.fillAndStroke)
    let fillStyle = FillStyle(color: Color(.yellow))
    let strokeStyle = StrokeStyle(color: Color(.black))
    let lineWidth = LineWidth(width:5)

    let leftPlayerWin : Image
    let rightPlayerWin : Image
    var destRect = Rect()

    let playerID : Int

    init(_ n : Int) {
        guard let leftPlayerURL = URL(string: Global.leftPlayerWin) else {
            fatalError(" could not get right facing I'm with stupid image")
        }
        guard let rightPlayerURL = URL(string: Global.rightPlayerWin) else {
            fatalError(" could not get left facing I'm with stupid image")
        }
        leftPlayerWin = Image(sourceURL: leftPlayerURL)
        rightPlayerWin = Image(sourceURL: rightPlayerURL)
        
        self.playerID = n
    }
    
    override func setup(canvasSize: Size, canvas: Canvas) {
        if let winner = Global.winner {
            if playerID <= 2 {
                text.text = "You \(winner == playerID ? "Won" : "Lost")!"
            }
            if playerID >= 2 {
                print(winner)
                text.text = "\(winner == 1 ? "Right" : "Left") Player Won!"
            }
            switch winner {
            case 0:
                canvas.setup(leftPlayerWin)
            case 1:
                canvas.setup(rightPlayerWin)
            default:
                fatalError("unknown winner")
            }
                
        }

        text.location = Point(x: canvasSize.center.x, y: canvasSize.height/4)
        text.font = "128pt Helvetica Bold"
        text.alignment = .center

        destRect.topLeft = Point(x: 3*canvasSize.width/8, y: 3*canvasSize.height/8)
        destRect.size = Size(width: canvasSize.width/6, height: Int(1.7*Double(canvasSize.width/6)))

    }

    override func render(canvas: Canvas) {
        canvas.render(strokeStyle, fillStyle, lineWidth, text)
        if leftPlayerWin.isReady {
            leftPlayerWin.renderMode = .destinationRect(destRect)
            canvas.render(leftPlayerWin)
        } else if rightPlayerWin.isReady {
            rightPlayerWin.renderMode = .destinationRect(destRect)
            canvas.render(rightPlayerWin)
        }
    }

}
