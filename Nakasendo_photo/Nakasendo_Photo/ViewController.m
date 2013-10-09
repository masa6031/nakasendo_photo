//
//  ViewController.m
//  Nakasendo_Photo
//
//  Created by マサヒロ　パソナPC on 13/09/26.
//  Copyright (c) 2013年 pasonatech. All rights reserved.
//

#import "ViewController.h"
#import "CustomAnnotation.h"
#import "PhotoViewController.h"
#import "PhotoData.h"
#import "PhotoTable.h"
#import <ImageIO/ImageIO.h>

@interface ViewController ()

@end

@implementation ViewController

@synthesize locationManager = _locationManager;
@synthesize library = _library;
@synthesize AlbumName = _AlbumName;
@synthesize groupURL = _groupURL;
@synthesize thumbImage = _thumbImage;
@synthesize originalPhotoData = _originalPhotoData;
@synthesize photoArray = _photoArray;
@synthesize photoLocation = _photoLocation;


- (void)dealloc {
    //delegateの接続を切る
    _locationManager = nil;
    
    [_locationManager release],_locationManager = nil;
    [_mapView release];
    [_library release],_library = nil;
    [_AlbumName release], _AlbumName = nil;
    [_groupURL release], _groupURL = nil;
    [_thumbImage release],_thumbImage = nil;
    [_originalPhotoData release],_originalPhotoData = nil;
    [_photoArray release],_photoArray = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.photoArray = [NSMutableArray array];

    //assetsライブラリー初期化
    _library = [[ALAssetsLibrary alloc]init];
    
    //アルバム名
    _AlbumName = @"Nakasendo_Photo";
    albumWasFound = FALSE;
    
    //アルバムが作成されているか確認
    [self albumCheck];
    
    tapCount = 0;
    //現在地を表示する
//    self.mapView.showsUserLocation = YES;
    
    _locationManager = [[CLLocationManager alloc]init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    //MKMapViewのデリゲートを自分自身に設定する
    _mapView.delegate = self;
    
    
    //マップの初期表示位置の設定
    CLLocationCoordinate2D co;
    co.latitude = 35.367528; // 経度
    co.longitude = 136.639674; // 緯度
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    _mapView.userLocation.title = nil;
    
    //写真のフレーム
    photoFrameImage = [UIImage imageNamed:@"mapPhotoFrame.png"];
    
    
    //位置情報の取得を開始する。
    [_locationManager startUpdatingLocation];
   
}
//---------------------
#pragma Album_Resource
//---------------------
- (void)albumCheck
{
    //アルバムの中に「このアプリ用」のアルバムがあるか確認。無ければ作成
	ALAssetsLibraryGroupsEnumerationResultsBlock resultBlock =
	^(ALAssetsGroup *group, BOOL *stop) {
		if (group) {
            NSLog(@"グループ収集中...[%@]（%d個のアセット）",[group valueForProperty:ALAssetsGroupPropertyName],[group numberOfAssets]);
            
            [groups addObject:group];
            //アルバムが見つかった場合
            if ([_AlbumName compare:[group valueForProperty:ALAssetsGroupPropertyName]] == NSOrderedSame) {
                NSLog(@"アルバムが見つかりました");
                
                self.groupURL = [group valueForProperty:ALAssetsGroupPropertyURL];
                NSLog(@"_groupURL=%@", self.groupURL);
                albumWasFound = TRUE;
            }
        }else{
            NSLog(@"全%d個のグループの収集が終わりました",[groups count]);
            
            //アルバムがない場合は新規作成
            if(!albumWasFound){
                ALAssetsLibraryGroupResultBlock resultBlock = ^(ALAssetsGroup *group){
                    self.groupURL = [group valueForProperty:ALAssetsGroupPropertyURL];
                    NSLog(@"「%@」のグループを作成しました",self.groupURL);
                };
                //アルバムの中に「AlbumName変数」の名前でグループを作成する。
                [_library addAssetsGroupAlbumWithName:_AlbumName resultBlock:resultBlock failureBlock:nil];
                albumWasFound = TRUE;
            }
        }
    };
    
    //ALAssetsLibraryからアルバムを取得
    [_library enumerateGroupsWithTypes:ALAssetsGroupAlbum
                           usingBlock:resultBlock
                         failureBlock:^(NSError *error){
                             NSLog(@"NO groups");
                         }];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//---------------
#pragma mark -MapViewDelegate
//---------------

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //Locationにlocationsの情報を入れる
    CLLocation *location = [[locations lastObject] copy];
    
    self.photoLocation = location.coordinate;   //取得した位置情報（緯度経度）を格納
    
    
    MKCoordinateRegion region = self.mapView.region;
    //region.centerで緯度経度の設定。locationのcoordinateに緯度経度の情報が入っている。
    region.center = location.coordinate;
    region.span.latitudeDelta = 0.1;
    region.span.longitudeDelta = 0.1;
    self.mapView.region = region;
    
    
    [location release];
}

//GPSエラーが出た時にこのメソッドが実行される
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    //
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"GPS Error"
                                                    message:@"Error" 
                                                   delegate:self cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

//----------------
#pragma mark -ImagePickerDelegate
//----------------

//カメラのボタンを押下
- (IBAction)tapCameraButton:(id)sender {
    
    //イメージピッカーカメラを生成
    UIImagePickerController *picker =
    [[[UIImagePickerController alloc] init]autorelease];
    picker.delegate = (id)self;
    
    picker.allowsEditing = NO;  //撮影後に編集可能にするかの設定
    
    // 画像の取得先をカメラに設定
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    //pickerViewに遷移させる
    [self presentViewController:picker animated:YES completion:nil];
}

//撮影終了後に「use」を押すと呼び出されるメソッド。
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //撮影写真の取得
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    
    //撮った写真をアセッツフォルダに保存。
    [self saveAssets:info image:originalImage];
    
    
    //画像のリサイズ処理
    float resize_w, resize_h;
    
    resize_w = 768.0f;
    resize_h = 1024.0f;
    
    
    UIGraphicsBeginImageContext(CGSizeMake(resize_w, resize_h));    //リサイズ処理の開始
	[originalImage drawInRect:CGRectMake(0, 0, resize_w, resize_h)];
	UIImage *newOriginalImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();    //リサイズ処理の終了
    
    //オリジナルの写真の解像度を低くしてNSDataへ変換
    self.originalPhotoData = UIImageJPEGRepresentation(newOriginalImage, 1.0);
    
    [self.photoArray addObject:self.originalPhotoData];
    
    
    
    //サムネイル画像の作成
    resize_w = 150.0;
    resize_h = 150.0;
    
    UIGraphicsBeginImageContext(CGSizeMake(resize_w, resize_h));    //リサイズ処理の開始
	[originalImage drawInRect:CGRectMake(0, 0, resize_w, resize_h)];
	UIImage *thumbnailImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();    //リサイズ処理の終了
    
    //オリジナルの写真からサムネイル用の写真をNSData型へ変換
    NSData *thumbnailData = UIImageJPEGRepresentation(thumbnailImage, 1.0);
    
    //NSData型のサムネイル画像をUIImage型へ変換。
    self.thumbImage = [UIImage imageWithData:thumbnailData]; 
    
    

    
    
    CustomAnnotation *anno = [[CustomAnnotation alloc]initWithCoordinate:_photoLocation];
    anno.title = @"写真";    //サムネイルのタイトル
    anno.photoID = tapCount;    //サムネイルにタグ
    tapCount++;     //テスト用（タップするごとに緯度経度を変更)
    
    
    
    [_mapView addAnnotation:anno];
    [anno release];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

//写真をアセッツフォルダに保存
-(void)saveAssets:(NSDictionary *)info image:(UIImage *)image
{
    
    
    //ALAsset
    //カメラロールにUIImageを保存する。保存完了後、completionBlockで「NSURL* assetURL」が取得出来る。
    [_library writeImageToSavedPhotosAlbum:image.CGImage metadata:info completionBlock:^(NSURL* assetURL, NSError* error) {
        //    [_library writeImageToSavedPhotosAlbum:image.CGImage orientation:(ALAssetOrientation)image.imageOrientation
        //                          completionBlock:^(NSURL* assetURL, NSError* error) {
        
        //アルバムにALAssetを追加する任意のメソッド
        NSLog(@"_groupURL=%@", self.groupURL);
        [_library groupForURL:self.groupURL
                  resultBlock:^(ALAssetsGroup *group){
                      
                      //URLからALAssetを取得
                      [_library assetForURL:assetURL
                                resultBlock:^(ALAsset *asset) {
                                    
                                    NSLog(@"%@",assetURL);
                                    //assetのthumbnailを取得する
//                                    self.thumbImage = [[UIImage alloc] initWithCGImage:[asset thumbnail]];
                                    //thumbnailをそのまま表示すると回転してしまうので、ここで正常値に戻す。
//                                     self.thumbImage = [UIImage imageWithCGImage:image.CGImage scale:image.scale orientation:0];
                                    
                                    
                                    
                                    if (group.editable) {
                                        //GroupにAssetを追加
                                        [group addAsset:asset];
                                    }
                                    
                                } failureBlock: nil];
                  } failureBlock:nil];
        
    }];
    

}

//--------------------
#pragma MapViewDelegate
//--------------------


// MKMapViewDelegateプロトコルメソッド。MKAnnotationに該当する地図上に表示するViewを描画をする時に呼び出される
- (MKAnnotationView *)mapView:(MKMapView *)MapView viewForAnnotation:(id <MKAnnotation>)annotation {
    //ユーザーの位置情報用
    if (annotation == _mapView.userLocation) {
        return nil;  
    }
    static NSString *PinIdentifier = @"Pin";
    
    
    // 地図上にピンを表示
    MKAnnotationView *annotationView = (MKAnnotationView*)[_mapView dequeueReusableAnnotationViewWithIdentifier:PinIdentifier];
    
    
    
    if (annotationView == nil) {
        annotationView = [[[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"myAnnotationView"]autorelease];
    }
    
    //吹き出しに表示するボタンを追加
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    annotationView.canShowCallout = YES;
    
    //自分で撮った写真用のアノテーション設定
        annotationView.image = photoFrameImage;
        //アノテーションの中心の設定
        [annotationView setCenterOffset:CGPointMake(0, -20)];
        UIImageView *photoImageView = [[UIImageView alloc]initWithImage:_thumbImage];
        photoImageView.frame = CGRectMake(5, 5, 40, 40);
        [annotationView addSubview:photoImageView];
        [photoImageView release];
    
    annotationView.annotation = annotation;
    //ここをnilにする事で、表示画像がピンになる。結果、ピン表示を画像に変更している事になる。
    return annotationView;
}

//マップを表示したときに、ピンが上部から落ちてくる。
- (void)mapView:(MKMapView *)_mapView didAddAnnotationViews:(NSArray *)views {
    
    CGRect visibleRect = [self.mapView annotationVisibleRect];
    for (MKAnnotationView *view in views) {
            CGRect endFrame = view.frame;
            CGRect startFrame = endFrame;
            startFrame.origin.y = visibleRect.origin.y - startFrame.size.height;
            view.frame = startFrame;
            [UIView beginAnimations:@"drop" context:NULL];
            [UIView setAnimationDuration:0.3];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
            view.frame = endFrame;
            [UIView commitAnimations];
    }
}
//写真の吹き出しをクリックした時の処理
- (void) mapView:(MKMapView*)_mapView annotationView:(MKAnnotationView*)annotationView calloutAccessoryControlTapped:(UIControl*)control {
    
    
    //タップしたサムネのAnnotationを読み込む
    CustomAnnotation *anno = (CustomAnnotation *)annotationView.annotation;
    NSLog(@"タグ:%d",anno.photoID);
    
    
    PhotoViewController *photoviewController = [[PhotoViewController alloc] initWithNibName:@"PhotoViewController" bundle:nil];
    //
    photoviewController.photoData = (NSData *)[_photoArray objectAtIndex:anno.photoID];
    [self presentViewController:photoviewController animated:YES completion:nil];
    [photoviewController release];

}
//写真をドロップさせるボタンを押した
- (IBAction)tapDropButton:(id)sender {
}
@end
