//
//  Data+Hashing.h
//  UncommonCrypto
//
//  Created by Ben Gottlieb on 1/29/18.
//  Copyright © 2018 Stand Alone, Inc. All rights reserved.
//

@import Foundation;

@interface NSData (Hashing)
@property (nonnull, nonatomic, readonly) NSString *md5, *sha256;
@property (nonnull, nonatomic, readonly) NSData *md5Data, *sha256Data;
@end

@interface NSString (Hashing)
@property (nonnull, nonatomic, readonly) NSString *md5, *sha256;
@property (nonnull, nonatomic, readonly) NSData *md5Data, *sha256Data;
@end

@interface NSURL (Hashing)
@property (nullable, nonatomic, readonly) NSURL *md5, *sha256;
@end

