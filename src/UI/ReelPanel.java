package UI;
import java.awt.Component;

import javax.swing.BoxLayout;
import javax.swing.ImageIcon;
import javax.swing.JLabel;
import javax.swing.JPanel;


import core.ISpinEventListener;
import core.Reel;


@SuppressWarnings("serial")
public class ReelPanel extends JPanel implements ISpinEventListener{

	private JLabel iconLabel;
	private JLabel messageLabel;
	
	private Reel reel;
	
	public ReelPanel(Reel reel){
		super();
		this.iconLabel = new JLabel();
		this.messageLabel = new JLabel("Reeling...");
		
		this.reel = reel;
		
		this.setLayout(new BoxLayout(this, BoxLayout.Y_AXIS));

		this.iconLabel.setAlignmentX(Component.CENTER_ALIGNMENT);
		
		this.setIconDefault();

		this.messageLabel.setVisible(false);
		this.add(this.messageLabel);
		this.add(this.iconLabel);
	}
	
	public void setIcon(int number){
		ImageIcon icon = new ImageIcon(main.class.getResource("/images/"+ number +".gif")	);
		this.iconLabel.setIcon(icon);
	}
	
	private void setIconDefault(){
		ImageIcon icon = new ImageIcon(main.class.getResource("/images/ini.gif"));
		this.iconLabel.setIcon(icon);		
	}
	
	private void setIconDisabled(){
		ImageIcon icon = new ImageIcon(main.class.getResource("/images/ini_disabled.gif"));
		this.iconLabel.setIcon(icon);		
	}
	
	public Reel getReel(){
		return this.reel;
	}
	
	public String getNombre(){
		return this.reel.getNombre().toUpperCase();
	}

	
	public void onSpinFinishEventOcurred() {
		this.setIcon(this.reel.getCampo());
	}

	
	public void onSpinDefaultEventOcurred() {
		this.setIconDefault();
	}
	
	
	public void setEnabled(boolean b){
		this.iconLabel.setEnabled(b);
		this.messageLabel.setEnabled(b);
	}

}
