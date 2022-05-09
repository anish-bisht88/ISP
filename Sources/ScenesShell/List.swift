import Igis
import Scenes
import Foundation

class List : RenderableEntity, EntityMouseClickHandler {
    let labels : [String]
    var images = [Image]()
    var sourceRects = [Rect]()
    
    var destRects = [Rect]()
    var texts = [Text]()
    var textBackgrounds = [Rectangle]()
    var textBackgroundStrokes = [Rectangle]()
    let fillStyle = FillStyle(color: Color(.white))
    let strokeStyle = StrokeStyle(color: Color(.black))
    let bgFillStyle = FillStyle(color: Color(.green))
    let lineWidth = LineWidth(width: 3)
    let textWidth = LineWidth(width: 1)
    
    var playerID : Int
    var titleText = Text(location: Point.zero, text: "")
    var subtitleText = Text(location: Point.zero, text: "")
    
    init(labels: [String], images: [String], sizes: [Size], title: String, subtitle: String = "", playerID: Int) {
        titleText.text = title
        titleText.alignment = .center
        titleText.font = "64pt Arial Bold"
        subtitleText.text = subtitle
        titleText.alignment = .center
        titleText.font = "32pt Arial Bold"
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
        dispatcher.registerEntityMouseClickHandler(handler:self)        
        let spacing = images.count + 2
        titleText.location = Point(x: canvasSize.center.x, y: canvasSize.height/12)
        subtitleText.location = Point(x: canvasSize.center.x, y: canvasSize.height/12+48)
        for index in 0..<images.count {
            canvas.setup(images[index])
            destRects.append(Rect(topLeft: Point(x: canvasSize.center.x, y: (index+1)*canvasSize.height/spacing), size: Size(width: canvasSize.width/3, height: canvasSize.height/spacing)))
            texts.append(Text(location: Point(x: canvasSize.width/3, y: (index+1)*canvasSize.height/spacing+destRects[0].size.height/2), text: labels[index], fillMode: .fillAndStroke))
            textBackgrounds.append(Rectangle(rect: Rect(topLeft: texts[index].location-Point(x: 100, y: 40), size: Size(width: 200, height: 50)), fillMode: .fillAndStroke))
            texts[index].alignment = .center
            texts[index].font = "32pt Arial"
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
            canvas.render(lineWidth, fillStyle, strokeStyle, textWidth, images[index], textBackgrounds[index], texts[index], titleText, subtitleText)
        }
    }

    func onEntityMouseClick(globalLocation: Point) {
        buttonCheck: for index in 0..<textBackgrounds.count {
            let containment = textBackgrounds[index].rect.containment(target: globalLocation)
            if containment.contains(.containedFully) {
                print(labels[index], "hand selected")
                Global.playerSkins[playerID] = labels[index]
                break buttonCheck
            }
        }
    }

    override func teardown() {
        dispatcher.unregisterEntityMouseClickHandler(handler:self)        
    }

    override func boundingRect() -> Rect {
        return Rect(size: Size(width: Int.max, height: Int.max))
    }
    
}
