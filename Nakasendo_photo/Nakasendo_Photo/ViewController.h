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
    NSString *AlbumName;    //アルバムの名前
    NSMutableArray * groups;    //収集したALAssetsGroupクラスを格納
    BOOL albumWasFound;
    ALAssetsLibrary *library;
    NSURL *groupURL;
}
- (IBAction)tapCameraButton:(id)sender;
- (IBAction)tapDropButton:(id)sender;
@property (retain, nonatomic) IBOutlet MKMapView *mapView;
@property ( nonatomic, retain ) CLLocationManager *locationManager;

@end
