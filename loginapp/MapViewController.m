//
//  MapViewController.m
//  loginapp
//
//  Created by Mihaela Pacalau on 8/25/16.
//  Copyright © 2016 Marcel Spinu. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>

@interface MapViewController () <MKMapViewDelegate> {

    MKPointAnnotation* pointAnnotation;
    UILongPressGestureRecognizer* longPressGestureRecognizer;
    MKDirections* directions;
    
}
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc] init];
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    
    
    longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]
                                                                initWithTarget:self
                                                                action:@selector(longPressGestureAction:)];
    [longPressGestureRecognizer setMinimumPressDuration:0.5f];
    [self.mapView addGestureRecognizer:longPressGestureRecognizer];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void) longPressGestureAction : (UILongPressGestureRecognizer*) longPressGestureRecongnizer {
    
    CGPoint touchPoint = [longPressGestureRecongnizer locationInView:self.mapView];
    self.touchMapCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    
    NSLog(@" %@", NSStringFromCGPoint(touchPoint));
    NSLog(@"%f, %f", self.touchMapCoordinate.latitude, self.touchMapCoordinate.longitude);
    
    if (UIGestureRecognizerStateBegan != longPressGestureRecongnizer.state)
        return;
    
    self.subview = [[UIView alloc] initWithFrame:CGRectMake(touchPoint.x, touchPoint.y, 200, 250)];
    self.subview.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height /2);
    [self.subview setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.subview];
    [self fadeInAnimation:self.view];
    
    self.subview.layer.shadowColor = [UIColor blackColor].CGColor;
    self.subview.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    self.subview.layer.shadowOpacity = 0.45f;
    self.subview.layer.shadowRadius = 60.0f;
    self.subview.layer.cornerRadius = 10.f;
    self.subview.layer.opacity = 0.95f;


    
    
    self.textView = [[UITextView alloc] init];
    [self.subview addSubview:self.textView];
    [self.textView setFrame:CGRectMake(10, 5, 190, 145)];
    [self.textView setBackgroundColor:[UIColor whiteColor]];
    [self.textView setFont:[UIFont systemFontOfSize:14.f]];
    self.textView.layer.cornerRadius = 10.f;
    [self.textView becomeFirstResponder];


    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.subview addSubview:button];
    [button setTitle:@"Submit" forState:UIControlStateNormal];
    [button setFrame:CGRectMake(0, 200, 200, 50)];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(saveAnnotation:) forControlEvents:UIControlEventTouchUpInside];
    [self.mapView removeGestureRecognizer: longPressGestureRecognizer];
}


- (void) addAnnotations: (CLLocationCoordinate2D) touchMapCoordinate withText: (UITextView*) notificationTextView {
    
    pointAnnotation = [[MKPointAnnotation alloc] init];
    pointAnnotation.coordinate = touchMapCoordinate;
    pointAnnotation.title = @"Notification";
    pointAnnotation.subtitle = notificationTextView.text;
    [self.mapView addAnnotation:pointAnnotation];

}


- (void)saveAnnotation:(UIButton*)sender{
    
    [self.mapView addGestureRecognizer:longPressGestureRecognizer];
    [self.textView becomeFirstResponder];
    [self addAnnotations: self.touchMapCoordinate withText: self.textView];
    [self fadeInAnimation:self.view];
    [self.subview removeFromSuperview];
//    longPressGestureRecognizer.cancelsTouchesInView = YES;
}


- (void) removeAnnotationAction: (UIButton*) sender {
    
    UIAlertController* removeAnnotationAlertController = [UIAlertController alertControllerWithTitle:@"Remove annotation" message:@"Do you really want to remove this annotation ?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* removeAction = [UIAlertAction actionWithTitle:@"Remove" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self.mapView removeAnnotation:pointAnnotation];
    }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [removeAnnotationAlertController addAction:removeAction];
    [removeAnnotationAlertController addAction:cancelAction];
    
    [self presentViewController:removeAnnotationAlertController animated:YES completion:nil];
    
    [self.mapView removeOverlays:self.mapView.overlays];
    
    
   
    
}


- (void) buildPathAction:(UIButton*) sender {
    
    if ([directions isCalculating]) {
        [directions cancel];
    }
    
    MKDirectionsRequest* directionRequest = [[MKDirectionsRequest alloc] init];
    directionRequest.source = [MKMapItem mapItemForCurrentLocation];
    
    MKPlacemark* placemarkDestination = [[MKPlacemark alloc] initWithCoordinate:self.touchMapCoordinate addressDictionary:nil];
    
    MKMapItem* destinationMapItem = [[MKMapItem alloc] initWithPlacemark:placemarkDestination];
    
    directionRequest.destination = destinationMapItem;
    
    directionRequest.transportType = MKDirectionsTransportTypeWalking;
    
    directions = [[MKDirections alloc] initWithRequest:directionRequest];
    
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
        
        [self.mapView removeOverlays:[self.mapView overlays]];
        
        NSMutableArray* routesPolyline = [NSMutableArray array];
        
        for (MKRoute* route in response.routes) {
            [routesPolyline addObject:route.polyline];
        }
        
        [self.mapView addOverlays:routesPolyline level:MKOverlayLevelAboveRoads];
        
    }];
}


#pragma mark - MKMapViewDelegate

- (void) mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    MKMapCamera* camera = [MKMapCamera cameraLookingAtCenterCoordinate:userLocation.coordinate fromEyeCoordinate:CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude) eyeAltitude:10000];
    
    [self.mapView setCamera:camera animated:YES];
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    if ([annotation isKindOfClass: [MKUserLocation class]]) {
        return nil;
    }
    
    MKPinAnnotationView* pinAnnotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"identifer"];
    pinAnnotationView.animatesDrop = YES;
    pinAnnotationView.canShowCallout = YES;

//    CUSTOM PIN IMAGE
//    pinAnnotationView.image = [UIImage imageNamed:@"gps-3.png"];
//    pinAnnotationView.centerOffset = CGPointMake(0, -32);
//    pinAnnotationView.layer.shadowColor = [UIColor blackColor].CGColor;
//    pinAnnotationView.layer.shadowOffset = CGSizeMake(20, 0);
//    pinAnnotationView.layer.shadowOpacity = 0.5;
//    pinAnnotationView.layer.shadowRadius = 3.0;
    
    UIButton* removeAnnotationButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [removeAnnotationButton addTarget:self action:@selector(removeAnnotationAction:) forControlEvents:UIControlEventTouchUpInside];
    pinAnnotationView.leftCalloutAccessoryView = removeAnnotationButton;

//    PATH BUTTON
    UIButton* pathAnnotationButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [pathAnnotationButton addTarget:self action:@selector(buildPathAction:) forControlEvents:UIControlEventTouchUpInside];
    pinAnnotationView.rightCalloutAccessoryView = pathAnnotationButton;
    
    
    return pinAnnotationView;
}

- (void) mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    
    pointAnnotation = view.annotation;
}


-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineRenderer* polylineRenderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        polylineRenderer.lineWidth = 2.f;
        polylineRenderer.strokeColor = [UIColor redColor];
        
        return polylineRenderer;
    }
    return nil;
}


#pragma mark - Animation

-(void)fadeInAnimation:(UIView *)aView {
    
    CATransition *transition = [CATransition animation];
    transition.type =kCATransitionFade;
    transition.duration = 0.5f;
    transition.delegate = self;
    [aView.layer addAnimation:transition forKey:nil];
}

#pragma mark - Keyboard Hide

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Dealloc

- (void)dealloc {
    
    if([directions isCalculating])
        [directions cancel];
}

@end
