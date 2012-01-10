package aspects;
import java.io.*;

public aspect Tracing {
	pointcut aspects(): within(Tracing) || within(Debug) || within(Meters) ||
						within(Persistency) || within(SingletonEnforcer) || within(Demo);
	pointcut myMethod(): !aspects() && (execution(* *(..)) || call(new(..)));
	
	before (): myMethod() {
		String id="";
		for(int i=0;i<ident;i++)
			id=id.concat("  ");
		Tracing.traceEntry(id.concat("" +
				thisJoinPointStaticPart.getSignature()));
		++ident;
	}
	after (): myMethod() {
		--ident;
	}
	
	int ident=0;
	static boolean init=false;
	static public void traceEntry(String in){
		FileWriter fichero = null;
		PrintWriter pw = null;
		try
		{
			if(!init){
				File f = new File("trace.txt");
				f.delete();
			}
			fichero = new FileWriter("trace.txt",true);
			pw = new PrintWriter(fichero);
			pw.println(in);
			if(!init) init =true;

		} 
		catch (Exception e) {
			e.printStackTrace();
		} 
		finally {
			try {
				if (null != fichero)
					fichero.close();
			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}
	}
}
