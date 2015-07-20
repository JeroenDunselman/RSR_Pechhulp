//
//  DTT_RSR_PechhulpViewController.m
//  RSR Pechhulp
//
//  Created by Jeroen Dunselman on 06/07/15.
//  Copyright (c) 2015 Jeroen Dunselman. All rights reserved.
//

#import "DTT_RSR_PechhulpViewController.h"
#import "DTT_RSR_MapPoint.h"
#import "Reachability.h"
#import <SystemConfiguration/SystemConfiguration.h>

@interface DTT_RSR_PechhulpViewController ()
- (IBAction)callNowBtn_iPhone:(UIButton *)sender;
- (IBAction)callNowBtn:(UIButton *)sender;
- (IBAction)cancelCallBtn:(UIButton *)sender;
- (BOOL)connected;
@property (weak, nonatomic) IBOutlet UIImageView *vwMarker;
@property (weak, nonatomic) IBOutlet UIView *vwContactInfoRSR;
@property (weak, nonatomic) IBOutlet UIView *vwCallBtn;
@property (weak, nonatomic) IBOutlet UIView *vwLocaMsg;
@property (weak, nonatomic) IBOutlet UIView *vwPopup_iPhone;
@property (weak, nonatomic) IBOutlet UITextView *textLocationDescription;
@property (weak, nonatomic) IBOutlet UILabel *lblCallCost;
@property (weak, nonatomic) IBOutlet UITextView *txtCallCost;
@end

@implementation DTT_RSR_PechhulpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initLocaMgr];
    NSString *strCallCost = @"9,4 cent per gesprek plus 2,8 cent per minuut, plus uw gebruikelijke belkosten.";
    self.lblCallCost.text = strCallCost;
    self.txtCallCost.text = strCallCost;
    self.vwLocaMsg.hidden = true;
    self.vwMarker.hidden = true;
    self.vwContactInfoRSR.hidden = true;
    self.vwPopup_iPhone.hidden = true;
    self.vwCallBtn.hidden = true;
    
    if (![self connected]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Niet verbonden met internet"
                                                        message:@"Activeer via Instellingen."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    if (!locationManager.locationServicesEnabled){
        //1.3. Wanneer de GPS van het mobiele device is uitgeschakeld,
        //wordt de gebruiker gevraagd om de GPS van het mobiele device te activeren.
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"GPS niet ingeschakeld"
                                                        message:@"Activeer GPS via Instellingen."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    [locationManager startUpdatingLocation];
}

- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

- (IBAction)callNowBtn_iPhone:(UIButton *)sender {
#warning todo activate
//    NSString *phoneNumber = [@"tel://" stringByAppendingString:@"09007788990"];
    //   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    self.vwPopup_iPhone.hidden = true;
}

- (IBAction)cancelCallBtn:(UIButton *)sender {
    self.vwPopup_iPhone.hidden = true;
    self.vwCallBtn.hidden = false;
    self.vwLocaMsg.hidden = false;
}

- (IBAction)callNowBtn:(UIButton *)sender {
    self.vwCallBtn.hidden = true;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    //1.1.2.	Op iPad of Android tablet;
    //1.1.1.1.	Wanneer de ‘Contact RSR’ knop wordt ingedrukt toont de app de contactgegevens van de klantenservice van RSR Nederland.
        self.vwContactInfoRSR.hidden = false;
    } else {
        self.vwPopup_iPhone.hidden = false;
        self.vwLocaMsg.hidden = true;//onhandig dat het adres niet in beeld blijft!
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *annotationIdentifier = @"AnnotationIdentifier";
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
    pinView = [[MKPinAnnotationView alloc]
               initWithAnnotation:annotation
               reuseIdentifier:annotationIdentifier];
    [pinView setImage:[UIImage imageNamed:@"marker.png"]];
    return pinView;
}

- (void)initLocaMgr {
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
     //1.7 [als] de app geen toegang heeft tot de GPS van het apparaat, zal de app een pop-up weergeven.
    [locationManager requestWhenInUseAuthorization];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [locationManager setDistanceFilter:10.0f];
//    [locationManager startUpdatingLocation];
    [worldView setDelegate:self];
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusDenied) {
    //  1.7. Indien de GPS van de smartphone of tablet is uitgeschakeld
        self.vwContactInfoRSR.hidden = false;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"GPS niet geautoriseerd"
                                                        message:@"Installeer de app opnieuw om RSR Pechhulp te gebruiken."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    //    NSLog(@"Location: %@", newLocation);
    NSTimeInterval t =[[newLocation timestamp] timeIntervalSinceNow];
    if (t<-180) {
        return;
    }
    [self foundLocation:newLocation];
}

-(void)foundLocation:(CLLocation *)loc{
    [self reverseGeocode:loc];
    CLLocationCoordinate2D coord = [loc coordinate];
    DTT_RSR_MapPoint *mp = [[DTT_RSR_MapPoint alloc] InitWithCoordinate:coord
                                                        title:[self.textLocationDescription text]];
    [worldView removeAnnotations:worldView.annotations];
    [worldView addAnnotation:mp];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 10, 100);
    [worldView setRegion:region animated:YES];
    [locationManager stopUpdatingLocation];
}

//maakt van een CLLocation een nette adresstring en toont MP
- (void)reverseGeocode:(CLLocation *)location {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            NSLog(@"Error %@", error.description);
        } else {
            self.vwLocaMsg.hidden = false;
            CLPlacemark *placemark = [placemarks lastObject];
            NSString *sLocation = [NSString stringWithFormat:@"%@", ABCreateStringWithAddressDictionary(placemark.addressDictionary, NO)];
            NSString *sLocationMessage = [[NSString alloc] initWithFormat:
                                          @"%@ \n\n %@", sLocation, @"Onthoud deze locatie voor het telefoongesprek"];
            self.textLocationDescription.text = sLocationMessage;
            // custom views for device
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                self.vwContactInfoRSR.hidden = false;
            } else {
                self.vwCallBtn.hidden = false;
            }
        }
    }];
}

-(void) mapView:(MKMapView *)mapview didUpdateUserLocation:
(MKUserLocation *)userLocation {
    //zoom
    CLLocationCoordinate2D loc = [userLocation coordinate];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 250, 250);
    [worldView setRegion:region animated:YES];
    [locationManager startUpdatingLocation];
}

-(void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"Could not find location: %@", error);
}

-(void)dealloc
{
    //tell the locationmanager to stop sending us messages
    [locationManager setDelegate:nil];
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
