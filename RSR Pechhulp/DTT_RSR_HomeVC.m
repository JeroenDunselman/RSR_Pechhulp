//
//  ViewController.m
//  RSR Pechhulp
//
//  Created by Jeroen Dunselman on 06/07/15.
//  Copyright (c) 2015 Jeroen Dunselman. All rights reserved.
//

#import "DTT_RSR_HomeVC.h"
//http://stackoverflow.com/questions/12446990/how-to-detect-iphone-5-widescreen-devices/12447113#12447113
#define IS_WIDESCREEN_IOS7 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IS_WIDESCREEN_IOS8 ( fabs( ( double )[ [ UIScreen mainScreen ] nativeBounds ].size.height - ( double )1136 ) < DBL_EPSILON )
#define IS_WIDESCREEN      ( ( [ [ UIScreen mainScreen ] respondsToSelector: @selector( nativeBounds ) ] ) ? IS_WIDESCREEN_IOS8 : IS_WIDESCREEN_IOS7 )
#define IS_IPHONE ( [ [ [ UIDevice currentDevice ] model ] isEqualToString: @"iPhone" ] )
#define IS_IPOD   ( [ [ [ UIDevice currentDevice ] model ] isEqualToString: @"iPod touch" ] )
#define IS_IPHONE_5 ( IS_IPHONE && IS_WIDESCREEN ) //WERKT IN SIMULATOR NIET
@interface DTT_RSR_HomeVC ()
@property (weak, nonatomic) IBOutlet UIView *vwBtnMap;
@property (weak, nonatomic) IBOutlet UIView *vwBtnAbout;
@property (weak, nonatomic) IBOutlet UIView *vwInfoIcon;
@property (weak, nonatomic) IBOutlet UIButton *btnInfo;
@property (weak, nonatomic) IBOutlet UIImageView *vwBgImg;
@end

@implementation DTT_RSR_HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    UIImage *bgImg = [[UIImage alloc] init];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.barBtn.image = nil;
        bgImg = [UIImage imageNamed:@"img_main_ipad"];
    } else {
        self.vwBtnAbout.hidden = true;
        if (IS_IPHONE_5) {
#warning werkt niet in simulator, niet getest op device
            bgImg = [UIImage imageNamed:@"img_main@i5"];
        } else {
            bgImg = [UIImage imageNamed:@"img_main"];
        }
    }
    self.vwBgImg.image = bgImg;
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

