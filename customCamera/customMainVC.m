//
//  customMainVC.m
//  customCamera
//
//  Created by scott on 16/9/14.
//  Copyright © 2016年 scott. All rights reserved.
//

#import "customMainVC.h"
#import "customCameraVC.h"
@interface customMainVC ()

@end

@implementation customMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"自定义相机";
    self.headImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer*tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickPersonImage:)];
    [self.headImageView addGestureRecognizer:tap];

    // Do any additional setup after loading the view.
}
-(void)clickPersonImage:(UITapGestureRecognizer*)tap
{
    customCameraVC * vc = [[customCameraVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
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
