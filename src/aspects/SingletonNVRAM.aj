package aspects;
import core.NVRAM;

public aspect SingletonNVRAM extends SingletonEnforcer{
	pointcut callMe(): call(core.NVRAM.new(..))&& !(within(SingletonNVRAM) || within(core.NVRAM));
	
	public static NVRAM NVRAM.myInstance;
	
	public static NVRAM NVRAM.getInstance() {		
		if(NVRAM.myInstance == null){
			NVRAM.myInstance = new NVRAM();
		}
		return NVRAM.myInstance;
	}
	
	
}
