Skip to content
 Enterprise
Search or jump to…

Pull requests
Issues
Explore
 
@ahcengiz 
1
10ajharris/438Demos
 Code Issues 0 Pull requests 0 Projects 0 Wiki Insights
438Demos/carHaxe/Sources/arm/CarTrait.hx
@ajharris ajharris add haxe versions of armory examples
3294b26 on Feb 13
49 lines (39 sloc)  1003 Bytes
  
package arm;

import iron.math.Quat;

class CarTrait extends iron.Trait {
	public function new() {
		super();

		// notifyOnInit(function() {
		// });

		notifyOnUpdate(function() {
			var keyboard  = iron.system.Input.getKeyboard();
			var q = new Quat();
			var look;

			if (keyboard.down("w")){
				trace("fwd");
			  	//object.transform.loc.y += .1;
				look = object.transform.world.look().mult(.1);
				object.transform.loc.add(look);
			} // end if

			if (keyboard.down("s")){
				trace("back");
				//object.transform.loc.y -= .1;
				look = object.transform.world.look().mult(-.1);
				object.transform.loc.add(look);
			}

			if (keyboard.down("a")){
				trace("left");
				q.fromEuler(0, 0, .05);
				object.transform.rot.mult(q);
			}

			if (keyboard.down("d")){
				trace("right");
				q.fromEuler(0, 0, -.05);
				object.transform.rot.mult(q);
			}
			object.transform.buildMatrix();

		});

		// notifyOnRemove(function() {
		// });
	}
}
