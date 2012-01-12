package core;

import java.awt.Component;
import java.awt.FlowLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.BorderFactory;
import javax.swing.BoxLayout;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;

import UI.BillAcceptorPanel;
import UI.CoinHopperPanel;
import UI.ReelPanel;
import UI.SlotMachineUI;
import aspects.Demo;
import aspects.Meters;

public class NVRAM2 {
	private SlotMachine slotMachine;
	private boolean wasEnabled;
	private boolean wasInit;
	private boolean play;
	private boolean take;
	//demo stuff
	private boolean demoActivated;
	private boolean rc;
	private boolean cc;
	private boolean bc;
	private int[] demoReels; 
	private int demoCoins;
	//Meters stuff
	private int plays;
	private int mmoney;
	private int wins;
	private int lwinc;
	private int redeem;
	private int lredeemc;
	private int insert;
	private int linsertc;
	private String[] f;
	
	public void save(){
		this.wasInit = SlotMachineUI.getInstance().takeButton.isEnabled();
		this.wasEnabled = (SlotMachineUI.getInstance().slotMachine.credits != 0);
		this.play = SlotMachineUI.getInstance().playButton.isEnabled();
		this.take = SlotMachineUI.getInstance().takeButton.isEnabled();
		this.slotMachine  = SlotMachineUI.getInstance().slotMachine;
		//demo stuff
		this.demoActivated = Demo.activated;
		this.rc = Demo.rc;
		this.cc = Demo.cc;
		this.bc = Demo.bc;
		this.demoReels = Demo.reels; 
		this.demoCoins = Demo.coins;
		//Meters stuff
		this.plays = Meters.plays;
		this.mmoney = Meters.mmoney;
		this.wins = Meters.wins;
		this.lwinc = Meters.lwinc;
		this.redeem = Meters.redeem;
		this.lredeemc = Meters.lredeemc;
		this.insert = Meters.insert;
		this.linsertc = Meters.linsertc;
		this.f = Meters.f;
	}
	
	
	public void recover(SlotMachineUI a){	
		a.mainFrame = new JFrame("My Slot Machine");
		a.gamePanel = new JPanel();
		a.hardwarePanel = new JPanel();		
		a.cabeceraPanel = new JPanel();
		a.mainReelPanel = new JPanel();
		a.buttonPanel = new JPanel();		
		a.creditoLabel = new JLabel("cr�ditos:");
		a.creditoRealLabel = new JLabel();	
		a.playButton = new JButton("Play");
		a.takeButton = new JButton("Continue");
		a.failButton = new JButton("Kick the machine!");
		
		a.slotMachine = this.slotMachine;
		
		a.mainContainer = a.mainFrame.getContentPane();
		a.mainContainer.setLayout(new BoxLayout(a.mainContainer, BoxLayout.Y_AXIS));

		a.gamePanel.setLayout(new BoxLayout(a.gamePanel, BoxLayout.Y_AXIS));
		a.title = BorderFactory.createTitledBorder("Super Fruit Machine");
		a.gamePanel.setBorder(a.title);

		a.cabeceraPanel.setLayout(new FlowLayout());

		a.cabeceraPanel.add(a.creditoLabel);
		a.cabeceraPanel.add(a.creditoRealLabel);
		a.cabeceraPanel.setAlignmentX(Component.CENTER_ALIGNMENT);

		a.mainReelPanel.setLayout(new FlowLayout());
		
		ReelPanel[] b= new ReelPanel[5];
		for(int i = 0; i < b.length; i++){
			b[i] = new ReelPanel(a.slotMachine.getReel(i));
			a.mainReelPanel.add(new ReelPanel(a.slotMachine.getReel(i)));
			a.slotMachine.getReel(i).setSpinFinishEvent((ReelPanel)a.mainReelPanel.getComponent(i));
			int c = a.slotMachine.getReel(i).getCampo();
			if(c >= 0)
				((ReelPanel)a.mainReelPanel.getComponent(i)).
					setIcon(a.slotMachine.getReel(i).getCampo());
		}
		
		a.slotMachine.setListenerBillAcceptorAddCreditsEvent(a);
		
		a.buttonPanel.setLayout(new FlowLayout());
		
		a.takeButton.setEnabled(false);
		
		a.buttonPanel.add(a.playButton);
		a.buttonPanel.add(a.takeButton);
		
		a.gamePanel.add(a.cabeceraPanel);
		a.gamePanel.add(a.mainReelPanel);
		a.gamePanel.add(a.buttonPanel);
		
		a.updateCredits();
		
		a.hardwarePanel.setBorder(BorderFactory.createTitledBorder("Hardware panel"));
		a.hardwarePanel.add(new BillAcceptorPanel(a.slotMachine.getBillAcceptor()));
		a.hardwarePanel.add(new CoinHopperPanel(a.slotMachine.getCoinHopper(), a));
		a.hardwarePanel.add(a.failButton);

		a.mainContainer.add(a.gamePanel);
		a.mainContainer.add(a.hardwarePanel);
		a.mainFrame.pack();
		a.mainFrame.setVisible(true);
		a.setEnabled(this.wasEnabled);
		a.mainFrame.setSize(900, 600);

		a.mainFrame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

		a.slotMachine.getPayTable().setListener((ICoinHopperEventListener)a.hardwarePanel.getComponent(1));
		
		a.playButton.addActionListener(new ActionListener() {
			
			
			public void actionPerformed(ActionEvent e) {				
				try {
					SlotMachineUI.getInstance().getSlotMachine().play();
				} catch (Exception e1) {
					// TODO Auto-generated catch block
					//e1.printStackTrace();
				}					
				SlotMachineUI.getInstance().playButton.setEnabled(false);
				SlotMachineUI.getInstance().takeButton.setEnabled(true);
				SlotMachineUI.getInstance().updateCredits();
				SlotMachineUI.getInstance().takeButton.grabFocus();
			}
		});		
	
		a.takeButton.addActionListener(new ActionListener() {
			
			
			public void actionPerformed(ActionEvent e) {
				// TODO Auto-generated method stub
				SlotMachineUI.getInstance().resetGamePanelUI();
			}
		});
		
		a.failButton.addActionListener(new ActionListener() {
			
			
			public void actionPerformed(ActionEvent e) {
				try {
					SlotMachineUI.getInstance()
					.getSlotMachine().fail(SlotMachineUI.getInstance().mainContainer);
				} catch (HardwareException e1) {
					System.exit(1);
				}
			}
		});
		
		a.setEnabled(this.wasInit);
		a.hardwarePanel.getComponent(1).setEnabled(this.take);
		a.hardwarePanel.setEnabled(this.take);
		a.playButton.setEnabled(this.play);
		a.takeButton.setEnabled(this.take);
		if(a.slotMachine.getPayTable().getCantidadPagada()>0)
			((CoinHopperPanel)a.hardwarePanel.getComponent(1)).onCoinHopperPayoutEvent(); 
		if(this.play)
			a.playButton.grabFocus();
		else if(this.take)
			a.takeButton.grabFocus();
		this.recoverDemo();
		this.recoverMeters();
	}
	
