package aspects;

import java.awt.BorderLayout;
import javax.swing.*;
import java.io.*;

public aspect Debug {
	pointcut aspects(): within(Tracing) || within(Debug) || within(Meters)
					|| within(Persistency) || within(SingletonEnforcer) 
					|| within(TamperProof) || within(Recall) || within (HardwareFailManage);
	pointcut myMethod(): !aspects() && (execution(* *(..)) || call(new(..)));
	
	after() throwing(Exception e):myMethod(){ 
		if(frame == null)
			frame= newFrame();
		StringWriter est = new StringWriter();
		PrintWriter st = new PrintWriter(est);
		e.printStackTrace(st);
		printFrame(est.toString());
	}
	
	public JFrame frame;
	static public JTextArea area;
	
	static public JFrame newFrame(){
		JFrame ret = new JFrame("Debug");
		JScrollPane jScrollPane;
		try {			
			jScrollPane = new JScrollPane();
			ret.getContentPane().add(jScrollPane, BorderLayout.CENTER);				
			area = new JTextArea();
			jScrollPane.setViewportView(area);			
			ret.setSize(400, 300);
		} catch (Exception e) {
			e.printStackTrace();
		}
		ret.setLocationRelativeTo(null);
		ret.setVisible(true);
		return ret;
	}
	
	static public void printFrame(String in){
		area.setText(in);
		area.setEditable(false);		
	}
}
