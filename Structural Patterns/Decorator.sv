// 读取和写入操作的通用数据接口
interface class DataSource;
  pure virtual function void writeData(string data);
  pure virtual function string readData();
endclass

// 单行简单数据读写器
class FileDataSource implements DataSource;
  string name;
  
  function new(string name);
    this.name = name;
  endfunction
  
  virtual function void writeData(string data);
    int fd;
    fd = $fopen(name, "w");
    if(fd) begin
      $fdisplay (fd, data);
    end else begin
      $display("IOException");
    end
    $fclose(fd);
  endfunction
  
  virtual function string readData();
    int fd;
    string line;
    fd = $fopen(name, "r");
    if(fd) begin
      while(!$feof(fd)) begin
        $fgets(line, fd);
        readData = {readData, line};
      end
    end else begin
      $display("IOException");
    end
    $fclose(fd);
  endfunction
endclass
    
// 抽象基础装饰
class DataSourceDecorator implements DataSource;
  local DataSource wrappee;
  
  function new(DataSource wrappee);
    this.wrappee = wrappee;
  endfunction
 
  virtual function void writeData(string data);
        wrappee.writeData(data);
  endfunction

  virtual function string readData();
        return wrappee.readData();
  endfunction
endclass
    
// 加密装饰
class EncryptionDecorator extends DataSourceDecorator;
  
  function new(DataSource wrappee);
    super.new(wrappee);
  endfunction
  
  function void writeData(string data);
    super.writeData(encode(data));
  endfunction

  function string readData();
    return decode(super.readData());
  endfunction
  
  function string encode(string data);
    byte bytes[];
    bytes = new[data.len()];
    foreach(bytes[i]) begin
      bytes[i] = data.getc(i) + 1;
      data.putc(i, bytes[i]);
    end
    return data;
  endfunction
  
  function string decode(string data);
    byte bytes[];
    bytes = new[data.len()];
    foreach(data[i]) begin
      bytes[i] = data.getc(i) - 1;
      data.putc(i, bytes[i]);
    end
    return data;
  endfunction
endclass

// 添加注释装饰
class NotesDecorator extends DataSourceDecorator;
  string notes = "Notes orinal data is:";
  
  function new(DataSource wrappee);
    super.new(wrappee);
  endfunction
  
  function void writeData(string data);
    super.writeData(addnotes(data));
  endfunction

  function string readData();
    return removenotes(super.readData());
  endfunction
  
  function string addnotes(string data);
    data = {notes, data};
    return data;
  endfunction
  
  function string removenotes(string data);
    data = data.substr(notes.len(), data.len()-1);
    return data;
  endfunction
endclass
    
module Test;
  string salaryRecords;
  DataSourceDecorator encoded;
  EncryptionDecorator encry_decry;
  NotesDecorator notes_decry;
  FileDataSource data;
  
  initial begin
  	salaryRecords = "Name,Salary\nJohn Smith,100000\nSteven Jobs,912000";
  	data = new("test.log");
  	encry_decry = new(data);
    notes_decry = new(encry_decry);
  	encoded = new(notes_decry);
  
  	encoded.writeData(salaryRecords);
  
  	$display("- Input ----------------");
  	$display(salaryRecords);
  	$display("- Encoded --------------");
  	$display(data.readData());
  	$display("- Decoded --------------");  
  	$display(encoded.readData());
  end
endmodule
