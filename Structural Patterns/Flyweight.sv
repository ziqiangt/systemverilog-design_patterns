typedef class TreeType;
typedef enum {GREEN, ORANGE} Colore;
// 包含每棵树的独特状态
class Tree;
  protected int x;
  protected int y;
  protected TreeType mtype;
  
  function new(int x, int y, TreeType mtype);
    this.x = x;
    this.y = y;
    this.mtype = mtype;
  endfunction
endclass

// 包含多棵树共享的状态
class TreeType;
  protected string name;
  protected Colore color;
  protected string otherTreeData;
  
  function new(string name, Colore color, string otherTreeData);
    this.name = name;
    this.color = color;
    this.otherTreeData = otherTreeData;
  endfunction
endclass

// 封装创建享元的复杂机制
class TreeFactory;
  static TreeType treeTypes[string];
  
  static function TreeType getTreeType(string name, Colore color, string otherTreeData);
    TreeType result = treeTypes[name];
    if(result == null) begin
      result = new(name, color, otherTreeData);
      treeTypes[name] = result;
    end
    return result;
  endfunction
endclass

// 森林
class Forest;
  protected Tree trees[$];
  
  function void plantTree(int x, int y, string name, Colore color, string otherTreeData);
    TreeType mtype = TreeFactory::getTreeType(name, color, otherTreeData);
    Tree tree = new(x, y, mtype);
    trees.push_back(tree);
  endfunction
endclass
  
module test;
  static int CANVAS_SIZE = 500;
  static int TREES_TO_DRAW = 1000000;
  static int TREE_TYPES = 2;
  
  initial begin
    Forest forest = new();
    for (int i = 0; i < $floor(TREES_TO_DRAW / TREE_TYPES); i++)begin
      forest.plantTree($urandom_range(0, CANVAS_SIZE),
                       $urandom_range(0, CANVAS_SIZE),        
             		   "Summer Oak", GREEN, "Oak texture stub");
      forest.plantTree($urandom_range(0, CANVAS_SIZE),
                       $urandom_range(0, CANVAS_SIZE),
             		   "Autumn Oak", ORANGE, "Autumn Oak texture stub");
    end
    
    $display( "%0d trees drawn", TREES_TO_DRAW);
    $display("---------------------");
    $display("Memory usage:");
    $display("Tree size (8 bytes) * %0d", TREES_TO_DRAW);
    $display("+ TreeTypes size (~30 bytes) * %0d", TREE_TYPES);
    $display("---------------------");
    $display("Total: %0dMB (instead of %0dMB)", 
             ((TREES_TO_DRAW * 8 + TREE_TYPES * 30) / 1024 / 1024),
             ((TREES_TO_DRAW * 38) / 1024 / 1024));
  end
endmodule
