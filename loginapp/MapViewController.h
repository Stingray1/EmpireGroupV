//
//  MapViewController.h
//  loginapp
//
//  Created by Mihaela Pacalau on 8/25/16.
//  Copyright © 2016 Marcel Spinu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class MKMapView;
@class MKUserLocation;

@interface MapViewController : UIViewController

@property (weak, nonatomic) IBOutlet MKMapView* mapView;

@property (strong, nonatomic) CLLocationManager* locationManager;
@property (strong, nonatomic) UIView* subview;
@property (strong, nonatomic) MKUserLocation* userLocation;
@property (strong, nonatomic) UITextView* textView ;
@property (assign, nonatomic) CLLocationCoordinate2D touchMapCoordinate;

@end
