//
//  ViewController.m
//  UI22_多线程
//
//  Created by dllo on 15/6/18.
//  Copyright (c) 2015年 dllo. All rights reserved.
//

#import "ViewController.h"
#import "MyOperation.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
@interface ViewController ()

@property(nonatomic, retain)MBProgressHUD *hud;
@property(nonatomic, retain)UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.layer.borderWidth = 1;
    button.layer.cornerRadius = 10;
    [button setTitle:@"测试" forState:UIControlStateNormal];
    [self.view addSubview:button];
    button.frame = CGRectMake(100, 100, 100, 30);
    [button addTarget:self action:@selector(GCDAction:) forControlEvents:
     UIControlEventTouchUpInside];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 200, 100, 100)];
    [self.view addSubview:self.imageView];
    
    
//    NSString *str = @"http://amuse.nen.com.cn/imagelist/11/21/9as70n3ir61b.jpg";
//    
//    NSURL *url = [NSURL URLWithString:str];
//    NSData *data = [NSData dataWithContentsOfURL:url];
//    UIImage *image = [UIImage imageWithData:data];
//    imageView.image = image;
    
    //用AFN下载进度,专门做下载的是ASI,它的下载比AFN好
    //创建一个小菊花
//    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    self.hud.labelText = @"下载中...";
//    self.hud.mode = MBProgressHUDModeDeterminate;
//    //下载一个pdf文件,需要给下载的文件指定一个下载的路径
//    NSArray *sandBox = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 1, YES);
//    NSString *sandBoxPath = sandBox[0];
//    //拼接一个文件夹路径
//    NSString *documentPath = [sandBoxPath stringByAppendingPathComponent:@"test.pdf"];
//    //AFN进行下载
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://help.adobe.com/archive/en/photoshop/cs6/photoshop_reference.pdf"]];
//    
//    AFHTTPRequestOperation *opeartion = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    //NSOutputStream网络的数据下载到指定的文件路径下
//    opeartion.outputStream = [NSOutputStream outputStreamToFileAtPath:documentPath append:NO];
//    
//    [opeartion setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
//        self.hud.progress = totalBytesRead *(1.0) / totalBytesExpectedToRead;
//        
//    }];
//    //新建一个队列
//    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//    [queue addOperation:opeartion];
//    //在下载之后消失
//    [opeartion setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [self.hud removeFromSuperview];
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//        
//    }];
}

-(void)click:(UIButton *)button
{
    for (NSInteger i = 0; i < 600000000; i++) {
        NSLog(@"%ld", i);
    }
}

//系统给我们提供了四种解决线程问题的方法
//1.NSObject里的方法
-(void)nsobjectAction:(UIButton *)button
{
    NSLog(@"%s", __func__);
    [self performSelectorInBackground:@selector(click:) withObject:nil];
    //优点:可以给指定的方法开辟一个子线程,使用方便,而且是NSObject的方法,谁都有
    //缺点:线程会在数据安全上存在隐患
}

//多线程第二个方法
- (void)NSThreadAction:(UIButton *)button
{
    // NSThread提供了一些线程的方法
    //判断当前方法是不是主线程
    NSLog(@"%d", [NSThread isMainThread]);
    //让当前线程休眠3秒钟
//    [NSThread sleepForTimeInterval:3];
//    NSLog(@"测试");
    
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(click:) object:nil];
    //给线程起名
    thread.name = @"王炜光";
    //通过方法,让子线程启动
    [thread start];
    //优点:也可以快速的为方法开辟一个子线程,而且他本身还有很多关于线程的方法,比如是否是主线程,休眠等
    //缺点:子线程需要自己启动,比较麻烦
}

//第三种
-(void)operationAction:(UIButton *)button
{
    // NSOperation任务的意思,需要根据指定的任务,来创建相应的任务的类,让他继承NSOperation
    // 创建一个MyOperation的对象
    MyOperation *operation = [[MyOperation alloc] init];
    // 启动任务
    [operation start];
    //如果只运行任务的话,并没有起到多线程的效果,它需要和NSOperationQueue配合使用,才会产生效果
}
//给队列写一个方法
- (void)queueAction:(UIButton *)button
{
    // 创建一个自定义队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    // 给queue设置一个最大的并发数
    [queue setMaxConcurrentOperationCount:2];
    
    MyOperation *operation1 = [[MyOperation alloc] init];
    MyOperation *operation2 = [[MyOperation alloc] init];
    MyOperation *operation3 = [[MyOperation alloc] init];
    MyOperation *operation4 = [[MyOperation alloc] init];
    MyOperation *operation5 = [[MyOperation alloc] init];
    //把任务添加到队列中
    [queue addOperation:operation1];
    [queue addOperation:operation2];
    [queue addOperation:operation3];
    [queue addOperation:operation4];
    [queue addOperation:operation5];
    
    //队列会自动的分配线程数,并且会自动启动
    //会利用上闲置的线程,最少的开辟的线程,提高线程的使用率
    //缺点:太麻烦
    
}

// 第四种多线程的方法:GCD
-(void)GCDAction:(UIButton *)button
{
    // GCD是苹果推荐的一种处理多线程的方法,他和之前的队列是处理多线程常用的两个方法
    // 定义一个队列
    // DISPATCH_QUEUE_CONCURRENT 是并行的意思
//    dispatch_queue_t myQueue = dispatch_queue_create("test", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_async(myQueue, ^{
//        // 开始, 在这个block里写一些任务
//        NSInteger a = 0;
//        for (NSInteger i = 0; i < 600000000; i++) {
//            a++;
//        }
//        NSLog(@"%ld", a);
//    });
//
    // GCD经典的使用方式,就是在异步加载数据,然后回到主线程里对控件内容进行重新赋值
    // 1.指定当前队列是优先队列
    // 2.没用,留给以后使用的 就是0
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // 获取一个主队列
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    // 在全局队列里先进行数据的请求
    dispatch_async(globalQueue, ^{
        NSString *strURL = @"http://amuse.nen.com.cn/imagelist/11/21/9as70n3ir61b.jpg";
        NSURL *url = [NSURL URLWithString:strURL];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        // 去主队列刷新数据
        dispatch_async(mainQueue, ^{
            // 对imageView进行赋值
            self.imageView.image = image;
            
        });
    });
}









- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
