package aspects;

public aspect HardwareFailManage {
	
	pointcut aspects(): within(Tracing) || within(Debug) || within(Meters)
						|| within(Persistency) || within(SingletonEnforcer)
						|| within(TamperProof) || within(Recall) || within (HardwareFailManage);
	
	pointcut myMethod(): !aspects() && (execution(* *(..)) || call(new(..)));
	
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