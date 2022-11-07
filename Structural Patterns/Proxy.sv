typedef class Video;
typedef Video vedio_assoc[string];
  
// 远程服务接口
interface class ThirdPartyYouTubeLib;
  // 模拟delay，所以需要用task
  pure virtual task popuplarVideos(ref Video vedio_assoc[string]);
  pure virtual task getVideo(input string videoId, output Video video);
endclass

// 远程服务实现
class  ThirdPartyYouTubeClass implements ThirdPartyYouTubeLib;
  virtual task popuplarVideos(ref Video vedio_assoc[string]);
    connectToServer("http://www.youtube.com");
    getRandomVideos(vedio_assoc);
  endtask
  
  virtual task getVideo(input string videoId, output Video video);
    connectToServer($sformatf("http://www.youtube.com/%0s", videoId));
    getSomeVideo(videoId, video);
  endtask
  
  // 模拟网络行为
  task experienceNetworkLatency();
    repeat($urandom_range(5, 10) * 100) #1ms;
  endtask
  
  task connectToServer(string server);
    $display("Connecting to %0s ... ", server);
    experienceNetworkLatency();
    $display("Connected!");
  endtask
  
  task getRandomVideos(ref Video vedio_assoc[string]);
    $display("Downloading populars... ");
    
    experienceNetworkLatency();
    vedio_assoc.delete();
    hmapPutVideo(vedio_assoc["catzzzzzzzzz"], "sadgahasgdas", "Catzzzz.avi");
    hmapPutVideo(vedio_assoc["mkafksangasj"], "mkafksangasj", "Dog play with ball.mp4");
    hmapPutVideo(vedio_assoc["dancesvideoo"], "asdfas3ffasd", "Dancing video.mpq");
    hmapPutVideo(vedio_assoc["dlsdk5jfslaf"], "dlsdk5jfslaf", "Barcelona vs RealM.mov");
    hmapPutVideo(vedio_assoc["3sdfgsd1j333"], "3sdfgsd1j333", "Programing lesson#1.avi");
    
    $display("Done!");
  endtask
  
  function void hmapPutVideo(ref Video vedio_hash, input string id, string title);
    Video video = new(id, title);
    vedio_hash = video;
  endfunction
  
  task getSomeVideo(input string videoId, output Video video);
    $display("Downloading video... ");
    
    experienceNetworkLatency();
	video = new(videoId, "Some video title");
    
    $display("Done!");
  endtask
endclass
    
// 视频文件
class Video;
  string id;
  string title;
  string data;
  
  function new(string id, string title);
    this.id = id;
    this.title = title;
    this.data = "Random video";
  endfunction
endclass
    
// 缓存代理
class YouTubeCacheProxy implements ThirdPartyYouTubeLib;
  protected ThirdPartyYouTubeLib youtubeService;
  protected Video cachePopular[string];
  protected Video cacheAll[string];
  
  function new(ThirdPartyYouTubeLib youtubeService);
    this.youtubeService = youtubeService;
  endfunction
  
  virtual task popuplarVideos(ref Video vedio_assoc[string]);
    if(cachePopular.num() == 0) begin
      youtubeService.popuplarVideos(cachePopular);
    end else begin
      $display("Retrieved list from cache.");
    end
    vedio_assoc = cachePopular;
  endtask
  
  virtual task getVideo(input string videoId, output Video video);
    video = cacheAll[videoId];
    if(video == null) begin
      youtubeService.getVideo(videoId, video);
      cacheAll[videoId] = video;
    end
  endtask
  
  function void reset();
    cachePopular.delete();
    cacheAll.delete();
  endfunction
endclass
    
// 媒体下载应用
class YouTubeDownloader;
  protected ThirdPartyYouTubeLib api;
  
  function new(ThirdPartyYouTubeLib api);
    this.api = api;
  endfunction
  
  task renderVideoPage(string videoId);
    Video video;
    api.getVideo(videoId,video);
    $display("\n-------------------------------");
    $display("Video page (imagine fancy HTML)");
    $display("ID: %0s", video.id);
    $display("Title: %0s", video.title);
    $display("Video: %0s", video.data);
    $display("-------------------------------\n");
  endtask
    
  task renderPopularVideos();
    Video vedio_assoc[string];
    api.popuplarVideos(vedio_assoc);
    $display("\n-------------------------------");
    $display("Most popular videos on YouTube (imagine fancy HTML)");
    foreach (vedio_assoc[i]) begin
      $display("ID: %0s / Title: %0s", vedio_assoc[i].id, vedio_assoc[i].title);
    end
    $display("-------------------------------\n");
  endtask
endclass

module test;
  YouTubeDownloader naiveDownloader;
  YouTubeDownloader smartDownloader;
  
  initial begin
    ThirdPartyYouTubeClass thirdPartyYouTubeClass = new();
    YouTubeCacheProxy youTubeCacheProxy = new(thirdPartyYouTubeClass);
    
    naiveDownloader = new(thirdPartyYouTubeClass);
    smartDownloader = new(youTubeCacheProxy);
    
    begin
    time naive;
    time smart;
    test(naiveDownloader, naive);
    test(smartDownloader, smart);
    $display("Time saved by caching proxy: %0tms", (naive - smart));
    end
  end
  
  task test(YouTubeDownloader downloader, output time estimatedTime);
    time startTime;
    startTime = $time();
    
    // User behavior in our app:
    downloader.renderPopularVideos();
    downloader.renderVideoPage("catzzzzzzzzz");
    downloader.renderPopularVideos();
    downloader.renderVideoPage("dancesvideoo");
    // Users might visit the same page quite often.
    downloader.renderVideoPage("catzzzzzzzzz");
    downloader.renderVideoPage("someothervid");

    estimatedTime = $time() - startTime;
    $display("Time elapsed: %0tms", estimatedTime);
  endtask
endmodule
