package aspects;

import core.Enclosure;
import core.SlotMachine;
import UI.SlotMachineUI;

public aspect TamperProof {
	pointcut aspects(): within(Tracing) || within(Debug) || within(Meters)
					|| within(Persistency) || within(SingletonEnforcer) || within(Demo)
					|| within(TamperProof) || within(Recall) || within (HardwareFailManage);
	
	pointcut init(): call(* SlotMachineUI.getInstance()) && !aspects();
	
	private Enclosure enc;
	private SlotMachine sm;
	private SlotMachineUI smui;
	
	after(): init(){ 
		if(enc == null)
			enc = new Enclosure();
		if(sm == null)
			sm = SlotMachineUI.getInstance().slotMachine;
		if(smui == null)
			smui = SlotMachineUI.getInstance();
	}
}
