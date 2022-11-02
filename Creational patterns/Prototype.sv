// 通用形状接口
virtual class Shape;
  int x;
  int y;
  string color;
    
  pure virtual function Shape clone();
    
    function new(Shape target = null);
    if(target != null) begin
    	x = target.x;
        y = target.y;
        color = target.color;
    end
  endfunction
  
  // 后期被override
  function bit equals(Shape rhs);
    Shape rhs_;
    bit status = 1;
    if(!$cast(rhs_, rhs)) return 0;
    status &= (x == rhs_.x);
    status &= (y == rhs_.y);
    return status;
  endfunction
endclass

// 圆形
class Circle extends Shape;
  int radius;
  
  function new(Circle target = null);
    if(target != null) begin
        radius = target.radius;
    end
  endfunction
   
  function Shape clone();
    Shape h = new this;
    return h;
  endfunction
  
  function bit equals(Shape rhs);
    Circle rhs_;
    bit status = 1;
    if(!$cast(rhs_, rhs)) return 0;
    status &= super.equals(rhs);
    status &= (radius == rhs_.radius);
    return status;
  endfunction
endclass
    
// 矩形
class Rectangle extends Shape;
  int width;
  int height;
  
  function new(Rectangle target = null);
    if(target != null) begin
        width = target.width;
      	height = target.height;
    end
  endfunction
   
  function Shape clone();
    Shape h = new this;
    return h;
  endfunction
  
  function bit equals(Shape rhs);
    Rectangle rhs_;
    bit status = 1;
    if(!$cast(rhs_, rhs)) return 0;
    status &= super.equals(rhs);
    status &= (width == rhs_.width);
    status &= (height == rhs_.height);
    return status;
  endfunction
endclass
    
module Application;
  initial begin
    Shape shapes[$], shapesCopy[$];
    
    Circle circle = new();
    circle.x = 10;
    circle.y = 10;
    circle.color = "Red Circle";
    circle.radius = 20;
    shapes.push_back(circle);
    
    begin
      Circle anotherCircle;
      $cast(anotherCircle, circle.clone());
      shapes.push_back(anotherCircle);
    end
    
    begin
      Rectangle rectangle = new();
      rectangle.width = 10;
      rectangle.height = 20;
      shapes.push_back(rectangle);
    end
    
    cloneAndCompare(shapes, shapesCopy);
    
    // 故意改变第2个类的内容，让其比较不上
    $display("\n=== We intend to make one object is different. To see if works!=== ");
    shapesCopy[2].x = 1000;
    comparer(2, shapes[2], shapesCopy[2]);
  end
  
  
  function void cloneAndCompare(ref Shape shapes[$], Shape shapesCopy[$]);
    foreach(shapes[i]) begin
      shapesCopy.push_back(shapes[i].clone());
    end
    
    foreach(shapes[i]) begin
      comparer(i, shapes[i], shapesCopy[i]);
    end
  endfunction
  
  function comparer(int idx, ref Shape shape, Shape shapeCopy);
    if(shape != shapeCopy) begin
        $display("%0d: Shape objects are different objects!", idx);
        if(shape.equals(shapeCopy)) begin
          $display("%0d: And they are identical", idx);
        end else begin
          $display("%0d: But they are not identical", idx);
        end
    end else begin
        $display("%0d: Shape objects are the same.", idx);
    end
  endfunction
endmodule
