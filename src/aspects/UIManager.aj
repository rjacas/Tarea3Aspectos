package aspects;

import core.SlotMachine;
import UI.SlotMachineUI;

public aspect UIManager extends SingletonEnforcer{
	pointcut callMe(): call(UI.SlotMachineUI.new(..))
			&& !(within(UIManager) || within(UI.SlotMachineUI));
	
	public static SlotMachine current;
	public static boolean reboot;
	public static SlotMachineUI SlotMachineUI.myInstance;
	
	
	public static SlotMachineUI SlotMachineUI.getInstance() {		
		if(SlotMachineUI.myInstance == null){
			SlotMachineUI.myInstance = new SlotMachineUI();
			SlotMachineUI.myInstance.setSlotMachine(new SlotMachine());
			SlotMachineUI.myInstance.createAndShowGUI();
		}
		if(reboot){
			reboot = false;
			SlotMachineUI.myInstance.recover();
		}
		if(current == null){
			current = SlotMachineUI.myInstance.slotMachine;
		}
		return SlotMachineUI.myInstance;
	}
	
	public static void SlotMachineUI.setSlotMachineUI(SlotMachineUI a){
		myInstance = a;
	}
	
}
