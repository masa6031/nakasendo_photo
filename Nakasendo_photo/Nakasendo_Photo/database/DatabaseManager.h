//
//  DatabaseManager.h
//  Nakasendo_Photo
//
//  Created by マサヒロ　パソナPC on 13/10/02.
//  Copyright (c) 2013年 pasonatech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DatabaseManager : NSObject
{
@private sqlite3 *db_;
}
+ (DatabaseManager *)sharedManager;

//db
- (void)copyDatabaseIfNeeded;
- (sqlite3 *)prepare;
- (void)close;

@end
