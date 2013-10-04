//
//  DatabaseManager.m
//  Nakasendo_Photo
//
//  Created by マサヒロ　パソナPC on 13/10/02.
//  Copyright (c) 2013年 pasonatech. All rights reserved.
//

#import "DatabaseManager.h"

#define kDatabase       @"photo.db"
#define kAppVersionKey  @"AppVersion"

static DatabaseManager *sharedInstance_ = nil;

@implementation DatabaseManager

//--------------------------------------------------------------//
#pragma mark -- Initialize --
//--------------------------------------------------------------//

+ (DatabaseManager*)sharedManager
{
	@synchronized(self)
	{
		if (!sharedInstance_)
		{
			sharedInstance_ =  [[self alloc] init];
		}
	}
	
    return sharedInstance_;
}

- (id)init
{
	if((self=[super init]))
	{
        [self close];
		[self copyDatabaseIfNeeded];
	}
	return self;
}

//--------------------------------------------------------------//
#pragma mark -- Memory management --
//--------------------------------------------------------------//
- (void)dealloc
{
    [self close];
    
	[super dealloc];
}

//--------------------------------------------------------------//
#pragma mark -- NSBDatabaseManager method --
//--------------------------------------------------------------//

//copyDatabaseIfNeeded, データベースがドキュメントフォルダになければコピーする
- (void)copyDatabaseIfNeeded
{
	// ドキュメントフォルダ以下のデータベースパスの生成 ライブラリの既存パスに変更
	NSArray *paths;
	paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *dbPath;
	dbPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:kDatabase];
    
	NSFileManager *fileManager;
	fileManager = [NSFileManager defaultManager];
    
    // アプリのver情報を取得する
    NSString* appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    // 前回生成した際のver情報を取得する
    NSString* userDefAppVersion = [[NSUserDefaults standardUserDefaults] objectForKey:kAppVersionKey];
    
    if(![userDefAppVersion isEqualToString:appVersion])
    {
        // 初回(更新された場合)にDBが存在したら削除して新規DB追加(DB更新もあり得るため)
        // ただし、同パターンは旧DB情報を全て削除してしまうため、必要な時にコメントアウトをはずして利用してください
        /*
         
         if([fileManager fileExistsAtPath:dbPath])
         {
         [fileManager removeItemAtPath:dbPath error:NULL];
         }
         */
    }
    
	
    // DBがなければリソースからコピー
    NSError *error;
	if(![fileManager fileExistsAtPath:dbPath])
	{
		NSString *orgDbPath;
		orgDbPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:kDatabase];
        if(![fileManager copyItemAtPath:orgDbPath toPath:dbPath error:&error])
		{
            NSLog(@"DB COPY ERROR! %@", [error localizedDescription]);
		}
		else
		{
            [[NSUserDefaults standardUserDefaults] setObject:appVersion forKey:kAppVersionKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            // DB OPEN
            [self prepare];
		}
        
	}
}

- (sqlite3*)prepare
{
	if(db_==NULL)
	{
		// ドキュメントフォルダ以下のデータベースパスの生成 ライブラリの既存パスに変更
		NSArray *paths;
		paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *dbPath;
		dbPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:kDatabase];
		// データベースをオープンする
		if(sqlite3_open([dbPath UTF8String], &db_)!=SQLITE_OK)
		{
			NSLog(@"DB OPEN ERROR.(%@/%@)",NSStringFromClass([self class]),NSStringFromSelector(_cmd));
			
			// error action
			sqlite3_close(db_);
			db_ = NULL;
		}
	}
	return db_;
}

- (void)close
{
	if(db_!=NULL)
	{
		sqlite3_close(db_);
		db_ = NULL;
	}
}

@end
