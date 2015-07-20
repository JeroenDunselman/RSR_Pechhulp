//
//  InfoVC.m
//  RSR Pechhulp
//
//  Created by Jeroen Dunselman on 20/07/15.
//  Copyright (c) 2015 Jeroen Dunselman. All rights reserved.
//

#import "DTT_RSR_InfoVC.h"

@interface DTT_RSR_InfoVC ()
@property (weak, nonatomic) IBOutlet UITextView *tvInfoText;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTrail;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintLead;
@end

@implementation DTT_RSR_InfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
        self.constraintTrail.constant = 0;
        self.constraintLead.constant = 0;
        [self.tvInfoText setFont:[UIFont systemFontOfSize:12]];
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
