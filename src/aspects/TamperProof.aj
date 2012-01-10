package aspects;

import core.Enclosure;
import core.SlotMachine;
import UI.BillAcceptorPanel;
import UI.SlotMachineUI;

public aspect TamperProof {
	pointcut aspects(): within(Tracing) || within(Debug) || within(Meters)
					|| within(Persistency) || within(SingletonEnforcer) || within(Demo)
					|| within(TamperProof) || within(Recall) || within (HardwareFailManage);
	
	pointcut init(): call(* SlotMachineUI.getInstance()) && !aspects();
	
	pointcut open(): call(* Enclosure.open());
	pointcut trigger(): call(* Enclosure.trigger());
	
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

	after(): open(){ 
		smui.close();
	}
	
	
	after(): trigger(){ 
		if(enc.getState().equals("Todo bien")){
			enc.close();
			smui.recover();
			
		}
			
		if(enc.getState().equals("Payback")){
			enc.close();
			smui.recover();
			smui.resetUI();
		}
	}
	
}
