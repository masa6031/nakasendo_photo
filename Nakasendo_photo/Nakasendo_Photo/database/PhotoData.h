//
//  PhotoData.h
//  Nakasendo_Photo
//
//  Created by マサヒロ　パソナPC on 13/10/02.
//  Copyright (c) 2013年 pasonatech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoData : NSObject
{
    NSString *photoId;
    NSString *photoLatitude;
    NSString *photoLongitude;
    NSString *photoSize;
    NSData *photoBlobData;
    NSString *albumId;
    NSString *thumbnailSize;
    NSData *thumbnailData;
}

@property (nonatomic, copy) NSString *photoId;
@property (nonatomic, copy) NSString *photoLatitude;
@property (nonatomic, copy) NSString *photoLongitude;
@property (nonatomic, copy) NSString *photoSize;
@property (nonatomic, copy) NSData *photoBlobData;
@property (nonatomic, copy) NSString *albumId;
@property (nonatomic, copy) NSString *thumbnailSize;
@property (nonatomic, copy) NSData *thumbnailData;
@end
