package arm;

import arm.fsm.FSM;
import arm.states.States;
import iron.system.Input;

class Test extends iron.Trait {

	var fsm: FSM;
	var keyboard: Keyboard = Input.getKeyboard();

	public function new() {
		super();

		notifyOnInit(function() {
			fsm = new FSM();

			var idle = new Idle(this);
			var walk = new Walk(this);
			var run = new Run(this);

			fsm.setCurrentState(idle);

			fsm.addTransition(toWalk, idle, walk);
			fsm.addTransition(toRun, walk, run);
		});

		notifyOnUpdate(function() {
			fsm.execute();
		});
	}

	function toWalk() {
		return keyboard.started("1");
	}

	function toRun() {
		return keyboard.started("2");
	}
}