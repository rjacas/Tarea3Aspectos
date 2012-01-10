package core;

import java.awt.GridBagLayout;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;

import UI.main;

public class Enclosure {
	private JFrame f;
	private String state;
	private JPanel meta, light, button;
	private JLabel bulb;
	private JButton init,box;
	private JComboBox values;
	
	public Enclosure(){
		this.f = newFrame();
		this.state = "";
	}
	
	public void open(){}//no hace nada
	public void trigger(){}//sólo para ser llamada
	
	public JFrame newFrame(){
		JFrame ret = new JFrame("Enclosure");
		try {
			this.meta = new JPanel(new GridLayout(2,1));
			this.light = new JPanel(new GridBagLayout());
			this.button = new JPanel(new GridBagLayout());
			this.init = new JButton("Inicial");
			this.box = new JButton((new ImageIcon(main.class.getResource("/images/caja.png"))));
			this.bulb = new JLabel((new ImageIcon(main.class.getResource("/images/light-off.png"))));
			this.values = new JComboBox();
			this.values.addItem("Todo bien");
			this.values.addItem("Payback");
			ret.add(this.meta);
			ret.add(this.box);
			this.meta.setVisible(false);
			this.meta.add(this.light);
			this.meta.add(this.button);
			this.light.add(this.bulb);
			this.button.add(this.init);
			this.button.add(this.values);
			this.box.addActionListener(new ActionListener() {
				public void actionPerformed(ActionEvent e){
					box.setVisible(false);
					meta.setVisible(true);
					meta.updateUI();
			}});
			this.init.addActionListener(new ActionListener() {
				public void actionPerformed(ActionEvent e){
					if(values.getSelectedItem().equals("Todo bien")){
						state = "Todo bien";
						trigger();
					}
					if(values.getSelectedItem().equals("Payback")){
						state = "Payback";
						trigger();
					}
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
