typedef class Tranport;
typedef class Truck;
typedef class Ship;
 
// 物流创建虚类
virtual class Logistics;
  pure virtual function Tranport createTransport();
  
  virtual function void Plandelivery();
    Tranport mtrp;
    mtrp = createTransport();
    $display("Logistics: same create code. Work with %0s", mtrp.deliver());
  endfunction
endclass

// 运输器产品虚类
virtual class Tranport;
  pure virtual function string deliver();
endclass

// 实际的创建者 - 道路物流
class RoadLogistics extends Logistics;
  function Tranport createTransport();
    Truck mobj = new();
    return mobj;
  endfunction
endclass
    
// 实际的创建者 - 海上物流
class ShipLogistics extends Logistics;
  function Tranport createTransport();
    Ship mobj = new();
    return mobj;
  endfunction
endclass

// 实际的运输器 - 卡车
class Truck extends Tranport;
  function string deliver();
    deliver = "Road delivery";
  endfunction
endclass
    
// 实际的运输器 - 轮船
class Ship extends Tranport;
  function string deliver();
    deliver = "Water delivery";
  endfunction
endclass
    
// 用户侧 - 不感知具体创建的对象
class Client;
  Logistics logistics;
  
  function new(Logistics logistics);
    $display("I am client, not aware of real transport");
    logistics.Plandelivery();
  endfunction 
endclass
    
module client_code;
  initial begin
    RoadLogistics truck = new();
    ShipLogistics ship = new();
    Client client;
    client = new(truck);
    client = new(ship);
  end
endmodule
