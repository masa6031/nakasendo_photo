//
//  PhotoAnnotation.h
//  Nakasendo_Photo
//
//  Created by マサヒロ　パソナPC on 13/09/30.
//  Copyright (c) 2013年 pasonatech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CustomAnnotation : NSObject<MKAnnotation>
{
    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subtitle;
    NSInteger photoID;
}

@property (nonatomic)CLLocationCoordinate2D coordinate;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *subtitle;
@property (nonatomic,assign) NSInteger photoID;

-(id)initWithCoordinate:(CLLocationCoordinate2D)co;

@end
