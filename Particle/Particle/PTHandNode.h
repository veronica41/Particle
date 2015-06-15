//
//  PTHandNode.h
//  Particle
//
//  Created by Veronica Zheng on 6/14/15.
//  Copyright (c) 2015 Veronica Zheng. All rights reserved.
//

#import <SceneKit/SceneKit.h>

@class LeapHand;

@interface PTHandNode : SCNNode

/// Designated initializer.
- (instancetype)initWithLeapHand:(LeapHand *)hand;

@end
