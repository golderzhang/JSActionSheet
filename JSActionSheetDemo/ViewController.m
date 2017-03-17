//
//  ViewController.m
//  JSActionSheetDemo
//
//  Created by Golder on 2017/3/18.
//  Copyright © 2017年 Golder. All rights reserved.
//

#import "JSActionSheet.h"
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)showActionSheet:(id)sender {
    JSActionSheet *sheet = [JSActionSheet actionSheetWithTitle:@"选择照片"];
    [sheet addAction:[JSAction actionWithTitle:@"照片库" actionStyle:JSActionStyleDefault handler:^(JSAction *action) {
        
    }]];
    [sheet addAction:[JSAction actionWithTitle:@"相机" actionStyle:JSActionStyleDefault handler:^(JSAction *action) {
        
    }]];
    [sheet addAction:[JSAction actionWithTitle:@"取消" actionStyle:JSActionStyleCancel handler:^(JSAction *action) {
        
    }]];
    [sheet show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
