package core;


import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;

import aspects.Recall;

import UI.SlotMachineUI;


public class NVRAM2 {
	private byte bytes[];
	
	public void save() throws IOException{
		ByteArrayOutputStream bs= new ByteArrayOutputStream();
		ObjectOutputStream os = new ObjectOutputStream (bs);
		os.writeObject(SlotMachineUI.getInstance()); 
		os.close();
		bytes =  bs.toByteArray();
	}
	
	
	public void recover() throws IOException, ClassNotFoundException{
		if(bytes != null){
			SlotMachineUI.getInstance().mainFrame.setVisible(false);
			ByteArrayInputStream bs= new ByteArrayInputStream(bytes); 
			ObjectInputStream is = new ObjectInputStream(bs);
			SlotMachineUI.setSlotMachineUI((SlotMachineUI)is.readObject());
			is.close();
			SlotMachineUI.getInstance().mainFrame.setVisible(true);
		}
	}
	

}
