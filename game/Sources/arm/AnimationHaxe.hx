package arm;

import iron.object.Object;
import iron.system.Input;
import iron.object.Transform;
import iron.object.BoneAnimation;

class AnimationHaxe extends iron.Trait {

	var transform : Transform;
	var animation : BoneAnimation;

	public function new() {
		super();

		notifyOnInit(function() {
			notifyOnUpdate(update);

			transform = object.transform;
			animation = findAnimation(object.getChild("Armature"));
		});

		// notifyOnUpdate(function() {
		// });

		// notifyOnRemove(function() {
		// });
	}

	function update(){
		var keyboard = Input.getKeyboard();

		if(keyboard.started("w")){
			animation.play("runAway");
		}
		else if(keyboard.released("w")){
			animation.play("idle");
		}
	}

	function findAnimation(object:Object):BoneAnimation{
		if(object.animation != null){
			return cast object.animation;
		}

		for(children in object.children) {
			var childrenAnimation = findAnimation(children);
			if(childrenAnimation != null){
				return childrenAnimation;
			}
		}
		return null;
	}
}
