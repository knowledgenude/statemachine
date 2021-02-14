package arm;

import libraries.FSM;
import iron.system.Input;

class Test extends iron.Trait {

	var kb = Input.getKeyboard();

	public function new() {
		super();

		// The fsm is initialized here to stay in the notifyOnUpdate scope
		var fsm = new FSM<Test>();

		notifyOnInit(function() {
			// Step 1 - Construct the fsm states
			var state1 = new State1(this);
			var state2 = new State2(this);
			var state3 = new State3(this);

			// Step 2 - Set the initial state of the fsm
			fsm.setInitState(state1);

			// Step 3 - Bind the fsm states
			fsm.bindTransition(toState1, state3, state1); // Allows to go from state 3 back to state 1...
			fsm.bindTransition(toState2, state1, state2); // Allows to go from state 1 to state 2...
			fsm.bindTransition(toState3, state2, state3); // Allows to go from state 2 to state 3...
		});

		notifyOnUpdate(function() {
			// Final step - Update the fsm
			fsm.update();
		});
	}

	// When these methods returns `true`, its respective transition happens
	function toState1() {
		return kb.started("1");
	}

	function toState2() {
		return kb.started("2");
	}

	function toState3() {
		return kb.started("3");
	}

	// Example method called by the fsm states
	public function traceSomething(s: String) {
		trace(s);
	}
}

class State1 extends State<Test> {
	public override function onEnter() {
		owner.traceSomething("Entered state 1");
	}

	//public override function onUpdate() {}

	//public override function onExit() {}
}

class State2 extends State<Test> {
	public override function onEnter() {
		owner.traceSomething("Entered state 2");
	}

	//public override function onUpdate() {}

	//public override function onExit() {}
}

class State3 extends State<Test> {
	public override function onEnter() {
		owner.traceSomething("Entered state 3");
	}

	//public override function onUpdate() {}

	//public override function onExit() {}
}