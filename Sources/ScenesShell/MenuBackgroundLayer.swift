import Scenes

  /*
     This class is responsible for the background Layer.
     Internally, it maintains the RenderableEntities for this layer.
   */


class MenuBackgroundLayer : Layer {
      let background = MenuBackground()

      init() {
          // Using a meaningful name can be helpful for debugging
          super.init(name:"Menu Background")

          // We insert our RenderableEntities in the constructor
          insert(entity:background, at:.back)
      }
  }
