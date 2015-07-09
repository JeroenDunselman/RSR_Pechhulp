//
//  DTT_RSR_PechhulpViewController.h
//  RSR Pechhulp
//
//  Created by Jeroen Dunselman on 06/07/15.
//  Copyright (c) 2015 Jeroen Dunselman. All rights reserved.
//

//#import <UIKit/UIKit.h>
//
//@interface DTT_RSR_PechhulpViewController : UIViewController
//
//@end


#import <UIKit/UIKit.h>
#import "CoreLocation/CoreLocation.h"
#import "MapKit/MapKit.h"
#import <AddressBookUI/AddressBookUI.h>

@interface  DTT_RSR_PechhulpViewController: UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>
{
    CLLocationManager *locationManager;
//    IBOutlet UIActivityIndicatorView * activityIndicator;
    IBOutlet MKMapView *worldView;
}
-(void)findLocation;
-(void)foundLocation:(CLLocation *)loc;
@end