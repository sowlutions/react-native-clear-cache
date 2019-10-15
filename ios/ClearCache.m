#import "ClearCache.h"


@implementation ClearCache

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(getAppCacheSize:(RCTResponseSenderBlock)callback)
{
    NSString* fileSize = [self filePath:@"2"];
    NSString* fileSizeName = [self filePath:@"1"];
    callback(@[fileSize, fileSizeName]);
}

RCT_EXPORT_METHOD(clearAppCache:(RCTResponseSenderBlock)callback)
{
    [self clearFile:callback];
}

- (NSString*)filePath:(NSString*)type
{
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    return [self folderSizeAtPath :cachPath type:type];
}

- (long long)fileSizeAtPath:( NSString *) filePath {
    NSFileManager * manager = [ NSFileManager defaultManager];
    if ([manager fileExistsAtPath :filePath]) {
        return [[manager attributesOfItemAtPath :filePath error : nil ] fileSize ];
    }
    return 0;
}

- (NSString*)folderSizeAtPath:(NSString *) folderPath type:(NSString*)type {
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath :folderPath]) return 0 ;
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator ];
    
    NSString *fileName;
    
    long long folderSize = 0 ;
    
    while ((fileName = [childFilesEnumerator nextObject ]) != nil ) {
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        folderSize += [ self fileSizeAtPath :fileAbsolutePath];
    }
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.roundingMode = NSNumberFormatterRoundFloor;
    formatter.maximumFractionDigits = 2;
    
    NSString* strFileSize = [[NSString alloc]init];
    NSMutableString* strFileName = [[NSMutableString alloc]init];
    if (folderSize < 1024) {
        NSNumber* fileSize = [NSNumber numberWithFloat: folderSize];
        strFileSize = [formatter stringFromNumber:fileSize];
        [strFileName setString:@"B"];
    } else if (folderSize < 1048576) {
        NSNumber* fileSize = [NSNumber numberWithFloat: (folderSize / 1024.0)];
        strFileSize = [formatter stringFromNumber:fileSize];
        [strFileName setString:@"KB"];
    } else if(folderSize < 1073741824) {
        NSNumber* fileSize = [NSNumber numberWithFloat: (folderSize / 1048576.0)];
        strFileSize = [formatter stringFromNumber:fileSize];
        [strFileName setString:@"MB"];
    } else {
        NSNumber* fileSize = [NSNumber numberWithFloat: (folderSize / 1073741824.0)];
        strFileSize = [formatter stringFromNumber:fileSize];
        [strFileName setString:@"G"];
    }
    
    if ([type isEqualToString:@"1"]) {
        return strFileName;
    } else {
        return strFileSize;
    }
}

- (void)clearFile:(RCTResponseSenderBlock)callback
{
    NSString * cachPath = [NSSearchPathForDirectoriesInDomains (NSCachesDirectory, NSUserDomainMask, YES ) firstObject];
    
    NSArray * files = [[NSFileManager defaultManager]subpathsAtPath:cachPath];
    
    NSLog ( @"cachpath = %@" , cachPath);
    
    for ( NSString * p in files) {
        NSError * error = nil ;
        NSString * path = [cachPath stringByAppendingPathComponent :p];
        if ([[ NSFileManager defaultManager ] fileExistsAtPath :path]) {
            [[ NSFileManager defaultManager ] removeItemAtPath :path error :&error];
        }
    }
    
    callback(@[[NSNull null]]);
    
}

@end
