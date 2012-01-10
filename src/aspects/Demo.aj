package aspects;

import javax.swing.*;

import UI.SlotMachineUI;

import core.BillAcceptor;
import core.HardwareException;
import core.Reel;
import core.SlotMachine;
import core.SpinFinishEvent;

import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public aspect Demo {
	pointcut aspects(): within(Tracing) || within(Debug) || within(Meters)
					|| within(Persistency) || within(SingletonEnforcer) || within(Demo)
					|| within(TamperProof) || within(Recall) || within (HardwareFailManage);
	
	pointcut demospin(Reel r): target(r) &&	call(void core.Reel.spin()) 
							&& withincode(void core.SlotMachine.play());
	
	pointcut reelcrash(): execution(void core.Reel.spin()) && !aspects();
	pointcut chcrash(): execution(* UI.CoinHopperPanel.getSlotMachineUI()) 
						&& within(UI.CoinHopperPanel);
	pointcut bacrash(): execution(* UI.BillAcceptorPanel.getBillAcceptor()) 
						&& within(UI.BillAcceptorPanel);
	
	pointcut init(): call(* SlotMachineUI.getInstance()) && !aspects();
	
	pointcut recover(): call(* SlotMachineUI.recover());
	
	
	public static boolean activated;
	public static boolean rc,cc,bc;
	public static int[] reels; 
	public static int coins;
	
	void around(Reel r) throws HardwareException: demospin(r){
		if(reels == null)
			reels = new int[5];
		if(activated){
			if (r.getEstado() == Reel.BLOQUEADO){
				try {
					throw new HardwareException("Reel is blocked");
				} catch (Exception e1) {
					e1.printStackTrace();
				}
			}
			if(rc){
				rc = false;
				rl.setEnabled(true);
				throw new HardwareException("Reel is blocked");
			}
			r.setEstadoGirar();
			r.campo = reels[Integer.parseInt(r.nombre.substring(r.nombre.length()-1))];
			r.setEstadoActivar();
			SpinFinishEvent e = new SpinFinishEvent(r); 
			r.dispatchSpinFinishEvent(e);
			
		}
		else
			 proceed(r);
	}
	
	void around() throws HardwareException: reelcrash() {
		if(activated && rc){
			rc = false;
			rl.setEnabled(true);
			throw new HardwareException("Reel exploded D:!!");
		}
		else
			proceed();
	}
	
	SlotMachineUI around() throws HardwareException: chcrash() {
		if(activated && cc){
			cc = false;
			coc.setEnabled(true);
			throw new HardwareException("Coin Hopper got stuck");
		}
		else
			return proceed();
	}
	
	BillAcceptor around() throws HardwareException: bacrash() {
		if(activated && bc){
			bc = false;
			bac.setEnabled(true);
			throw new HardwareException("Bill Acceptor ate your money :(");
		}
		else
			return proceed();
	}
	//Demo UI things
	public static SlotMachineUI smui;
	public static SlotMachine sm;
	public static JFrame frame, lframe;
	public static JPanel meta, activation, money, buttons;
	public static JCheckBox activate;
	public static JTextField mny;
	public static JButton mney, rl, coc, bac, actr;
    public static JComboBox[] r;
    
    //Persistency UI things
    public JPanel pmeta, title, pbuttons;
    public JLabel tit;
    public JButton inter,restart;
    
    
    
	after(): init(){ 
		if(frame == null)
			frame = newFrame();
		if(lframe == null)
			lframe = newFrameL();
		if(sm == null)
			sm = SlotMachineUI.getInstance().slotMachine;
		if(smui == null)
			smui = SlotMachineUI.getInstance();
	}
	
	after(): recover(){ 
			frame = newFrame();
			sm = SlotMachineUI.getInstance().slotMachine;
			smui = SlotMachineUI.getInstance();
			Persistency.recoverDemo();
	}
	
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
	
	public JFrame newFrameL(){
		JFrame ret = new JFrame("Lights Off Sim");
		pmeta = new JPanel(new GridLayout(2,1));
		title = new JPanel(new GridBagLayout()); 
		pbuttons =  new JPanel(new GridBagLayout());
		tit = new JLabel("Persistency");
		inter = new JButton("Lights Off");
		restart = new JButton("Lights On");
		ret.add(pmeta);
		pmeta.add(title);
		pmeta.add(pbuttons);
		title.add(tit);
		pbuttons.add(inter);
		pbuttons.add(restart);
		inter.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e){ 
				SlotMachineUI.getInstance().close();
		}});
		restart.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e){ 
				UIManager.reboot = true;
				SlotMachineUI.getInstance();
		}});
		ret.setSize(300, 100);
		ret.setLocationRelativeTo(null);
		ret.setVisible(true);
		return ret;
	}
	
	public static void close(){
		frame.dispose();
	}
}
