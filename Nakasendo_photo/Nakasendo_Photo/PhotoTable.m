//
//  PhotoTable.m
//  Nakasendo_Photo
//
//  Created by マサヒロ　パソナPC on 13/10/02.
//  Copyright (c) 2013年 pasonatech. All rights reserved.
//

#import "PhotoTable.h"
#import "DatabaseManager.h"
#import "PhotoData.h"

@implementation PhotoTable

+ (void)insert:(PhotoData *)data
{
	sqlite3* db;
	if((db=[[DatabaseManager sharedManager] prepare])!=NULL)
	{
        sqlite3_exec( db, "BEGIN", NULL, NULL, NULL );
        
        static NSString* sqlText =
        @"INSERT INTO "
        @"photo "
        @"VALUES "
        "("
        " ?, ?, ?, ?, ?, ?, ?, ? "
        ")";
        
        sqlite3_stmt *stmt = NULL;
        if(sqlite3_prepare_v2(db, [sqlText UTF8String], -1, &stmt, NULL)==SQLITE_OK)
        {
            sqlite3_bind_text(stmt,	 1, [data.photoId UTF8String],             -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(stmt,	 2, [data.photoLatitude UTF8String],       -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(stmt,  3, [data.photoLongitude UTF8String],      -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(stmt,  4, [data.photoSize UTF8String],             -1, SQLITE_TRANSIENT);
            sqlite3_bind_blob(stmt,  5, [data.photoBlobData bytes], [data.photoBlobData length], SQLITE_TRANSIENT);
            sqlite3_bind_text(stmt,  6, [data.albumId UTF8String],             -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(stmt,  7, [data.thumbnailSize UTF8String],             -1, SQLITE_TRANSIENT);
            sqlite3_bind_blob(stmt,  8, [data.thumbnailData bytes], [data.thumbnailData length], SQLITE_TRANSIENT);
            
            
            if(sqlite3_step(stmt)==SQLITE_DONE)
            {
            }
            else
            {
                NSLog(@"sqlite3_step error: '%s'", sqlite3_errmsg(db));
            }
            
            sqlite3_finalize(stmt);
        }
        
        sqlite3_exec( db, "COMMIT", NULL, NULL, NULL );
    }
}

+ (NSMutableArray *)selectWithPhotoId:(NSString *)albumId
{
    NSMutableArray* mArray = nil;
    sqlite3* db;
	if((db=[[DatabaseManager sharedManager] prepare])!=NULL)
	{
        static NSString* sqlText =
        @"SELECT "
        @"photo_id, photo_latitude, photo_longitude, photo_size, photo_data, album_id, thumbnail_size, thumbnail_data "
        @"FROM "
        @"photo "
        @"WHERE album_id=?";
        
        sqlite3_stmt *stmt = NULL;
        if(sqlite3_prepare_v2(db, [sqlText UTF8String], -1, &stmt, NULL)==SQLITE_OK)
        {
            sqlite3_bind_text(stmt, 1, [albumId UTF8String], -1, SQLITE_TRANSIENT);
            mArray = [NSMutableArray arrayWithCapacity:1];
            while (sqlite3_step(stmt)==SQLITE_ROW)
            {
                const char* photoId           = (const char*)sqlite3_column_text(stmt, 0);
                const char* photoLatitude           = (const char*)sqlite3_column_text(stmt, 1);
                const char* photoLongitude      = (const char*)sqlite3_column_text(stmt, 2);
                const char* photoSize      = (const char*)sqlite3_column_text(stmt, 3);
                const void* photoBlobData      = (const void*)sqlite3_column_blob(stmt, 4);
                const char* albumId      = (const char*)sqlite3_column_text(stmt, 5);
                const char* thumbnailSize = (const char*)sqlite3_column_text(stmt, 6);
                const void* thumbnailData      = (const void*)sqlite3_column_blob(stmt, 7);
                
                
                PhotoData *data = [[PhotoData alloc] init];
                int photoLength;
                int thumbnailLength;
                
                if(photoId)
                    data.photoId = [NSString stringWithUTF8String:photoId];
                if(photoLatitude)
                    data.photoLatitude = [NSString stringWithUTF8String:photoLatitude];
                if(photoLongitude)
                    data.photoLongitude = [NSString stringWithUTF8String:photoLongitude];
                if(photoSize)
                    data.photoSize = [NSString stringWithUTF8String:photoSize];
                photoLength = [[NSString stringWithUTF8String:photoSize] intValue];
                if(photoBlobData)
                    data.photoBlobData = [NSData dataWithBytes:photoBlobData length:photoLength];
                if(albumId)
                    data.albumId = [NSString stringWithUTF8String:albumId];
                if(thumbnailSize)
                    data.thumbnailSize = [NSString stringWithUTF8String:thumbnailSize];
                thumbnailLength = [[NSString stringWithUTF8String:thumbnailSize] intValue];
                if(thumbnailData)
                    data.thumbnailData= [NSData dataWithBytes:thumbnailData length:thumbnailLength];
                
                [mArray addObject:data];
                [data release];
                
                
            }
        }
        else
        {
            NSLog(@"sqlite3_step error: '%s'", sqlite3_errmsg(db));
        }
        
        sqlite3_finalize(stmt);
    }
    
    return mArray;
}

+ (void)delete:(NSString *)photoId
{
    sqlite3* db;
	if((db=[[DatabaseManager sharedManager] prepare])!=NULL)
	{
        sqlite3_exec( db, "BEGIN", NULL, NULL, NULL );
        
        static NSString* sqlText =
        @"DELETE FROM "
        @"photo"
        " WHERE photo_id = ?";
        
        sqlite3_stmt *stmt = NULL;
        if(sqlite3_prepare_v2(db, [sqlText UTF8String], -1, &stmt, NULL)==SQLITE_OK)
        {
            sqlite3_bind_text(stmt, 1, [photoId UTF8String], -1, SQLITE_TRANSIENT);
            if(sqlite3_step(stmt)==SQLITE_DONE)
            {
            }
            else
            {
                NSLog(@"sqlite3_step error: '%s'", sqlite3_errmsg(db));
            }
            sqlite3_finalize(stmt);
        }
        
        sqlite3_exec( db, "COMMIT", NULL, NULL, NULL );
    }
}

+ (int)count
{
	sqlite3 *db;
	int count = 0;
	if((db=[[DatabaseManager sharedManager] prepare])!=NULL)
	{
		char sql[128];
		sprintf(sql, "SELECT count(*) FROM photo");
		sqlite3_stmt *stmt;
		if(sqlite3_prepare_v2(db, sql, -1, &stmt, NULL)==SQLITE_OK)
		{
			if(sqlite3_step(stmt)==SQLITE_ROW)
			{
				count = sqlite3_column_int(stmt, 0);
			}
            else
            {
                NSLog(@"sqlite3_step error: '%s'", sqlite3_errmsg(db));
            }
            
			sqlite3_finalize(stmt);
		}
	}
	return count;
}

@end
