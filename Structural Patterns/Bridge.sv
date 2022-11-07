typedef enum {Disabled, Enabled} mBoole;

// 所有设备的通用接口
interface class Device;
  pure virtual function mBoole isEnabled();
  pure virtual function void toEnable();
  pure virtual function void toDisable(); // disable是sv的关键词，需要更换
  pure virtual function int getVolume();
  pure virtual function void setVolume(int volume);
  pure virtual function int getChannel();
  pure virtual function void setChannel(int channel);
  pure virtual function void printStatus();
endclass

// 收音机
class Radio implements Device;
  protected mBoole on = Disabled;
  protected int volume = 30;
  protected int channel = 1;
  
  virtual function mBoole isEnabled();
    return on;
  endfunction
  
  virtual function void toEnable();
  	on = Enabled;
  endfunction
  
  virtual function void toDisable();
  	on = Disabled;
  endfunction
  
  virtual function int getVolume();
  	return volume;
  endfunction
  
  virtual function void setVolume(int volume);
    if(volume > 100) begin
    	this.volume = 100;
    end else if(volume < 0) begin
    	this.volume = 0;    
    end else begin
        this.volume = volume;
    end
  endfunction
  
  virtual function int getChannel();
    return channel;
  endfunction
  
  virtual function void setChannel(int channel);
  	this.channel = channel;
  endfunction
  
  virtual function void printStatus();
  	$display("------------------------------------");
    $display("| I'm radio.");
    $display("| I'm %0s", on.name());
    $display("| Current volume is %0d%%", volume);
    $display("| Current channel is %0d", channel);
    $display("------------------------------------\n");
  endfunction
endclass
    
// 电视
class TV implements Device;
  protected mBoole on = Disabled;
  protected int volume = 30;
  protected int channel = 1;
  
  virtual function mBoole isEnabled();
    return on;
  endfunction
  
  virtual function void toEnable();
  	on = Enabled;
  endfunction
  
  virtual function void toDisable();
  	on = Disabled;
  endfunction
  
  virtual function int getVolume();
  	return volume;
  endfunction
  
  virtual function void setVolume(int volume);
    if(volume > 100) begin
    	this.volume = 100;
    end else if(volume < 0) begin
    	this.volume = 0;    
    end else begin
        this.volume = volume;
    end
  endfunction
  
  virtual function int getChannel();
    return channel;
  endfunction
  
  virtual function void setChannel(int channel);
  	this.channel = channel;
  endfunction
  
  virtual function void printStatus();
  	$display("------------------------------------");
    $display("| I'm TV set.");
    $display("| I'm %0s", on.name());
    $display("| Current volume is %0d%%", volume);
    $display("| Current channel is %0d", channel);
    $display("------------------------------------\n");
  endfunction
endclass

// 远程控制器的通用接口
interface class Remote;
  pure virtual function void power();
  pure virtual function void volumeDown();
  pure virtual function void volumeUp();
  pure virtual function void channelDown();
  pure virtual function void channelUp();
endclass

// 基础远程控制器
class BasicRemote implements Remote;
  protected Device device;
  
  function new(Device device);
  	this.device = device;
  endfunction
  
  virtual function void power();
    $display("Remote: pwer toggle");
    if(device.isEnabled())begin
      device.toDisable();  
    end else begin
      device.toEnable();
    end
  endfunction
  
  virtual function void volumeDown();
    $display("Remote: volume down");
    device.setVolume(device.getVolume() - 10); 
  endfunction
  
  virtual function void volumeUp();
    $display("Remote: volume up");
    device.setVolume(device.getVolume() + 10); 
  endfunction
  
  virtual function void channelDown();
    $display("Remote: channel down");
    device.setChannel(device.getChannel() - 1); 
  endfunction
  
  virtual function void channelUp();
    $display("Remote: channel up");
    device.setChannel(device.getChannel() + 1); 
  endfunction
endclass
    
// 高级远程控制器
class AdvancedRemote extends BasicRemote;
  
  function new(Device device);
    super.new(device);
  endfunction
  
  virtual function void mute();
    $display("Remote: mute");
    device.setVolume(0);
  endfunction
endclass
    
module Test;
  initial begin
    TV tv;
    Radio radio;
    tv = new();
    testDevice(tv);
    
    radio = new();
    testDevice(radio);
  end
  
  function void testDevice(Device device);
    BasicRemote basicRemote;
    AdvancedRemote advancedRemote;
    
    $display("Test with basic remote.");
    basicRemote = new(device);
    basicRemote.power();
    device.printStatus();
    
    $display("Test with advanced remote.");
    advancedRemote = new(device);
    advancedRemote.power();
    advancedRemote.mute();
    device.printStatus();
  endfunction
endmodule
