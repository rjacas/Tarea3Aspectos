package UI;

import java.awt.Component;
import java.awt.Container;
import java.awt.FlowLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.*;
import javax.swing.border.TitledBorder;


import core.HardwareException;
import core.IBillAcceptorEventListener;
import core.ICoinHopperEventListener;
import core.Reel;
import core.SlotMachine;
import core.SpinDefaultEvent;

public class SlotMachineUI implements IBillAcceptorEventListener{
	
	public JFrame mainFrame;
	public JPanel gamePanel, hardwarePanel, cabeceraPanel, mainReelPanel, buttonPanel;
	public Container mainContainer;
	public TitledBorder title;
	public JLabel creditoLabel, creditoRealLabel;
	public JButton playButton, takeButton, failButton;
	public SlotMachine slotMachine;
	
	public SlotMachineUI(){
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
	}
	
	public void setSlotMachine(SlotMachine sm){
		this.slotMachine = sm;
	}
	
	
	public void createAndShowGUI(){
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
		

		this.mainReelPanel.add(new ReelPanel(this.slotMachine.getReel(0)));
		this.mainReelPanel.add(new ReelPanel(this.slotMachine.getReel(1)));
		this.mainReelPanel.add(new ReelPanel(this.slotMachine.getReel(2)));
		this.mainReelPanel.add(new ReelPanel(this.slotMachine.getReel(3)));
		this.mainReelPanel.add(new ReelPanel(this.slotMachine.getReel(4)));
		
		this.slotMachine.getReel(0).setSpinFinishEvent((ReelPanel)this.mainReelPanel.getComponent(0));		
		this.slotMachine.getReel(1).setSpinFinishEvent((ReelPanel)this.mainReelPanel.getComponent(1));		
		this.slotMachine.getReel(2).setSpinFinishEvent((ReelPanel)this.mainReelPanel.getComponent(2));		
		this.slotMachine.getReel(3).setSpinFinishEvent((ReelPanel)this.mainReelPanel.getComponent(3));
		this.slotMachine.getReel(4).setSpinFinishEvent((ReelPanel)this.mainReelPanel.getComponent(4));
		
		this.slotMachine.setListenerBillAcceptorAddCreditsEvent(this);
		
		
		this.buttonPanel.setLayout(new FlowLayout());
		
		this.takeButton.setEnabled(false);
		
		this.buttonPanel.add(this.playButton);
		this.buttonPanel.add(this.takeButton);
		
		this.gamePanel.add(this.cabeceraPanel);
		this.gamePanel.add(this.mainReelPanel);
		this.gamePanel.add(this.buttonPanel);
		
		this.updateCredits();
		
		/*
		 * hardwarePanel
		 */
		
		this.hardwarePanel.setBorder(BorderFactory.createTitledBorder("Hardware panel"));
		this.hardwarePanel.add(new BillAcceptorPanel(this.slotMachine.getBillAcceptor()));
		this.hardwarePanel.add(new CoinHopperPanel(this.slotMachine.getCoinHopper(), this));
		this.hardwarePanel.add(this.failButton);
		/*
		 * se a�aden los elementos principales
		 */
		
		this.mainContainer.add(this.gamePanel);
		this.mainContainer.add(this.hardwarePanel);
		this.mainFrame.pack();
		this.mainFrame.setVisible(true);
		((BillAcceptorPanel)this.hardwarePanel.getComponent(0)).grabFocus();
		this.setEnabled(false);
		this.mainFrame.setSize(900, 600);

		this.mainFrame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

		
		/*
		 * se a�aden listeners
		 */
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
	}
	
	public void resetGamePanelUI(){
		takeButton.setEnabled(false);
		playButton.setEnabled(true);
		for (Reel reel : slotMachine.getReels()) {
			SpinDefaultEvent eSpinDefault = new SpinDefaultEvent(reel);
			reel.setDefault();
			reel.dispatchSpinDefaultEvent(eSpinDefault);
		}
		playButton.grabFocus();
		hardwarePanel.getComponent(1).setEnabled(false);
	}
	
	public Component[] getMainReelComponents(){
		return this.mainReelPanel.getComponents();
	}
	
	public SlotMachine getSlotMachine(){
		return this.slotMachine;
	}
	
	public void updateCredits(){
		this.creditoRealLabel.setText(""+this.slotMachine.getCreditos());
	}
	
	public void setEnabled(boolean b){
		for (Component reel : this.mainReelPanel.getComponents()) {
			((ReelPanel)reel).setEnabled(b);
		}
		this.playButton.setEnabled(b);
		this.takeButton.setEnabled(b);
	}

	
	public void onBillAcceptorAddCreditsFinishEventOcurred() {
		// TODO Auto-generated method stub
		this.setEnabled(true);
		this.takeButton.setEnabled(false);
		this.creditoRealLabel.setText(""+this.slotMachine.getCreditos());
	}

	public void resetUI() {
		// TODO Auto-generated method stub
		this.creditoRealLabel.setText("0");
		this.setEnabled(false);
		((BillAcceptorPanel)this.hardwarePanel.getComponent(0)).grabFocus();
		this.slotMachine.reset();
	}

	public void retirarCredits() {
		// TODO Auto-generated method stub
		System.out.print(this.slotMachine.getPayTable().getCantidadPagada());
		this.slotMachine.setCredits(-1 * this.slotMachine.getPayTable().getCantidadPagada());
		this.creditoRealLabel.setText(""+this.slotMachine.getCreditos());
		this.takeButton.grabFocus();
	}
	
	public void close(){
		this.mainFrame.dispose();
	}
	
}
