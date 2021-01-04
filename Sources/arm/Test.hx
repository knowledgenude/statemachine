package arm;

import arm.fsm.FSM;
import iron.system.Input;

class Test extends iron.Trait {

	var fsm: FSM;
	var keyboard: Keyboard = Input.getKeyboard();

	public function new() {
		super();

		notifyOnInit(function() {
			fsm = new FSM();

			var idle = new Idle();
			var walk = new Walk();
			var run = new Run();

			fsm.setState(idle);

			fsm.addTransition(toWalk, idle, walk);
			fsm.addTransition(toRun, walk, run);
		});

		notifyOnUpdate(function() {
			fsm.execute();
		});
	}

	function toWalk() {
		if (keyboard.started("1")) return true;
		return false;
	}

	function toRun() {
		if (keyboard.started("2")) return true;
		return false;
	}
}