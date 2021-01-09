package arm;

import arm.FSM;
import arm.States;
import iron.system.Input;

class Test extends iron.Trait {
	var kb = Input.getKeyboard();
	var fsm: FSM;

	public function new() {
		super();

		notifyOnInit(function() {
			fsm = new FSM();

			var idle = new Idle();
			var jumpStart = new JumpStart();
			var jumpLoop = new JumpLoop();
			var landing = new Landing();

			fsm.setInitState(idle);

			fsm.addTransition(toJumpStart, idle, jumpStart);
			fsm.addTransition(toJumpLoop, jumpStart, jumpLoop);
			fsm.addTransition(toLanding, jumpLoop, idle);
		});

		notifyOnUpdate(function() {
			fsm.execute();
		});
	}

	public function toJumpStart() {
		return kb.started("1");
	}

	public function toJumpLoop() {
		return kb.started("1");
	}

	public function toLanding() {
		return kb.started("1");
	}
}
