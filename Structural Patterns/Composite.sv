virtual class Component;
  Component parent;
  string name;
  
  function new(string name);
    this.name = name;
  endfunction
  
  virtual function void add(Component component);
  endfunction
  
  virtual function void remove(Component component);
  endfunction
  
  virtual function bit is_composite();
    return 0;
  endfunction
  
  //operation must be realized by extends class
  pure virtual function string build();
endclass
    
class Leaf extends Component;
  function new(string name);
    super.new(name);
  endfunction
  
  function string build();
    return name;
  endfunction
endclass
    
class Composite extends Component;
  Component children[$];
  
  function new(string name);
    super.new(name);
    children = {};
  endfunction
  
  function void add(Component component);
    children.push_back(component);
    component.parent = this;
  endfunction
  
 
  function void remove(Component component);
    foreach(children[i]) begin
      if(children[i] == component) begin
        children.delete(i);
        break;
      end
    end
    component.parent = null;
  endfunction
  
  function bit is_composite();
    return 1;
  endfunction
  
  function string build();
    string hireachy;
    foreach(children[i]) begin
      if(i == 0) begin
        hireachy = {name, "(", children[i].build()};
      end else begin
        hireachy = {hireachy, "+", children[i].build()};
      end
    end
    
    return {hireachy, ")"};
  endfunction
endclass

module clients;
  function void client_code(Component component);
    $display("RESULT: %0s", component.build());
  endfunction
  
  function void client_code2(Component component1, Component component2);
    if (component1.is_composite()) begin
      component1.add(component2);
    end
    $display("RESULT: %0s", component1.build());
  endfunction
  
  initial begin
    Leaf uvm_agt;
    uvm_agt = new("uvm_agent0");
    
    $display("Client: I've got simple component");
    client_code(uvm_agt);
    
    begin
      Composite tree, branch1, branch2;
      Leaf each_comp;
      branch1 = new("uvm_agent1");
      each_comp = new("uvm_monitor");
      branch1.add(each_comp);
      
      branch2 = new("uvm_agent2");
      each_comp = new("uvm_driver");
      branch2.add(each_comp);
      each_comp = new("uvm_monitor");
      branch2.add(each_comp);
      
      tree = new("tree_top");
      tree.add(branch1);
      tree.add(branch2);
      
      $display("Client: Now I've got a composite tree:");
      client_code(tree);
      $display("Client: I don't need to check the components classes even when managing the tree:");
      client_code2(tree, uvm_agt);
      
      $display("Client: Now I've remove a leaf:");
      tree.remove(uvm_agt);
      client_code(tree);
      
      $display("Client: Now I've remove a branch:");
      tree.remove(branch2);
      client_code(tree);
    end
  end
endmodule
