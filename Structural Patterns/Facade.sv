// 单例模式，线程安全
// systemverilog中所有静态变量的初始化是在time 0之前完成
class Singleton;
  local static Singleton me;
  
  // 利用protected对new函数做保护，不允许外部直接访问
  local function new();
  endfunction : new
  
  static function Singleton get();
    if(me == null) begin
      me = new();
      $display("We made a new one!");
    end
    return me;
  endfunction  
endclass

module top;
   Singleton singleton;

   initial begin
      // 外部不允许通过new()进行创建
      fork
         singleton  = Singleton::get();
         singleton  = Singleton::get();
         singleton  = Singleton::get();
         singleton  = Singleton::get();
         singleton  = Singleton::get();
         singleton  = Singleton::get();
         singleton  = Singleton::get();
         singleton  = Singleton::get();
      join
      #1;
      $finish();
   end

endmodule
