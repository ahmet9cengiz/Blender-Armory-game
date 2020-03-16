package arm;

import iron.math.Quat;

class Character extends iron.Trait {
	public function new() {
		super();

		// notifyOnInit(function() {
		// });

		notifyOnUpdate(function() {
			var keyboard  = iron.system.Input.getKeyboard();
			var quat = new Quat();
			var directionOfMovement;

			if (keyboard.down("w")){
				directionOfMovement = object.transform.world.look().mult(1);
				object.transform.loc.add(directionOfMovement);
			} // end if

			if (keyboard.down("s")){
				directionOfMovement = object.transform.world.look().mult(-1);
				object.transform.loc.add(directionOfMovement);
			}

			if (keyboard.down("a")){
				quat.fromEuler(0, .05, 0);
				object.transform.rot.mult(quat);
			}

			if (keyboard.down("d")){
				quat.fromEuler(0, -.05, 0);
				object.transform.rot.mult(quat);
			}
			object.transform.buildMatrix();

		});

		// notifyOnRemove(function() {
		// });
	}
}