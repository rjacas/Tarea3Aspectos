package aspects;

public aspect HardwareFailManage {
	
	pointcut aspects(): within(Tracing) || within(Meters)
						|| within(Persistency) || within(SingletonEnforcer)
						|| within(TamperProof) || within(Recall) || within (HardwareFailManage);
	
	pointcut myMethod(): !aspects() && (call(* *(..)) || execution(* *(..)) || call(new(..)));
	
	Object around(): myMethod(){
		try{
			return proceed();
		}
		catch(Exception e){
			TamperProof.enc.box.doClick();
		}
		return proceed();
	}
	
}