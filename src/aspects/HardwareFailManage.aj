package aspects;

public aspect HardwareFailManage {
	
	pointcut aspects(): within(Tracing) || within(Debug) || within(Meters)
						|| within(Persistency) || within(SingletonEnforcer) || within(Demo)
						|| within(TamperProof) || within(Recall) || within (HardwareFailManage);
	
	pointcut myMethod(): !aspects() && (execution(* *(..)) || call(new(..)));
	
	after() throwing (Exception ex): myMethod(){ 
		TamperProof.enc.open();
	}
	
}