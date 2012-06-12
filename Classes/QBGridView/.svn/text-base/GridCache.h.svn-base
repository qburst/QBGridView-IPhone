//
//  GridCache.h
//  Gridview
//
//  Created by midhun on 10/07/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ReusableView <NSObject>

@property(copy) NSString *reuseGridIdentifier;

@end


@interface GridCache : NSObject {
	NSMutableDictionary *allViews; // reuseIdentifier -> NSMutableArray:UIView
	NSUInteger capacityPerType;
}

@property(readonly) NSUInteger capacityPerType;

+ (GridCache *)sharedCache;

- (UIView<ReusableView> *)dequeueReusableViewWithIdentifier:(NSString *)reuseIdentifier;
- (void)enqueueReusableView:(UIView<ReusableView> *)view;
- (void)removeReusableView:(UIView<ReusableView> *)view;
- (void)clear;


@end
