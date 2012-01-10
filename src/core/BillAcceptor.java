package core;

/*
 * clase que representar la maquina recibidora de dinero.
 */
public class BillAcceptor {
	
	private IBillAcceptorEventListener listener;
	public int cantidadAceptada;
	private SlotMachine parent;
	
	public BillAcceptor(SlotMachine parent){
		this.parent = parent;
	}
	
	
	/*
	 * detecta la cantidad ingresada por el jugador y
	 * avisa a sus listeners.
	 */
	public void detect(int cantidad){
		this.cantidadAceptada = cantidad;
		this.parent.setCredits(cantidad);
		BillAcceptorAddCreditsEvent e = new BillAcceptorAddCreditsEvent(this); 
		dispatchBillAcceptorAddCreditsEvent(e);
	}

	private void dispatchBillAcceptorAddCreditsEvent(
			BillAcceptorAddCreditsEvent e) {
		// TODO Auto-generated method stub
		this.listener.onBillAcceptorAddCreditsFinishEventOcurred();
	}

	public IBillAcceptorEventListener getListener() {
		return listener;
	}

	public void setListener(IBillAcceptorEventListener listener) {
		this.listener = listener;
	}

}
