typedef enum {TRUE, FALSE} Boole;
typedef class Car;
typedef class Manual;

// 创建虚类 -- getProduct不在模板类声明，因为不清楚具体的类型
virtual class Builder;
  pure virtual function void reset();
  pure virtual function void setSeats(int Num);
  pure virtual function void setEngine(string EngineType);
  pure virtual function void setTripComputer(Boole isHave);
  pure virtual function void setGPS(Boole isHave);
endclass

// 实际的创建者 - 车创建者
class CarBuilder extends Builder;
  protected Car mCar;
  
  function new();
    this.reset();
  endfunction
  
  function void reset();
    mCar = new();
  endfunction
  
  function void setSeats(int Num);
    mCar.add($sformatf("Seats Num - %0d", Num) );
  endfunction
                 
  function void setEngine(string EngineType);
    mCar.add($sformatf("Engine Type - %0s", EngineType) );
  endfunction
                 
  function void setTripComputer(Boole isHave);
    mCar.add($sformatf("Has TripComputer - %0s", isHave.name()) );
  endfunction

  function void setGPS(Boole isHave);
    mCar.add($sformatf("Has GPS - %0s",  isHave.name()) );
  endfunction   

  // 具体生成器需要自行提供获取结果的方法。这是因为不同类型的生成器可能
  // 会创建不遵循相同接口的、完全不同的产品。所以也就无法在生成器接口中
  // 声明这些方法（至少在静态类型的编程语言中是这样的）。
  //
  // 通常在生成器实例将结果返回给客户端后，它们应该做好生成另一个产品的
  // 准备。因此生成器实例通常会在 `getProduct（获取产品）`方法主体末尾
  // 调用重置方法。但是该行为并不是必需的，你也可让生成器等待客户端明确
  // 调用重置方法后再去处理之前的结果。
  function Car getProduct();
    Car car;
    car = mCar;
    this.reset();
    return car;
  endfunction  
endclass
    
// 实际的创建者 - 用户手册创建者
class ManualBuilder extends Builder;
  protected Manual mManual;
  
  function new();
    this.reset();
  endfunction
  
  function void reset();
    mManual = new();
  endfunction
  
  function void setSeats(int Num);
    mManual.add($sformatf("Manual Seats Num - %0d", Num) );
  endfunction
                 
  function void setEngine(string EngineType);
    mManual.add($sformatf("Manual Engine Type - %0s", EngineType) );
  endfunction
                 
  function void setTripComputer(Boole isHave);
    mManual.add($sformatf("Manual Has TripComputer - %0s", isHave.name()) );
  endfunction

  function void setGPS(Boole isHave);
    mManual.add($sformatf("Manual Has GPS - %0s", isHave.name()) );
  endfunction
  
  function Manual getProduct();
    Manual manual;
    manual = mManual;
    this.reset();
    return manual;
  endfunction 
endclass

// 车
class Car;
  string mCarInfo[$];
  
  function new();
    mCarInfo = {};
  endfunction
  
  function void add(string Info);
    mCarInfo.push_back(Info);
  endfunction
 
  function void listParts();
    $write("Car parts: ");
    foreach(mCarInfo[i]) begin
      if(i != mCarInfo.size() - 1) begin
      	$write("%0s, ", mCarInfo[i]);
      end else begin
        $write("%0s", mCarInfo[i]);
      end
    end
    $write("\n");
  endfunction
endclass

// 用户手册
class Manual;
  string mManualInfo[$];
  
  function new();
    mManualInfo = {};
  endfunction
  
  function void add(string Info);
    mManualInfo.push_back(Info);
  endfunction
 
  function void listParts();
    $write("Car parts: ");
    foreach(mManualInfo[i]) begin
      if(i != mManualInfo.size() - 1) begin
      	$write("%0s, ", mManualInfo[i]);
      end else begin
        $write("%0s", mManualInfo[i]);
      end
    end
    $write("\n");
  endfunction
endclass
                    
// 主管类
class Director;

  function void constructSportsCar(Builder builder);
    builder.reset();
    builder.setSeats(2);
    builder.setEngine("Sports");
    builder.setTripComputer(TRUE);
    builder.setGPS(TRUE);
  endfunction

  function void constructSUVCar(Builder builder);
    builder.reset();
    builder.setSeats(4);
    builder.setEngine("SUV");
    builder.setTripComputer(FALSE);
    builder.setGPS(TRUE);
  endfunction
    
endclass
                    
module Application;
  initial begin
	// 利用主管类创建车和用户手册
    Director director = new();
    Car car;
    Manual manual;
    
    // 车
    begin
    CarBuilder builder = new();
      $display("\n=== We are using director to create cars! ===");
    director.constructSportsCar(builder);
    car = builder.getProduct();
    car.listParts();
    end
    
    // 用户手册
    begin
    ManualBuilder builder = new();
    $display("\n=== We are using director to create manuals! ===");
    director.constructSUVCar(builder);
    manual = builder.getProduct();
    manual.listParts();
    end

    // 用户自定义创造
    begin
    CarBuilder builder = new();
    $display("\n=== Customer self create cars! ===");
    builder.setSeats(6);
    builder.setEngine("Cheap_MPV");
    car = builder.getProduct();
    car.listParts();
    end
  end
endmodule
