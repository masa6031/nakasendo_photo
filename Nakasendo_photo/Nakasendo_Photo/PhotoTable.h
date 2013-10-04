//
//  PhotoTable.h
//  Nakasendo_Photo
//
//  Created by マサヒロ　パソナPC on 13/10/02.
//  Copyright (c) 2013年 pasonatech. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PhotoData;

@interface PhotoTable : NSObject
{
    
}
+ (void)insert:(PhotoData *)data;
+ (NSMutableArray *)selectWithPhotoId:(NSString *)albumId;
+ (void)delete:(NSString *)photoId;
+ (int)count;

@end
