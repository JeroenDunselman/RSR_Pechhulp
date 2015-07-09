//
//  ViewController.m
//  RSR Pechhulp
//
//  Created by Jeroen Dunselman on 06/07/15.
//  Copyright (c) 2015 Jeroen Dunselman. All rights reserved.
//

#import "HomeVC.h"

@interface HomeVC ()
@property (weak, nonatomic) IBOutlet UIView *vwBtnMap;
@property (weak, nonatomic) IBOutlet UIView *vwBtnAbout;
@property (weak, nonatomic) IBOutlet UIView *vwInfoIcon;
@property (weak, nonatomic) IBOutlet UIButton *btnInfo;
@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
     if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
         self.vwInfoIcon.hidden = true;
     } else {
         self.vwBtnAbout.hidden = true;
     }
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