	public void recoverDemo(){
		Demo.activated = demoActivated;
		if(Demo.activated)
		Demo.activate.setSelected(Demo.activated);
		Demo.rc = rc;
		Demo.rl.setEnabled(!Demo.rc);
		Demo.cc = cc;
		Demo.coc.setEnabled(!Demo.cc);
		Demo.bc = bc;
		Demo.bac.setEnabled(!Demo.bc);
		Demo.reels = demoReels;
		for(int i=0; i < 5; i++){
			if(demoReels != null)
				Demo.r[i].setSelectedIndex(demoReels[i]);
		}
		Demo.coins = demoCoins;
	}
	
	public void recoverMeters(){
		Meters.plays = plays;
		Meters.mmoney = mmoney;
		Meters.wins = wins;
		Meters.lwinc = lwinc;
		Meters.redeem = redeem;
		Meters.lredeemc = lredeemc;
		Meters.insert = insert;
		Meters.linsertc = linsertc;
		Meters.f = f;
		Meters.values[0].setText(""+Meters.plays);
		Meters.values[1].setText(""+Meters.wins);
		Meters.values[2].setText(""+Meters.insert);
		Meters.values[3].setText(""+Meters.redeem);
		if(Meters.f[0] == null)
			Meters.values[4].setText(""+0);
		else
			Meters.values[4].setText(Meters.f[0]);
		if(Meters.f[1] == null)
			Meters.values[5].setText(""+0);
		else
			Meters.values[5].setText(Meters.f[1]);
		Meters.values[6].setText(""+Meters.mmoney);
		if(Meters.f[2] == null)
			Meters.values[7].setText(""+0);
		else
			Meters.values[7].setText(Meters.f[2]);
		if(Meters.f[3] == null)
			Meters.values[8].setText(""+0);
		else
			Meters.values[8].setText(Meters.f[3]);
	}
}
