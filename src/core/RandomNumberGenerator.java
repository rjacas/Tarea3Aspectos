package core;

import java.util.Random;


/*
 * Representa al generador de numeros aleatorios
 */
public class RandomNumberGenerator {
	
	public static int LIMITE = 9;
	
	/*
	 * realiza el calculo del numero aleatorio.
	 */
	public int getNumberGenerator(){
		Random rand = new Random();
		return rand.nextInt(LIMITE);
	}
}
