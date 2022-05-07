import Igis
import Scenes
import Foundation

class List : RenderableEntity {
    let labels : [String]
    var images = [Image]()
    var sourceRects = [Rect]()
    
    var destRects = [Rect]()
    var texts = [Text]()
    let fillStyle = FillStyle(color: Color(.black))
    
    var playerID : Int
    
    
    init(labels: [String], images: [String], sizes: [Size], playerID: Int) {
        precondition(labels.count == images.count && images.count == sizes.count, "there should be the same amount of labels (\(labels.count)), images (\(images.count)), and sizes (\(sizes.count))")
        self.playerID = playerID
        self.labels = labels
        for index in 0..<images.count {
            guard let imageURL = URL(string: images[index]) else {
                fatalError("failed to create url for \(labels[index])")
            }
            self.images.append(Image(sourceURL: imageURL))
            self.sourceRects.append(Rect(topLeft: Point.zero, size: Size(width: sizes[index].width, height: sizes[index].height/4)))
        }
    }

    override func setup(canvasSize: Size, canvas: Canvas) {
        let spacing = images.count + 2
        for index in 0..<images.count {
            canvas.setup(images[index])
   destRects.append(Rect(topLeft: Point(x: canvasSize.center.x, y: (index+1)*canvasSize.height/spacing), size: Size(width: canvasSize.width/3, height: canvasSize.height/spacing)))
            texts.append(Text(location: Point(x: canvasSize.width/4, y: (index+1)*canvasSize.height/spacing), text: labels[index]))
            texts[index].alignment = .center
            texts[index].font = "12pt Arial"
        }
    }

    override func render(canvas: Canvas)
    {
        for index in 0..<images.count {
            if !images[index].isReady {
                return
            }
        }
        for index in 0..<images.count {
            images[index].renderMode = .sourceAndDestination(sourceRect: sourceRects[index], destinationRect: destRects[index])

            canvas.render(fillStyle, images[index], texts[index])
        }
    }
    
}
