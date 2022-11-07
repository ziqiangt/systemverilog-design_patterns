// 视频文件
class VideoFile;
  protected string name;
  protected string codecType;
  
  function new(string name);
    this.name = name;
    this.codecType = find_filetype();
  endfunction
  
  function string find_filetype();
    foreach(name[i]) begin
      if(name[i] == ".") begin
        return name.substr(i+1, name.len() - 1);
      end
    end
  endfunction
  
  function string getCodecType();
    return codecType;
  endfunction
  
  function string getName();
    return name;
  endfunction
endclass

// 编译码器接口
interface class Codec;
endclass

// MPEG4压缩格式编译码器
class MPEG4CompressionCodec implements Codec;
  string mtype = "mp4";
endclass

// Ogg压缩格式编译码器
class OggCompressionCodec implements Codec;
  string mtype = "ogg";
endclass

// 编译码器工厂
class CodecFactory;
  static function Codec extract(VideoFile file);
    string mtype = file.getCodecType();
    if(mtype == "mp4") begin
      MPEG4CompressionCodec mcodec;
      mcodec = new();
      $display("CodecFactory: extracting mpeg audio...");
      return mcodec;
    end else begin
      OggCompressionCodec mcodec;
      mcodec = new();
      $display("CodecFactory: extracting ogg audio...");
      return mcodec;
    end
  endfunction
endclass

// bit读取器
class BitrateReader;
  static function VideoFile read(VideoFile file, Codec codec);
    $display("BitrateReader: reading file...");
    return file;
  endfunction

  static function VideoFile convert(VideoFile buffer, Codec codec);
    $display("BitrateReader: writing file...");
    return buffer;
  endfunction
endclass

// 调音台
class AudioMixer;
  function string fix(VideoFile result);
    $display("AudioMixer: fixing audio...");
    return "tmp";
  endfunction
endclass
  
// 外观
class VideoConversionFacade;
  function string convertVideo(string fileName, string format);
    VideoFile file = new(fileName);
    Codec sourceCodec = CodecFactory::extract(file);
    Codec destinationCodec;
    $display("VideoConversionFacade: conversion started.");
    if (format == "mp4") begin
      MPEG4CompressionCodec mcodec = new();
      destinationCodec = mcodec;
    end else begin
      OggCompressionCodec mcodec = new();
      destinationCodec = mcodec;
    end
    
    begin
      VideoFile buffer;
      VideoFile intermediateResult;
      string result;
      AudioMixer audioMixer = new();
      buffer = BitrateReader::read(file, sourceCodec);
      intermediateResult = BitrateReader::convert(buffer, destinationCodec);
      result = audioMixer.fix(intermediateResult);
      return result;
    end
  endfunction
endclass
  
module test;
  initial begin
    string mp4Video;
    VideoConversionFacade converter = new();
    mp4Video = converter.convertVideo("youtubevideo.ogg", "mp4");
    $display("Ouput file name is \"%0s\"", mp4Video);
  end
endmodule
