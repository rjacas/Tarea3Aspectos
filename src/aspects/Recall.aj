package aspects;

import java.awt.GridBagLayout;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.JButton;
import javax.swing.JCheckBox;
import javax.swing.JComboBox;
import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.JTextField;

import UI.SlotMachineUI;
import core.NVRAM2;
import core.SlotMachine;

public aspect Recall {
	pointcut aspects(): within(Tracing) || within(Debug) || within(Meters)
						|| within(Persistency) || within(SingletonEnforcer) || within(Demo)
						|| within(TamperProof) || within(Recall);
	pointcut init(): call(* SlotMachineUI.getInstance()) && !aspects();
	pointcut action1(): (call(* SlotMachine.play()) || call(* SlotMachineUI.resetGamePanelUI()))
						&& !aspects();
	pointcut action2(): call(* SlotMachine.fail(..)) && !aspects();
	pointcut action3(): call(* SlotMachine.setCredits(int)) && within(UI.CoinHopperPanel)
						&& !aspects();
	pointcut action4(): call(* SlotMachineUI.retirarCredits()) && within(UI.CoinHopperPanel)
						&& !aspects();
	pointcut action5(): call(* core.BillAcceptor.detect(..))
						&& within(UI.BillAcceptorPanel) && !aspects();;
	pointcut actions(): action1() || action2() || action3() || action4() || action5();
	
	private static NVRAM2 saves[];
	private static int current,iterator;
	private static SlotMachine sm;
	private static SlotMachineUI smui;
	private JFrame frame;
	private JPanel buttons;
	private JButton inicial, next, stop;
	
	after(): init(){ 
		if(frame == null)
			frame = newFrame();
		if(saves == null)
			saves = new NVRAM2[4];
		if(sm == null)
			sm = SlotMachineUI.getInstance().slotMachine;
		if(smui == null)
			smui = SlotMachineUI.getInstance();
	}
	
	before(): actions(){
		saves[current].save();
		current=(current+1)%saves.length;
		iterator=(current+1)%saves.length;
	}
	
	
	public JFrame newFrame(){
		JFrame ret = new JFrame("Recall");
		try {
			buttons = new JPanel(new GridBagLayout());
			inicial = new JButton("Start");
			next = new JButton("Next");
			stop = new JButton("Stop");
			ret.add(buttons);
			buttons.add(inicial);
			buttons.add(next);
			buttons.add(ret);
			stop.setEnabled(false);
			inicial.addActionListener(new ActionListener() {
				public void actionPerformed(ActionEvent e){
					inicial.setEnabled(false);
					stop.setEnabled(true);
			}});
			next.addActionListener(new ActionListener() {
				public void actionPerformed(ActionEvent e){
					if(!inicial.isEnabled()){
						if(iterator != current){
							while(saves[iterator] == null)
								iterator=(iterator+1)%saves.length;
							saves[iterator].recover(smui);
							iterator=(iterator+1)%saves.length;
						}
					}
			}});
			stop.addActionListener(new ActionListener() {
				public void actionPerformed(ActionEvent e){
					inicial.setEnabled(true);
					stop.setEnabled(false);
					saves[current].recover(smui);
			}});
			ret.setSize(450, 240);
		} catch (Exception e) {
			e.printStackTrace();
		}
		ret.setLocationRelativeTo(null);
		ret.setVisible(true);
		return ret;
	}
	
}