import Foundation
import Scenes
import Igis


class MenuButtons : RenderableEntity,EntityMouseClickHandler {
    var play = Rectangle(rect: Rect())
    var settings = Rectangle(rect:Rect())
    var howToPlay = Rectangle(rect:Rect())
    var microtransaction = Rectangle(rect:Rect())
    var menuRect = Rect()
    var kent : Text
    var minion : Text
    let playerID: Int 
    
    init(_ playerID : Int) {
        print("Awesome")
        self.playerID = playerID
        kent = Text(location:Point(x:0,y:0), text:"Kent")
        minion = Text(location:Point(x:0,y:0), text:"Kent")
        super.init(name:"Menu")
    }

    func renderRect(rect: Rect, num: Int) -> Rectangle{
        let rect2 = Rect(topLeft:Point(x:rect.topLeft.x,y:rect.topLeft.y+(159*num)), size:Size(width:300,height:50))
        let rectangle2 = Rectangle(rect:rect2, fillMode: .fillAndStroke)
        return rectangle2
    }

    func Click(rectangle: Rectangle, globalLocation: Point, string: String) {
        if rectangle.rect.topLeft.x < globalLocation.x && globalLocation.x < rectangle.rect.topLeft.x+rectangle.rect.size.width && rectangle.rect.topLeft.y < globalLocation.y && globalLocation.y < rectangle.rect.topLeft.y+rectangle.rect.size.height {
            Global.playerSkins[playerID] = string
        }        
    }
    
    override func setup(canvasSize:Size, canvas:Canvas) {
        menuRect = Rect(topLeft:Point(x:(canvasSize.width/4)+10,y:(Int(Double(canvasSize.height)/4.75))), size:Size(width:200,height:50))
        play = Rectangle(rect:menuRect, fillMode:.fillAndStroke)
        dispatcher.registerEntityMouseClickHandler(handler:self)        
    }

    override func render(canvas: Canvas) {
        let lineWidth = LineWidth(width:5)
        let strokeStyle = StrokeStyle(color:Color(.black))
        let fillStyle = FillStyle(color:Color(.lightgray))
        let Black = FillStyle(color:Color(.black))
        kent.alignment = .center
        kent  = Text(location:Point(x:menuRect.topLeft.x+Int(Double(menuRect.size.width)*(3/4)),y:menuRect.topLeft.y+(Int(Double(menuRect.size.height)*(3/4)))), text:"Kent")
        kent.font = "30pt Comic Sans"
        minion.alignment = .center
        minion  = Text(location:Point(x:(menuRect.topLeft.x)+Int(Double(menuRect.size.width)*(3/4)),y:menuRect.topLeft.y+159+(Int(Double(menuRect.size.height)*(3/4)))), text:"Minion")
        minion.font = "30pt Comic Sans"        
        
        play = renderRect(rect:menuRect, num:0)
        settings = renderRect(rect:menuRect, num:1)
        howToPlay = renderRect(rect:menuRect, num:2)
        microtransaction = renderRect(rect:menuRect, num:3)

        canvas.render(strokeStyle,fillStyle,lineWidth,play,settings)
        canvas.render(Black, kent, minion)
    }

    override func teardown() {
        dispatcher.unregisterEntityMouseClickHandler(handler:self)
    }


    func onEntityMouseClick(globalLocation: Point) {
        Click(rectangle:play,globalLocation: globalLocation, string: "kent")
        Click(rectangle:settings, globalLocation: globalLocation, string: "test")
    }

    override func boundingRect() -> Rect {
        return Rect(size:Size(width:Int.max, height:Int.max))
    }
}
