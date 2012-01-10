package aspects;

public aspect TamperProof {
	pointcut aspects(): within(Tracing) || within(Debug) || within(Meters)
					|| within(Persistency) || within(SingletonEnforcer) || within(Demo)
					|| within(TamperProof) || within(Recall) || within (HardwareFailManage);
}
