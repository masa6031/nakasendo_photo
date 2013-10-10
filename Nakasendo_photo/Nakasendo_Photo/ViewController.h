//
//  ViewController.h
//  Nakasendo_Photo
//
//  Created by マサヒロ　パソナPC on 13/09/26.
//  Copyright (c) 2013年 pasonatech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface ViewController : UIViewController<CLLocationManagerDelegate,UIImagePickerControllerDelegate,MKMapViewDelegate,CLLocationManagerDelegate>
{
    UIImage             *photoFrameImage;
    UIImage             *photoImage;
    int     tapCount;
    NSMutableArray * groups;    //収集したALAssetsGroupクラスを格納
    BOOL albumWasFound;
}
- (IBAction)tapCameraButton:(id)sender;
- (IBAction)tapMoveButton:(id)sender;
@property (retain, nonatomic) IBOutlet MKMapView *mapView;
@property ( nonatomic, retain ) CLLocationManager *locationManager;
@property ( nonatomic, retain ) ALAssetsLibrary *library;
@property ( nonatomic, retain ) NSString *AlbumName;
@property ( nonatomic, retain ) NSURL *groupURL;
@property ( nonatomic, retain ) NSData *originalPhotoData;
@property ( nonatomic, retain ) UIImage *thumbImage;
@property ( nonatomic, retain ) NSMutableArray *photoArray;
@property ( nonatomic, assign ) CLLocationCoordinate2D photoLocation;
@property (retain, nonatomic) IBOutlet UIImageView *imageView;


@end
