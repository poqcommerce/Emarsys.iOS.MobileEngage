//
// Copyright (c) 2017 Emarsys. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MEConfigBuilder;

NS_ASSUME_NONNULL_BEGIN
@interface MEConfig : NSObject

@property(nonatomic, readonly) NSString *applicationId;
@property(nonatomic, readonly) NSString *applicationSecret;

typedef void(^MEConfigBuilderBlock)(MEConfigBuilder *builder);

+ (MEConfig *)makeWithBuilder:(MEConfigBuilderBlock)builderBlock;

@end

NS_ASSUME_NONNULL_END