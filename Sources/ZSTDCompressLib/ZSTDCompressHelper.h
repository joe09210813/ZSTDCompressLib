//
//  CompressHelper.h
//  ZSTDExample
//
//  Created by libohao on 16/9/27.
//  Copyright © 2016年 libohao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZSTDCompressHelper : NSObject

/**
 壓縮資料

 @param data 原資料
 @return 壓縮資料
 */
+ (NSData*)compressData:(NSData*)data;

/**
 解壓縮資料

 @param sourceData 壓縮資料
 @return 原資料
 */
+ (NSData*)decompressData:(NSData*)sourceData;

/**
 利用字典檔解壓縮資料

 @param sourceData 原資料
 @param dictionary 字典檔
 @return 原資料
 */
+ (NSData*)decompressData:(NSData*)sourceData withDictionary:(NSData *)dictionary;


@end
