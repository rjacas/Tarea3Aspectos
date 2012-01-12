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
	private static int current;
	private static SlotMachine sm;
	private static SlotMachineUI smui;
	
	after(): init(){ 
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
	}
	
	private JFrame frame;
	private JPanel meta;
	
	
	public JFrame newFrame(){
		JFrame ret = new JFrame("Demo");
		try {
			meta = new JPanel(new GridLayout(3,1));
			activation = new JPanel(new GridBagLayout());
			money = new JPanel(new GridBagLayout());
			buttons = new JPanel(new GridBagLayout());
			activate = new JCheckBox("Activated");
			actr = new JButton("Use Values");
			r = new JComboBox[5];
			for(int i=0;i<5;i++){
				r[i]=new JComboBox();
				for (int j = 0; j < 10; j++)
				      r[i].addItem(j);
			}
			mny = new JTextField("",16);
			mney = new JButton("Insert Coins");
			rl = new JButton("Reel Excp");
			coc = new JButton("Coin Hopper Excp");
			bac = new JButton("Bill Acceptor Excp");
			ret.add(meta);
			meta.add(activation);
			meta.add(money);
			meta.add(buttons);
			activation.add(activate);
			activation.add(actr);
			for(int i=0;i<5;i++)
				activation.add(r[i]);
			money.add(mney);
			money.add(mny);
			buttons.add(rl);
			buttons.add(coc);
			buttons.add(bac);
			activate.addActionListener(new ActionListener() {
				public void actionPerformed(ActionEvent e){
					if(activate.isSelected())
						activated = true;
					else
						activated = false;
			}});
			actr.addActionListener(new ActionListener() {
				public void actionPerformed(ActionEvent e){
					if(activated){
						for(int i=0; i<5;i++)
							reels[i] = ((Integer)r[i].getSelectedItem()).intValue();
					}
			}});			
			mney.addActionListener(new ActionListener() {
				public void actionPerformed(ActionEvent e){
					if(activated){
						coins=Integer.parseInt(mny.getText());
						sm.setCredits(coins);
						smui.updateCredits();
						smui.setEnabled(true);
					}
			}});
			rl.addActionListener(new ActionListener() {
				public void actionPerformed(ActionEvent e){ 
					rc = true;
					rl.setEnabled(false);
			}});
			coc.addActionListener(new ActionListener() {
				public void actionPerformed(ActionEvent e){ 
					cc = true;
					coc.setEnabled(false);
			}});
			bac.addActionListener(new ActionListener() {
				public void actionPerformed(ActionEvent e){ 
					bc = true;
					bac.setEnabled(false);
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