package aspects;

import java.awt.GridLayout;
import java.util.Calendar;

import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.JLabel;

import UI.SlotMachineUI;
import core.BillAcceptor;
import core.PayTable;
import core.Reel;
import core.SlotMachine;

public aspect Meters {
	pointcut aspects(): within(Tracing) || within(Debug) || within(Meters)
					|| within(Persistency) || within(SingletonEnforcer) || within(Demo)
					|| within(TamperProof) || within(Recall) || within (HardwareFailManage);
	
	pointcut init(): call(* SlotMachineUI.getInstance()) && !aspects();
	
	pointcut recover(): call(* SlotMachineUI.recover());
	
	pointcut myplay(): !aspects() && execution(void core.SlotMachine.play());
	
	pointcut win(PayTable pt): !aspects() && target(pt) 
					&& call(int payout(Reel[]));
	
	pointcut redeem1(): !aspects() && 
					call(void UI.SlotMachineUI.retirarCredits());
	
	pointcut redeem2():  !aspects() && 
						call(void UI.SlotMachineUI.resetUI());
	
	pointcut insert(BillAcceptor b): !aspects() && execution(* core.BillAcceptor.detect(int)) 
					&& this(b);
	
	
	public SlotMachineUI smui;
	public SlotMachine sm;
	public static JFrame frame;
	public JPanel meta;
	public JPanel[] p;
	public JLabel[] labels;
	public static JLabel[] values;
	public static int plays,mmoney,wins,lwinc,redeem,lredeemc,insert,linsertc;
	public static Calendar lwind,lredeem,linsert;
	public static String[] f = new String[4];
    
	after(): init(){ 
		if(frame == null)
			frame = newFrame();
		if(sm == null)
			sm = SlotMachineUI.getInstance().slotMachine;
		if(smui == null)
			smui = SlotMachineUI.getInstance();
	}
	
	after(): recover(){ 
		frame = newFrame();
		sm = SlotMachineUI.getInstance().slotMachine;
		smui = SlotMachineUI.getInstance();
		Persistency.recoverMeters();
	}

	after(BillAcceptor b): insert(b){
		linsertc = b.cantidadAceptada;
		insert += linsertc;
		linsert = Calendar.getInstance();
		values[2].setText(""+insert);
		f[0] = (""+linsertc).concat("   ").concat(format(linsert));
		values[4].setText(f[0]);
	}
	
	before(): redeem2(){
		if(!Demo.activated){
			redeem += sm.credits;
			values[3].setText(""+redeem);
			lredeemc = sm.credits;
			lredeem = Calendar.getInstance();
			f[1] =(""+lredeemc).concat("   ").concat(format(lredeem));
			values[5].setText(f[1]);
		}
	}
	
	after() returning: redeem1(){
		if(!Demo.activated){
			redeem += sm.getPayTable().getCantidadPagada();
			values[3].setText(""+redeem);
			lredeemc = sm.getPayTable().getCantidadPagada();
			lredeem = Calendar.getInstance();
			f[1] =(""+lredeemc).concat("   ").concat(format(lredeem));
			values[5].setText(f[1]);
		}
	}		
	
	after() returning: myplay(){
		if(!Demo.activated){
			plays++;
			values[0].setText(""+plays);
			mmoney = sm.credits;
			values[6].setText(""+mmoney);
		}
	}
	
	after(PayTable pt) returning: win(pt){
		if(!Demo.activated){
			 lwind = Calendar.getInstance();
			 String rs = reelsString(smui.getSlotMachine().getReels());
			 lwinc = pt.cantidadPagada;
			 f[3] = (""+lwinc).
					 concat("  ").concat(rs).concat("   ").concat(format(lwind));
			 values[8].setText(f[3]);
			 if(pt.cantidadPagada > 0){
				 wins++;
				 values[1].setText(""+wins);
				 f[2] = (""+lwinc).concat("   ").concat(format(lwind));
				 values[7].setText(f[2]);
			 }
			 lwinc = 0;
		}
	}
	
	public JFrame newFrame(){
		JFrame ret = new JFrame("Meters");
		try {
			meta = new JPanel(new GridLayout(9,1));
			p = new JPanel[9];
			labels = new JLabel[9];
			values = new JLabel[9];
			for(int i=0;i<9;i++){
				p[i] = new JPanel(new GridLayout(1,2));
				meta.add(p[i]);
			}
			labels[0] = new JLabel("Number   of Plays:");//done
			labels[1] = new JLabel("Number   of  Wins:");//done
			labels[2] = new JLabel("Money    Inserted:");//done
			labels[3] = new JLabel("Money    Redeemed:");//done
			labels[4] = new JLabel("Last Money Insert:");//done
			labels[5] = new JLabel("Last Price Redeem:");//done
			labels[6] = new JLabel("Current own Coins:");//done
			labels[7] = new JLabel("Last  Price   Won:");//done
			labels[8] = new JLabel("Las  Game  Played:"); //done
			
			for(int i=0;i<9;i++){
				p[i].add(labels[i]);
				values[i]= new JLabel("0");
				p[i].add(values[i]);
			}		
			
			
			ret.add(meta);
			ret.setSize(600, 450);
		} catch (Exception e) {
			e.printStackTrace();
		}
		ret.setLocationRelativeTo(null);
		ret.setVisible(true);
		return ret;
	}
	
	
	public static String format(Calendar a){
		String year = ""+ a.get(Calendar.YEAR);
		String month = ""+ a.get(Calendar.MONTH);
		String day = ""+ a.get(Calendar.DAY_OF_MONTH);
		String hour = ""+ a.get(Calendar.HOUR_OF_DAY);
		int min = a.get(Calendar.MINUTE);
		String minutes;
		if(min < 10)
			minutes = "0".concat(""+ min);
		else
			minutes = ""+ min;
		int sec = a.get(Calendar.SECOND);
		String seconds;
		if(sec < 10)
			seconds = "0".concat(""+ sec);
		else
			seconds = ""+ sec;		
		String answer1 = day.concat("/").concat(month).concat("/").concat(year);
		String answer2 = hour.concat(":").concat(minutes).concat(":").concat(seconds);
		return answer1.concat("  ").concat(answer2);
	}
	public static String reelsString(Reel[] r){
		String beg ="reels:";
		for(int i=0;i < r.length;i++){
			if(i != r.length-1)
				beg = beg.concat(""+r[i].getCampo()).concat("-");
			else
				beg = beg.concat(""+r[i].getCampo());
		}
		return beg;
	}
	
	public static void close(){
		frame.dispose();
	}
	
}
