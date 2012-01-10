package core;

/*
 * Representa a la maquina que entrega las monedas cuando el usuario
 * decide sacar sus creditos.
 */
public class CoinHopper {
	
	private SlotMachine parent;
	
	public CoinHopper(SlotMachine parent) {
		// TODO Auto-generated constructor stub
		this.parent = parent;
	}

	/*
	 * Abre la pesta–a para que puedan caer las monedas.
	 */
	public void payout(int creditos){
		//TODO: debiera avisar a todos mis listeners para que pagen!
		System.out.println("Pagando..." + creditos);
	}

}
