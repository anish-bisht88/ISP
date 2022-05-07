import Scenes
import Igis

/*
   This class is responsible for implementing a single Scene.
   Scenes projects require at least one Scene but may have many.
   A Scene is comprised of one or more Layers.
   Layers are generally added in the constructor.
 */
class MainScene : Scene, KeyDownHandler {

    /* Scenes typically include one or more Layers.
       A common approach is to use three Layers:
       One for the background, one for interaction,
       and one for the foreground.
     */
    let backgroundLayer = BackgroundLayer()
    let interactionLayer = InteractionLayer()
    let foregroundLayer = ForegroundLayer()

    init() {
        // Using a meaningful name can be helpful for debugging
        super.init(name:"Main")

        // We insert our Layers in the constructor
        // We place each layer in front of the previous layer
        insert(layer:backgroundLayer, at:.back)
        insert(layer:interactionLayer, at:.inFrontOf(object:backgroundLayer))
        insert(layer:foregroundLayer, at:.front)
    }

    override func preSetup(canvasSize: Size, canvas: Canvas) {
        dispatcher.registerKeyDownHandler(handler: self)
    }

    override func postTeardown() {
        dispatcher.unregisterKeyDownHandler(handler: self)
    }
    
    func onKeyDown(key:String, code:String, ctrlKey:Bool, shiftKey:Bool, altKey:Bool, metaKey:Bool) {
        backgroundLayer.background.onKeyDown(key: key, code: code, ctrlKey: ctrlKey, shiftKey: shiftKey, altKey: altKey, metaKey: metaKey)
        interactionLayer.handHandler.onKeyDown(key: key, code: code, ctrlKey: ctrlKey, shiftKey: shiftKey, altKey: altKey, metaKey: metaKey)
    }
}
