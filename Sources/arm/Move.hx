package arm;

import iron.math.Quat;

class Move extends iron.Trait {
	public function new() {
		super();

		// notifyOnInit(function() {
		// });

		notifyOnUpdate(function() {
			var keyboard  = iron.system.Input.getKeyboard();
			var quat = new Quat();
			var directionOfMove;

			if (keyboard.down("w")){
				trace("move");
				directionOfMove = object.transform.world.look().mult(-.5);
				object.transform.loc.add(directionOfMove);
			}

			if (keyboard.down("s")){
				directionOfMove = object.transform.world.look().mult(.5);
				object.transform.loc.add(directionOfMove);
			}

			if (keyboard.down("a")){
				quat.fromEuler(0, 0, .03);
				object.transform.rot.mult(quat);
			}

			if (keyboard.down("d")){
				quat.fromEuler(0, 0, -.03);
				object.transform.rot.mult(quat);
			}


			object.transform.buildMatrix();
		
		});

		// notifyOnRemove(function() {
		// });
	}
}
