//
//  ViewController.m
//  customCamera
//
//  Created by scott on 16/9/12.
//  Copyright © 2016年 scott. All rights reserved.
//

#import "ViewController.h"
#import "systemCameraVC.h"
#import "customMainVC.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSMutableArray*dataArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"拍照";
    self.cameraTableView.delegate = self;
    self.cameraTableView.dataSource = self;
    self.dataArray = [[NSMutableArray alloc]initWithObjects:@"自定义相机",@"系统相机", nil];

//    self.view.backgroundColor = [UIColor whiteColor];
    
    // Do any additional setup after loading the view, typically from a nib.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*cellID = @"cellID";
    UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0)
    {
        UIStoryboard *board = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
        customMainVC * vc = [board instantiateViewControllerWithIdentifier: @"customMainVC"];
        
        [self.navigationController pushViewController:vc animated:YES];

    }else
    {
        UIStoryboard *board = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
        systemCameraVC * vc = [board instantiateViewControllerWithIdentifier: @"systemVC"];

        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
