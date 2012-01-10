package UI;

import java.awt.FlowLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.BorderFactory;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JPanel;

import core.CoinHopper;
import core.ICoinHopperEventListener;
import core.SlotMachine;

/*
 * Representa a la maquina que entrega el dinero al jugador.
 */
@SuppressWarnings("serial")
public class CoinHopperPanel extends JPanel implements ICoinHopperEventListener{
	
	private JLabel creditLabel, dineroLabel;
	private JButton collectButton, collectAllButton;
	private CoinHopper coinHopper;
	private SlotMachineUI parent;
		
	public CoinHopperPanel(CoinHopper coinHopper, SlotMachineUI parent){
		this.coinHopper = coinHopper;
		this.parent = parent;
		this.creditLabel = new JLabel();
		this.dineroLabel = new JLabel();
		this.collectButton = new JButton("Collect these wins");
		this.collectAllButton = new JButton("Collect all money");
		
		this.setLayout(new FlowLayout());
		this.setBorder(BorderFactory.createTitledBorder("Coin Hopper"));
		
		this.dineroLabel.setVisible(false);
		this.dineroLabel.setIcon((new ImageIcon(main.class.getResource("/images/dinero.gif"))));

		
		this.add(this.dineroLabel);
		this.add(this.creditLabel);
		this.add(this.collectButton);
		this.add(this.collectAllButton);
		
		this.collectAllButton.addActionListener(new ActionListener() {
			
			
			public void actionPerformed(ActionEvent e) {
				try{
					getSlotMachineUI().getSlotMachine().setCredits(0);
					getSlotMachineUI().resetUI();
					setEnabled(false);
				}
				catch(Exception ex){}
			}
		});
		
		this.collectButton.addActionListener(new ActionListener() {
			
			public void actionPerformed(ActionEvent e) {
				try{
					getSlotMachineUI().retirarCredits();
					getSlotMachineUI().resetGamePanelUI();
					setEnabled(false);
				}
				catch(Exception ex){}	
			}
		});
		
		this.setEnabled(false);		
	}

	public void setEnabled(boolean b){
		this.creditLabel.setEnabled(b);
		this.collectButton.setEnabled(b);
		this.collectAllButton.setEnabled(b);
		this.dineroLabel.setVisible(false);
		this.creditLabel.setText("No existen cr�ditos ganados");
	}

	
	public void onCoinHopperPayoutEvent() {
		SlotMachine sm = this.parent.getSlotMachine();
		int payout = sm.getPayTable().getCantidadPagada();
		this.setEnabled(true);
		if(payout > 0) {
			this.dineroLabel.setVisible(true);	
			this.creditLabel.setText("�Ha ganado! -> " + payout);
		}
	}
	
	public SlotMachineUI getSlotMachineUI() throws Exception{
		return this.parent;
	}
	
}
