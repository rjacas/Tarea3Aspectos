package aspects;

import java.awt.GridBagLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.IOException;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JPanel;

import UI.SlotMachineUI;
import core.NVRAM2;
import core.SlotMachine;
import java.io.Serializable;

public aspect Recall {
	pointcut aspects(): within(Tracing) || within(Debug) || within(Meters) 
						|| within(HardwareFailManage) || within(UIManager)
						|| within(Persistency) || within(SingletonEnforcer) || within(Demo)
						|| within(TamperProof) || within(Recall);
	pointcut init(): call(* SlotMachineUI.getInstance()) && !aspects();
	pointcut action1(): call(* SlotMachine.play()) && within(UI.SlotMachineUI) && !aspects();
	pointcut action2(): call(* System.exit(..)) && within(UI.SlotMachineUI) && !aspects();
	pointcut action3(): call(* setText(..))	&& within(UI.BillAcceptorPanel) && !aspects();
	pointcut actions(): action1() || action2() || action3();
	
	declare parents : core.* implements Serializable;
	declare parents : UI.* implements Serializable;
	
	private static NVRAM2 saves[];
	private static int current,iterator,count;
	private JFrame frame;
	private JPanel buttons;
	private JButton inicial, next, stop;
	public static int special;
	
	after(): init(){ 
		if(frame == null)
			frame = newFrame();
		if(saves == null){
			saves = new NVRAM2[4];
			for(int i = 0; i<saves.length; i++)
				saves[i]= new NVRAM2();
		}
	}
	
	after(): actions(){
		try {
			if(Recall.special == 1){
				SlotMachineUI.getInstance().updateCredits();
			}
			saves[current].save();
		} catch (IOException e) {
			e.printStackTrace();
		}
		current=(current+1)%saves.length;
		iterator=current;
	}
	before(): action1(){
		special = 1;
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
			buttons.add(stop);
			stop.setEnabled(false);
			inicial.addActionListener(new ActionListener() {
				public void actionPerformed(ActionEvent e){
					inicial.setEnabled(false);
					stop.setEnabled(true);
			}});
			next.addActionListener(new ActionListener() {
				public void actionPerformed(ActionEvent e){
					if(!inicial.isEnabled()){
						if(count < saves.length){
							while(true){
								if(saves[iterator] == null)
									iterator=(iterator+1)%saves.length;
								else
									break;
							}
							try {
								saves[iterator].recover();
							} catch (IOException e1) {
								// TODO Auto-generated catch block
								e1.printStackTrace();
							} catch (ClassNotFoundException e1) {
								// TODO Auto-generated catch block
								e1.printStackTrace();
							}
							iterator=(iterator+1)%saves.length;
						}
						count++;
					}
			}});
			stop.addActionListener(new ActionListener() {
				public void actionPerformed(ActionEvent e){
					inicial.setEnabled(true);
					stop.setEnabled(false);
					count = 0;
					try {
						saves[(current+saves.length-1)%saves.length].recover();
					} catch (IOException e1) {
						// TODO Auto-generated catch block
						e1.printStackTrace();
					} catch (ClassNotFoundException e1) {
						// TODO Auto-generated catch block
						e1.printStackTrace();
					}
			}});
			ret.setSize(240, 100);
		} catch (Exception e) {
			e.printStackTrace();
		}
		ret.setLocationRelativeTo(null);
		ret.setVisible(true);
		return ret;
	}
	
}