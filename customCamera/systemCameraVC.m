//
//  systemCameraVC.m
//  customCamera
//
//  Created by scott on 16/9/12.
//  Copyright © 2016年 scott. All rights reserved.
//

#import "systemCameraVC.h"

@interface systemCameraVC ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImagePickerController*pickerView;
}

@property(nonatomic,weak)IBOutlet UIImageView*personImageView;
@end

@implementation systemCameraVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"系统相机";
    self.personImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer*tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickPersonImage:)];
    [self.personImageView addGestureRecognizer:tap];
    // Do any additional setup after loading the view.
}
-(void)clickPersonImage:(UITapGestureRecognizer*)tap
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册中选择", nil];
    [sheet showInView:self.view];

}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self startCameraController];
            break;
        case 1:
            [self startsystemImageLibrary];
            break;
        default:
            break;
    }
}

/**
 拍照
 */
- (void)startsystemImageLibrary
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        pickerView = nil;
        pickerView = [[UIImagePickerController alloc] init];
        pickerView.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        pickerView.delegate = self;
        pickerView.allowsEditing = NO;
        pickerView.allowsImageEditing = YES;
        pickerView.navigationBar.barTintColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
        pickerView.navigationBar.tintColor = [UIColor whiteColor];
        [pickerView.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        pickerView.navigationBar.translucent = NO;
        if ([self respondsToSelector:@selector(presentViewController:animated:completion:)]){
            [self presentViewController:pickerView animated:YES completion:^{
            }];
        }
    }
}

/**
 从系统中选择
 */
- (void)startCameraController
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        pickerView = nil;
        pickerView = [[UIImagePickerController alloc] init];
        pickerView.delegate = self;
        pickerView.sourceType = UIImagePickerControllerSourceTypeCamera;
        pickerView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        pickerView.allowsEditing = NO;
        pickerView.allowsImageEditing = YES;
        if ([self respondsToSelector:@selector(presentViewController:animated:completion:)]){
            [self presentViewController:pickerView animated:YES completion:^{
                [pickerView setShowsCameraControls:YES];
            }];
        }
    }
}

#pragma mark - image selector

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *pickerImage = [info objectForKey:UIImagePickerControllerEditedImage];
    NSData *imageData = UIImageJPEGRepresentation(pickerImage, 0.5);
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [picker dismissViewControllerAnimated:YES completion:^void{
        
        self.personImageView.image = pickerImage;
        
    }];
}

/**
 取消
 */
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];//退出照相机视图
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
