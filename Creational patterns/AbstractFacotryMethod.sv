typedef class Chair;
typedef class Sofa;

typedef class VictorianChair;
typedef class VictorianSofa;
  
typedef class ModernChair;
typedef class ModernSofa;

// === 抽象工厂创建器 ===
// 家具创建虚类
virtual class FurnitureFactory;
  pure virtual function Chair createChair();
  pure virtual function Sofa createSofa();
endclass

// 实际的创建者 - 维多利亚风格家具
class VictorianFurnitureFactory extends FurnitureFactory;
  function Chair createChair();
    VictorianChair mobj = new();
    return mobj;
  endfunction
  
  function Sofa createSofa();
    VictorianSofa mobj = new();
    return mobj;
  endfunction
endclass
    
// 实际的创建者 - 现代风格家具
class ModernFurnitureFactory extends FurnitureFactory;
  function Chair createChair();
    ModernChair mobj = new();
    return mobj;
  endfunction
  
  function Sofa createSofa();
    ModernSofa mobj = new();
    return mobj;
  endfunction
endclass 

// === 椅子 ===
// 椅子虚类
virtual class Chair;
  pure virtual function string hasLegs();
  pure virtual function string sitOn();
endclass

// 实际的椅子 - 维多利亚风格椅子
class VictorianChair extends Chair;
  function string hasLegs();
    hasLegs = "^_^ VictorianChair has legs!";
  endfunction
  
  function string sitOn();
    sitOn = "Sit on a `Victorian` style chair!";
  endfunction
endclass
    
// 实际的椅子 - 现代风格椅子
class ModernChair extends Chair;
  function string hasLegs();
    hasLegs = "-_- ModernChair has no legs!";
  endfunction
  
  function string sitOn();
    sitOn = "Sit on a `Modern` style chair!";
  endfunction
endclass

// === 沙发 ===
// 沙发虚类
virtual class Sofa;
  pure virtual function string hasLegs(); // 可以有自己的特定方法
endclass

// 实际的沙发 - 维多利亚风格沙发
class VictorianSofa extends Sofa;
  function string hasLegs();
    hasLegs = "^_^ VictorianSofa has legs!";
  endfunction
endclass
    
// 实际的沙发 - 现代风格沙发
class ModernSofa extends Sofa;
  function string hasLegs();
    hasLegs = "-_- ModernSofa has no legs!";
  endfunction
endclass
    
// 用户侧 - 不感知具体创建的对象
class Client;
  FurnitureFactory factory;
  Chair chair;
  Sofa sofa;
  
  function new(FurnitureFactory factory);
    $display("I am client, not aware of real furniture style");
    this.factory = factory;
    chair = this.factory.createChair();
    sofa = this.factory.createSofa();
    showInfo();
  endfunction 
  
  function void showInfo();
    $display("Actual Chair Legs: %0s", chair.hasLegs() );
    $display("Actual Chair sitOn: %0s", chair.sitOn() );
    $display("Actual Sofa Legs: %0s", sofa.hasLegs() );
  endfunction
endclass
    
module client_code;
  initial begin
    VictorianFurnitureFactory victorian = new();
    ModernFurnitureFactory modern = new();
    Client client;
    client = new(victorian);
    $display("\n---------\n");
    client = new(modern);
  end
endmodule
