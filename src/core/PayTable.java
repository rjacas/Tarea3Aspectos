package core;

/*
 * Representa los distintos criterios para en base a los reels entregados
 * poder pagar o no al jugador.
 */
public class PayTable {
	
	public int cantidadPagada = 0;
	private ICoinHopperEventListener listener;
	
	/*
	 * M�todo que hace el calculo de cuanto pagar al jugador,
	 * considerando el resultado de los reels. Version temporal.
	 */
	public int payout(Reel[] reels){
		
		double outcome = Math.random()*100;
		
		this.cantidadPagada = ((outcome > 50) ? 0 : (int)outcome);		
/*		boolean flag = true;
		if (reels.length == 0)
			return 0;
		int primero = reels[0].getCampo();
		int suma = primero;
		for (int i = 1; i < reels.length; i++) {
			if (reels[i].getCampo() != primero){
				flag = false;
			}
			suma = suma + reels[i].getCampo();
		}
		this.cantidadPagada = flag==true ? (suma*MAXIMO)-reels.length:suma-reels.length;*/
		CoinHopperPayoutEvent e = new CoinHopperPayoutEvent(this); 
		dispatchCoinHopperPayoutEvent(e);
		return this.cantidadPagada;
	}
	
	public ICoinHopperEventListener getListener() {
		return listener;
	}

	public void setListener(ICoinHopperEventListener listener) {
		this.listener = listener;
	}

	/*
	 * accesor
	 */
	public int getCantidadPagada() {
		return cantidadPagada;
	}

	/*
	 * accesor
	 */
	public void setCantidadPagada(int cantidadPagada) {
		this.cantidadPagada = cantidadPagada;
	}

	public void dispatchCoinHopperPayoutEvent(CoinHopperPayoutEvent e) {
		if (this.listener != null)
			this.listener.onCoinHopperPayoutEvent();
	}
}
