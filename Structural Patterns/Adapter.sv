typedef class RoundPeg;

// 圆孔
class RoundHole;
  protected real radius;
  
  function new(real radius);
    this.radius = radius;
  endfunction
  
  function real getRadius();
    return this.radius;
  endfunction
  
  function bit fits(RoundPeg peg);
    return this.getRadius() >= peg.getRadius();
  endfunction
endclass

// 圆钉
class RoundPeg;
  protected real radius;
  
  function new(real radius);
    this.radius = radius;
  endfunction
  
  // virtual是为了多态   
  virtual function real getRadius();
    return this.radius;
  endfunction
endclass

// 不适配的方钉
class SquarePeg;
  protected real width;
  
  function new(real width);
    this.width = width;
  endfunction
  
  function real getWidth();
    return this.width;
  endfunction
endclass

// 适配器
class SquarePegAdapter extends RoundPeg;
  protected SquarePeg peg;
  
  function new(SquarePeg peg);
    super.new(0); // systemverilog语法限制。必须在一开始显示调用有形式参数的super.new(parameter).
    this.peg = peg;
    super.radius = this.getRadius(); // 该步骤可选，因为我们实际不用父类的这个变量
  endfunction
  
  function real getRadius();
    return this.peg.getWidth() * $sqrt(2) / 2;
  endfunction
endclass
  
module Test;
  initial begin
    // 客户端代码中的某个位置。
    RoundHole hole = new(5);
    RoundPeg  rpeg = new(5);
    $display("Is fit hole = %0d", hole.fits(rpeg) ); // true
	
    begin
    SquarePeg small_sqpeg = new(5);
    SquarePeg large_sqpeg = new(10);
	// hole.fits(small_sqpeg) // 此处无法编译（类型不一致）。

    SquarePegAdapter small_sqpeg_adapter = new(small_sqpeg);
    SquarePegAdapter large_sqpeg_adapter = new(large_sqpeg);
    $display("Is fit small sqprg hole = %0d", hole.fits(small_sqpeg_adapter) ); // true
    $display("Is fit large sqprg hole = %0d", hole.fits(large_sqpeg_adapter) ); // false
    end
  end
endmodule
