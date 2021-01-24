package arm;

import libraries.FSM;
import iron.system.Input;

/*
Notes:

	1. You can create "sub" FSMs inside states and it will work properly...
	2. Always use the same function to go to the same state, this will
	avoid a LOT of confusion. Try to don't bind states as below:

		2.1. As you could see, two different functions are calling for the same state. 
		Don't do that.

		"WRONG"!!!:
			StateA > Function X                > StateB
			StateC > Function X AND Function Y > StateB

		2.2. Instead, i do recommend you to find another way by creating new states that
		extends a particular state. In practice they would be the same state doing the
		same work, but for the FSM they will be treated as different states.

		RIGHT:
			StateA        > Function X > StateB
			StateC        > Function Y > Pseudo StateC
			Pseudo StateC > Function X > StateB
*/

class Test extends iron.Trait {

	var kb = Input.getKeyboard();

	public function new() {
		super();

		var fsm: FSM;

		notifyOnInit(function() {
			fsm = new FSM();
			var state1 = new State1(this);
			var state2 = new State2(this);
			var state3 = new State3(this);

			fsm.setState(state1);

			// This FSM allows to go only to connected states (wihout jump from 1 to 3 or vice-versa).]

			fsm.bindTransitions(toState1, state1, [state2]); // Can go to state1 from state 2
			fsm.bindTransitions(toState2, state2, [state1, state3]); // Can go to state 2 from states 1 or 3
			fsm.bindTransitions(toState3, state3, [state2]); // Can go to state3 from state 2
		});

		notifyOnUpdate(function() {
			fsm.run();
		});
	}

	function toState1() {
		return kb.started("1");
	}

	function toState2() {
		return kb.started("2");
	}

	function toState3() {
		return kb.started("3");
	}
}

class MyStateDesign implements State { // A interface is used here to don't dictate the constructor params
	var trait: Test;

	public function new(trait: Test) {
		this.trait = trait;
	}

	public function onEnter() {}

	public function onUpdate() {}

	public function onExit() {}
}

class State1 extends MyStateDesign {
	public override function onEnter() {
		trace("| State 1 |");
	}

	//public override function onUpdate() {}

	//public override function onExit() {}
}

class State2 extends MyStateDesign {
	public override function onEnter() {
		trace("| State 2 |");
	}
}

class State3 extends MyStateDesign {
	public override function onEnter() {
		trace("| State 3 |");
	}
}