//
//  ZSTDCompressHelper.m
//  ZSTDExample
//
//  Created by libohao on 16/9/27.
//  Copyright © 2016年 libohao. All rights reserved.
//

#import "ZSTDCompressHelper.h"
#import "simple_compression.c"
#import "simple_decompression.c"
#import "zstd.h"

@implementation ZSTDCompressHelper

+ (NSData*)compressData:(NSData*)sourceData {

    
    const char* fileBytes = (const char*)[sourceData bytes];
    NSUInteger length = [sourceData length];
    
    size_t const cBuffSize = ZSTD_compressBound(length);
    void* const cBuff = malloc_orDie(cBuffSize);
    
    size_t const cSize = ZSTD_compress(cBuff, cBuffSize, fileBytes, length, 1);
    if (ZSTD_isError(cSize)) {
        fprintf(stderr, "error compressing : %s \n", ZSTD_getErrorName(cSize));
        return nil;
    }
    
    NSData* data = [NSData dataWithBytes:cBuff length:cSize];
    free(cBuff);
    return data;
}

+ (NSData*)decompressData:(NSData*)sourceData {
    unsigned long long const rSize = ZSTD_getDecompressedSize([sourceData bytes], sourceData.length);
    if (rSize==0) {
        //printf("%s : original size unknown \n", fname);
        return nil;
    }
    void* const rBuff = malloc_X(rSize);
    
    size_t const dSize = ZSTD_decompress(rBuff, rSize, [sourceData bytes], sourceData.length);
    
    if (dSize != rSize) {
        printf("error decoding : %s \n", ZSTD_getErrorName(dSize));
        return nil;
    }
    
    NSData* data = [NSData dataWithBytes:rBuff length:rSize];
    free(rBuff);
    
//    NSLog(@"success");
    return data;
}

+ (NSData*)decompressData:(NSData*)sourceData withDictionary:(NSData *)dictionary {
    unsigned long long const rSize = ZSTD_getDecompressedSize([sourceData bytes], sourceData.length);
    if (rSize==0) {
        //printf("%s : original size unknown \n", fname);
        return nil;
    }
    void* const rBuff = malloc_X(rSize);
    ZSTD_DCtx *dictInfo = ZSTD_createDCtx();

    size_t dSize = ZSTD_decompress_usingDict(dictInfo,
                                             rBuff, rSize,
                                             [sourceData bytes], sourceData.length,
                                             dictionary.bytes, dictionary.length);

    if (dSize != rSize) {
        printf("error decoding : %s \n", ZSTD_getErrorName(dSize));
        return nil;
    }

    NSData* data = [NSData dataWithBytes:rBuff length:rSize];
    free(rBuff);
	ZSTD_freeDCtx(dictInfo);

//    NSLog(@"success");
    return data;
}

@end
