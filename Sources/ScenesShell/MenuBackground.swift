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

    let music: Audio
    var isBackgroundPlaying = false


    init() {
        guard let musicURL = URL(string: "https://codermerlin.com/users/anish-bisht/menu.mp3") else {
            fatalError("could not get menu music url")
        }
        music = Audio(sourceURL: musicURL, shouldLoop: true)
        
        // Using a meaningful name can be helpful for debugging
        super.init(name:"Background")
    }

    override func setup(canvasSize: Size, canvas: Canvas) {
        clearRect = Rect(topLeft: Point.zero, size: canvasSize)
        clearRectangle = Rectangle(rect: clearRect, fillMode: .fill)
        canvas.setup(music)
    }

    override func render(canvas: Canvas) {
        if  music.isReady {
            canvas.render(music)
            isBackgroundPlaying = true
        }
        canvas.render(whiteFill, clearRectangle)
    }
    
}
