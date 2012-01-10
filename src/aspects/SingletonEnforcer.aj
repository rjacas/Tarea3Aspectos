package aspects;

class SingletonException extends Exception {
	private static final long serialVersionUID = 1L; }

public abstract aspect SingletonEnforcer {
	
	abstract pointcut callMe();

	pointcut aspects(): within(Tracing) || within(Debug) || within(Meters)
						|| within(Persistency) || within(SingletonEnforcer) || within(Demo)
						|| within(TamperProof) || within(Recall) || within (HardwareFailManage);
	
	declare error: callMe()
	:"Cannot call new, The Object is a Singleton";
	
	/*
	 * this become necessary because there might be some dynamic calls,
	 * uncaptured here, that eventually lead to an/a execution/call of new(),
	 * such as newInstance(), which is defined at class, and since its defined
	 * dynamically, the pointcut doesn't match until execution of the program. 
	 */
	declare soft : SingletonException : callMe();
	
	public interface Singleton {
		public Object returnInstance();
	};
	
	declare parents : (core.NVRAM && UI.SlotMachineUI) implements Singleton;

}
