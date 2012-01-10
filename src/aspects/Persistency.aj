package aspects;

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

import core.HardwareException;
import core.ICoinHopperEventListener;
import core.NVRAM;
import core.SlotMachine;

import UI.BillAcceptorPanel;
import UI.CoinHopperPanel;
import UI.ReelPanel;
import UI.SlotMachineUI;

public aspect Persistency {
	pointcut aspects(): within(Tracing) || within(Debug) || within(Meters)
					|| within(Persistency) || within(SingletonEnforcer) || within(Demo)
					|| within(TamperProof) || within(Recall) || within (HardwareFailManage);
	
	pointcut lOff(): call(* SlotMachineUI.close());
	
	void UI.SlotMachineUI.lightsOff(){}
	void UI.SlotMachineUI.lightsOn(){}
	
	public static SlotMachine NVRAM.slotMachine;
	public static boolean NVRAM.wasEnabled;
	public static boolean NVRAM.wasInit;
	public static boolean NVRAM.play;
	public static boolean NVRAM.take;
	//demo stuff
	public static boolean NVRAM.demoActivated;
	public static boolean NVRAM.rc;
	public static boolean NVRAM.cc;
	public static boolean NVRAM.bc;
	public static int[] NVRAM.demoReels; 
	public static int NVRAM.demoCoins;
	//Meters stuff
	public static int NVRAM.plays;
	public static int NVRAM.mmoney;
	public static int NVRAM.wins;
	public static int NVRAM.lwinc;
	public static int NVRAM.redeem;
	public static int NVRAM.lredeemc;
	public static int NVRAM.insert;
	public static int NVRAM.linsertc;
	public static String[] NVRAM.f;
	
	before(): lOff(){
		NVRAM.wasInit = SlotMachineUI.getInstance().takeButton.isEnabled();
		NVRAM.wasEnabled = (SlotMachineUI.getInstance().slotMachine.credits != 0);
		NVRAM.play = SlotMachineUI.getInstance().playButton.isEnabled();
		NVRAM.take = SlotMachineUI.getInstance().takeButton.isEnabled();
		NVRAM.slotMachine  = SlotMachineUI.getInstance().slotMachine;
		//demo stuff
		NVRAM.demoActivated = Demo.activated;
		NVRAM.rc = Demo.rc;
		NVRAM.cc = Demo.cc;
		NVRAM.bc = Demo.bc;
		NVRAM.demoReels = Demo.reels; 
		NVRAM.demoCoins = Demo.coins;
		//Meters stuff
		NVRAM.plays = Meters.plays;
		NVRAM.mmoney = Meters.mmoney;
		NVRAM.wins = Meters.wins;
		NVRAM.lwinc = Meters.lwinc;
		NVRAM.redeem = Meters.redeem;
		NVRAM.lredeemc = Meters.lredeemc;
		NVRAM.insert = Meters.insert;
		NVRAM.linsertc = Meters.linsertc;
		NVRAM.f = Meters.f;
		Demo.close();
		Meters.close();
	}
	
	
	public void UI.SlotMachineUI.recover(){	
		this.mainFrame = new JFrame("My Slot Machine");
		this.gamePanel = new JPanel();
		this.hardwarePanel = new JPanel();		
		this.cabeceraPanel = new JPanel();
		this.mainReelPanel = new JPanel();
		this.buttonPanel = new JPanel();		
		this.creditoLabel = new JLabel("cr�ditos:");
		this.creditoRealLabel = new JLabel();	
		this.playButton = new JButton("Play");
		this.takeButton = new JButton("Continue");
		this.failButton = new JButton("Kick the machine!");
		
		this.slotMachine = NVRAM.slotMachine;
		
		this.mainContainer = this.mainFrame.getContentPane();
		this.mainContainer.setLayout(new BoxLayout(this.mainContainer, BoxLayout.Y_AXIS));

		this.gamePanel.setLayout(new BoxLayout(this.gamePanel, BoxLayout.Y_AXIS));
		this.title = BorderFactory.createTitledBorder("Super Fruit Machine");
		this.gamePanel.setBorder(this.title);

		this.cabeceraPanel.setLayout(new FlowLayout());

		this.cabeceraPanel.add(creditoLabel);
		this.cabeceraPanel.add(creditoRealLabel);
		this.cabeceraPanel.setAlignmentX(Component.CENTER_ALIGNMENT);

		this.mainReelPanel.setLayout(new FlowLayout());
		
		ReelPanel[] a= new ReelPanel[5];
		for(int i = 0; i < a.length; i++){
			a[i] = new ReelPanel(this.slotMachine.getReel(i));
			this.mainReelPanel.add(new ReelPanel(this.slotMachine.getReel(i)));
			this.slotMachine.getReel(i).setSpinFinishEvent((ReelPanel)this.mainReelPanel.getComponent(i));
			int b = this.slotMachine.getReel(i).getCampo();
			if(b >= 0)
				((ReelPanel)this.mainReelPanel.getComponent(i)).
					setIcon(this.slotMachine.getReel(i).getCampo());
		}
		
		this.slotMachine.setListenerBillAcceptorAddCreditsEvent(this);
		
		this.buttonPanel.setLayout(new FlowLayout());
		
		this.takeButton.setEnabled(false);
		
		this.buttonPanel.add(this.playButton);
		this.buttonPanel.add(this.takeButton);
		
		this.gamePanel.add(this.cabeceraPanel);
		this.gamePanel.add(this.mainReelPanel);
		this.gamePanel.add(this.buttonPanel);
		
		this.updateCredits();
		
		this.hardwarePanel.setBorder(BorderFactory.createTitledBorder("Hardware panel"));
		this.hardwarePanel.add(new BillAcceptorPanel(this.slotMachine.getBillAcceptor()));
		this.hardwarePanel.add(new CoinHopperPanel(this.slotMachine.getCoinHopper(), this));
		this.hardwarePanel.add(this.failButton);

		this.mainContainer.add(this.gamePanel);
		this.mainContainer.add(this.hardwarePanel);
		this.mainFrame.pack();
		this.mainFrame.setVisible(true);
		this.setEnabled(NVRAM.wasEnabled);
		this.mainFrame.setSize(900, 600);

		this.mainFrame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

		this.slotMachine.getPayTable().setListener((ICoinHopperEventListener)this.hardwarePanel.getComponent(1));
		
		this.playButton.addActionListener(new ActionListener() {
			
			
			public void actionPerformed(ActionEvent e) {
				try {
					getSlotMachine().play();
				} catch (Exception e1) {
					// TODO Auto-generated catch block
					//e1.printStackTrace();
				}					
				playButton.setEnabled(false);
				takeButton.setEnabled(true);
				updateCredits();
				takeButton.grabFocus();
			}
		});		
	
		this.takeButton.addActionListener(new ActionListener() {
			
			
			public void actionPerformed(ActionEvent e) {
				// TODO Auto-generated method stub
				resetGamePanelUI();
			}
		});
		
		this.failButton.addActionListener(new ActionListener() {
			
			
			public void actionPerformed(ActionEvent e) {
				try {
					getSlotMachine().fail(mainContainer);
				} catch (HardwareException e1) {
					System.exit(1);
				}
			}
		});
		
		this.setEnabled(NVRAM.wasInit);
		hardwarePanel.getComponent(1).setEnabled(NVRAM.take);
		this.hardwarePanel.setEnabled(NVRAM.take);
		this.playButton.setEnabled(NVRAM.play);
		this.takeButton.setEnabled(NVRAM.take);
		if(this.slotMachine.getPayTable().getCantidadPagada()>0)
			((CoinHopperPanel)this.hardwarePanel.getComponent(1)).onCoinHopperPayoutEvent(); 
		if(NVRAM.play)
			this.playButton.grabFocus();
		else if(NVRAM.take)
			this.takeButton.grabFocus();
	}
	
	public static void recoverDemo(){
		Demo.activated = NVRAM.demoActivated;
		if(Demo.activated)
		Demo.activate.setSelected(Demo.activated);
		Demo.rc = NVRAM.rc;
		Demo.rl.setEnabled(!Demo.rc);
		Demo.cc = NVRAM.cc;
		Demo.coc.setEnabled(!Demo.cc);
		Demo.bc = NVRAM.bc;
		Demo.bac.setEnabled(!Demo.bc);
		Demo.reels = NVRAM.demoReels;
		for(int i=0; i < 5; i++){
			if(NVRAM.demoReels != null)
				Demo.r[i].setSelectedIndex(NVRAM.demoReels[i]);
		}
		Demo.coins = NVRAM.demoCoins;
	}
	
	public static void recoverMeters(){
		Meters.plays = NVRAM.plays;
		Meters.mmoney = NVRAM.mmoney;
		Meters.wins = NVRAM.wins;
		Meters.lwinc = NVRAM.lwinc;
		Meters.redeem = NVRAM.redeem;
		Meters.lredeemc = NVRAM.lredeemc;
		Meters.insert = NVRAM.insert;
		Meters.linsertc = NVRAM.linsertc;
		Meters.f = NVRAM.f;
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
