package UI;
import java.awt.FlowLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.BorderFactory;
import javax.swing.JButton;
import javax.swing.JPanel;
import javax.swing.JTextField;

import core.BillAcceptor;
import core.IBillAcceptorEventListener;

/*
 * Representa al panel de la maquina que recibe el dinero.
 */
@SuppressWarnings("serial")
public class BillAcceptorPanel extends JPanel{
	
	private JButton addButton;
	private JTextField billsTextField;
	
	private BillAcceptor billAcceptor;
	
	public BillAcceptorPanel(BillAcceptor billAccepter){
		this.billAcceptor = billAccepter;
		this.addButton = new JButton("add");
		this.billsTextField = new JTextField(10);
		
		this.setLayout(new FlowLayout());
		this.add(this.billsTextField);
		this.add(this.addButton);
		
		this.setBorder(BorderFactory.createTitledBorder("Bill Acceptor"));
				
		this.addButton.addActionListener(new ActionListener(){
			public void actionPerformed(ActionEvent e){
				try{
					getBillAcceptor().detect(Integer.parseInt(billsTextField.getText()));
					billsTextField.setText("");
				}
				catch(Exception ex){};
			}
		});
	}
	
	/*
	 * Accesor
	 */
	public BillAcceptor getBillAcceptor() throws Exception{
		return this.billAcceptor;
	}

	/*
	 * deja el foco en la caja de texto del dinero.
	 */
	public void grabFocus(){
		this.billsTextField.grabFocus();		
	}

}
