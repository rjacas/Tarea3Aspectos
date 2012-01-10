package core;


/*
 * Representa a un reel perteneciente a la slot machine.
 */
public class Reel {

	public static int ACTIVO = 1;
	public static int BLOQUEADO = 2;
	public static int GIRANDO = 3;
	
	public String nombre;
	public int campo;
	private int estado;
	public RandomNumberGenerator numberGenerator;
	public ISpinEventListener listener;
	
	public Reel(String nombre, int valor){
		this.nombre = nombre;
		this.campo = valor;
		this.estado = ACTIVO;
		this.numberGenerator = new RandomNumberGenerator();
	}
	
	public Reel(String nombre){
		this.nombre = nombre;
		this.campo = -1;
		this.estado = ACTIVO;
		this.numberGenerator = new RandomNumberGenerator();		
	}
	
	/*
	 * Accesor
	 */
	public void setDefault(){
		this.campo = -1;
		this.estado = ACTIVO;
	}

	/*
	 * Accesor
	 */
	public void setEstadoActivar(){
		this.estado = ACTIVO;
	}

	/*
	 * Accesor
	 */	
	public void setEstadoBloquear(){
		this.estado = BLOQUEADO;
	}
	
	/*
	 * Accesor
	 */
	public void setEstadoGirar(){
		this.estado = GIRANDO;
	}
	
	/*
	 * Accesor
	 */	
	public int getEstado(){
		return this.estado;
	}
	
	/*
	 * Accesor
	 */
	public int getCampo(){
		return this.campo;
	}
	
	/*
	 * hace girar al reel para saber que numero obtendr�. Este m�todo
	 * lo invoca slot machine.
	 */
	public void spin() throws Exception{
		if (this.getEstado() == BLOQUEADO)
			throw new Exception("Reel is blocked"); 
		this.setEstadoGirar();
		this.campo = this.numberGenerator.getNumberGenerator();
		this.setEstadoActivar();
		SpinFinishEvent e = new SpinFinishEvent(this); 
		dispatchSpinFinishEvent(e);
	}
		
	public void dispatchSpinFinishEvent(SpinFinishEvent e) {
		if (this.listener != null)
			this.listener.onSpinFinishEventOcurred();
	}
	
	public void dispatchSpinDefaultEvent(SpinDefaultEvent e){
		if (this.listener != null)
			this.listener.onSpinDefaultEventOcurred();
	}
	
	public void setSpinFinishEvent(ISpinEventListener listener) {
		this.listener = listener;
	}

	/*
	 * Accesor
	 */
	public String getNombre(){
		return this.nombre;
	}
	
}
