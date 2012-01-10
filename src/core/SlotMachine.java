package core;

import java.awt.Container;
import java.util.Vector;

import javax.swing.JOptionPane;


/*
 * Representa a una maquina traga monedas.
 */
public class SlotMachine {
	
	@SuppressWarnings("unused")
	private static int JUGANDO = 1;
	private static int DETENIDA = 2;
	
	public int credits;
	public int estado;
	private PayTable payTable;
	private BillAcceptor billAcceptor;
	private CoinHopper coinHopper;
	private Reel[] reels;
	
	public SlotMachine(){
		this.credits = 0;
		this.estado = DETENIDA;
		this.payTable = new PayTable();
		this.billAcceptor = new BillAcceptor(this);
		this.coinHopper = new CoinHopper(this);
		this.reels = new Reel[5];
		for (int i = 0; i < this.reels.length; i++) {
			this.reels[i] = new Reel("Reel "+i);
		}
	}
	
	/*
	 * cada vez que el usuario desea jugar, este es el metodo
	 * principal que controla una jugada.
	 */
	public void play(){
		if (this.verificarApuesta()){
			try {
				throw new PlayException("Monto insuficiente");
			} catch (PlayException e) {
				// TODO Auto-generated catch block
				return;
			}
		}
		Vector<Reel> activos = new Vector<Reel>();
		for (Reel reel : this.reels) {
			if (reel.getEstado()==Reel.ACTIVO){
				try {
					reel.spin();
					activos.add(reel);
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}
		Reel[] r = new Reel[activos.size()];
		this.credits = this.credits + this.payTable.payout(activos.toArray(r));
	}

	/*
	 * Accesor
	 */
	public int getCreditos(){
		return this.credits;
	}

	/*
	 * metodo que calcula cuanto creditos el usuario esta invirtiendo
	 * en la jugada.
	 */
	public int getApuesta(){
		int suma = 0;
		for (Reel reel : this.reels) {
			suma = reel.getEstado() == Reel.ACTIVO ? suma + 1 : suma;
		}
		return suma;
	}
	
	/*
	 * metodo que verifica una apuesta valida.
	 */
	public boolean verificarApuesta(){	
		return this.getCreditos() > this.getApuesta() ? false : true; 
	}

	/*
	 * Accesor
	 */
	public Reel getReel(int i){
		return this.reels[i];
	}

	/*
	 * Accesor
	 */	
	public Reel[] getReels(){
		return this.reels;
	}

	public void setListenerBillAcceptorAddCreditsEvent(
			IBillAcceptorEventListener slotMachineUI) {
		// TODO Auto-generated method stub
		this.billAcceptor.setListener(slotMachineUI);
	}

	public BillAcceptor getBillAcceptor() {
		// TODO Auto-generated method stub
		return this.billAcceptor;
	}

	
	/*
	 * metodo que incrementa creditos.
	 */
	public void setCredits(int cantidad) {
		// TODO Auto-generated method stub
		this.credits = this.credits + cantidad;
	}
	

	/*
	 * Accesor
	 */
	public CoinHopper getCoinHopper() {
		// TODO Auto-generated method stub
		return this.coinHopper;
	}

	public PayTable getPayTable() {
		// TODO Auto-generated method stub
		return this.payTable;
	}

	public void reset() {
		// TODO Auto-generated method stub
		this.credits =  0;
		this.estado = DETENIDA;
	}

	/*
	 * metodo que lanza una exception de hardware.
	 */
	public void fail(Container mainContainer) throws HardwareException{
			JOptionPane.showMessageDialog(mainContainer, "Lo sentimos, se ha producido una falla!", "Falla en componente hardware", JOptionPane.ERROR_MESSAGE);
			throw new HardwareException("Falla de hardware");
		}
	
}
