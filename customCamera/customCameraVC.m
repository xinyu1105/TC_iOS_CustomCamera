//
//  customCameraVC.m
//  customCamera
//
//  Created by scott on 16/9/14.
//  Copyright © 2016年 scott. All rights reserved.
//

#import "customCameraVC.h"
#import "customMainVC.h"
#define ZYAppWidth                      [[UIScreen mainScreen] bounds].size.width
#define ZYAppHeight                     [[UIScreen mainScreen] bounds].size.height
@interface customCameraVC ()
{
    int count ;
    UIButton *_photoButotn;
    UIView   *_downView;
    UIImage * _photopImage;
    NSInteger selectedFirstTag;
    NSInteger selectedSecondTag;
}
@end

@implementation customCameraVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"拍照";
    self.view.backgroundColor = [UIColor whiteColor];
//    UIBarButtonItem * backBarBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"fanhui"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarBtnClick)];
//    self.navigationItem.leftBarButtonItem = backBarBtn;
    
    UIBarButtonItem * rightBarBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"camera_flash_on"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarBtnClick:)];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
    [self MakeMyCapture];
    [self turnOnLed];
    // Do any additional setup after loading the view.
}
-(void)turnOnLed {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch]) {
        [device lockForConfiguration:nil];
        [device setFlashMode:AVCaptureFlashModeOn];
        [device unlockForConfiguration];
    }
}
-(void)turnOffLed {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch]) {
        [device lockForConfiguration:nil];
        //        [device setTorchMode: AVCaptureTorchModeOff];
        [device setFlashMode:AVCaptureFlashModeOff];
        
        [device unlockForConfiguration];
    }
}
-(void)rightBarBtnClick:(UIBarButtonItem*)btn
{
    NSLog(@"---%d",count);
    count++;
    if (count%2==1)
    {
        [self turnOffLed];
        [btn setImage:[UIImage imageNamed:@"camera_flash_off"]];
    }else
    {
        [self turnOnLed];
        [btn setImage:[UIImage imageNamed:@"camera_flash_on"]];
    }
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    
    if (self.session) {
        
        [self.session startRunning];
    }
}


- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:YES];
    if (self.session) {
        
        [self.session stopRunning];
    }
}
-(void)backBarBtnClick
{
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark 构造自定义相机
-(void)MakeMyCapture
{
    self.session = [[AVCaptureSession alloc] init];
    NSError *error;
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //更改这个设置的时候必须先锁定设备，修改完后再解锁，否则崩溃
    [device lockForConfiguration:nil];
    //设置闪光灯为自动
    [device setFlashMode:AVCaptureFlashModeAuto];
    [device unlockForConfiguration];
    
    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];
    if (error) {
        NSLog(@"%@",error);
    }
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary * outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    [self.stillImageOutput setOutputSettings:outputSettings];
    
    if ([self.session canAddInput:self.videoInput]) {
        [self.session addInput:self.videoInput];
    }
    if ([self.session canAddOutput:self.stillImageOutput]) {
        [self.session addOutput:self.stillImageOutput];
    }
    
    
    
    
    
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    
    self.previewLayer.frame = CGRectMake(0,64,self.view.frame.size.width ,self.view.frame.size.height-64);
    self.previewLayer.videoGravity = AVLayerVideoGravityResize;
    //    [self.previewLayer setBounds:self.view.bounds];
    self.previewLayer.contentsScale = [UIScreen mainScreen].scale;
    self.previewLayer.backgroundColor = [[UIColor redColor]CGColor];
    self.view.layer.masksToBounds = YES;
    
    [self.view.layer addSublayer:self.previewLayer];
    //创建相机下面自定义视图
    [self createCusphototV];
}
-(void)createCusphototV
{
    CGFloat viewH = 140;
    _downView = [[UIView alloc] initWithFrame:CGRectMake(0, ZYAppHeight-viewH, ZYAppWidth, viewH)];
    _downView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_downView];
    //加上相机按钮和其他的自定义按钮
    UILabel *photoLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, ZYAppWidth-10, 20)];
    photoLable.text = @"拍照要求：请先拍风景哦";
    photoLable.numberOfLines = 0;
    photoLable.font = [UIFont systemFontOfSize:13];
    photoLable.textColor = [UIColor whiteColor];
    [_downView addSubview:photoLable];
    _photoButotn = [[UIButton alloc] init];
    [_photoButotn setBackgroundImage:[UIImage imageNamed:@"xiangji"] forState:UIControlStateNormal];
    [_photoButotn addTarget:self action:@selector(SavePhoto:) forControlEvents:UIControlEventTouchUpInside];
    [_downView addSubview:_photoButotn];
    _photoButotn.frame = CGRectMake((ZYAppWidth-40)/2, 40, 45, 35);
        //创建状态button
//    if([self.taskTypeStr isEqualToString:@"上画"])
//    {
//        [self createstaButton:_downView];
//    }
}
-(void)SavePhoto:(UIButton *)button
{
    //进行拍照保存图片
    AVCaptureConnection *conntion = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    if (!conntion) {
        NSLog(@"拍照失败!");
        return;
    }
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:conntion completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer == nil) {
            return ;
        }
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        
        _photopImage = [UIImage imageWithData:imageData];
        
       [self Dophoto];
        
    }];
}
-(void)Dophoto
{
    UIView *viewb = [[UIView alloc]init];
    viewb.frame = self.view.frame;
    viewb.backgroundColor = [UIColor blackColor];
    [self.view addSubview:viewb];
    UIImageView *imagev = [[UIImageView alloc] initWithImage:_photopImage];
    imagev.contentMode = UIViewContentModeScaleAspectFit;
    imagev.frame = CGRectMake(0, 64, ZYAppWidth, ZYAppHeight-64-40);
    [viewb addSubview:imagev];
    UIButton *leftbutton = [[UIButton alloc]init];
    [leftbutton setTitle:@"取消" forState:UIControlStateNormal];
    leftbutton.tag = 1001;
    [leftbutton setTintColor:[UIColor whiteColor]];
    [viewb addSubview:leftbutton];
    leftbutton.frame = CGRectMake(30, ZYAppHeight-30, 60, 20);
    [leftbutton addTarget:self action:@selector(hitopbutton:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *rightbutton = [[UIButton alloc]init];
    [rightbutton setTitle:@"确定" forState:UIControlStateNormal];
    rightbutton.tag = 1000;
    [rightbutton setTintColor:[UIColor whiteColor]];
    [viewb addSubview:rightbutton];
    rightbutton.frame = CGRectMake(ZYAppWidth-90, ZYAppHeight-30, 60, 20);
    
    [rightbutton addTarget:self action:@selector(hitopbutton:) forControlEvents:UIControlEventTouchUpInside];

}
-(void)hitopbutton:(UIButton *)button
{
    
    [button.superview removeFromSuperview];
    if(button.tag == 1000){
//        [self savePicturePath];
        for (UIViewController*controller in [self.navigationController viewControllers])
        {
            if ([controller isKindOfClass:[customMainVC class]])
            {
                customMainVC * vc = controller;
                vc.headImageView.image = _photopImage;
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
        
    }
    else{
        
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
