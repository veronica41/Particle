//
//  PTHandNode.m
//  Particle
//
//  Created by Veronica Zheng on 6/14/15.
//  Copyright (c) 2015 Veronica Zheng. All rights reserved.
//

#import "PTHandNode.h"
#import "LeapObjectiveC.h"

@implementation PTHandNode

- (instancetype)initWithLeapHand:(LeapHand *)hand {
    self = [super init];
    if (self == nil) return nil;

    for (LeapFinger *finger in hand.fingers) {
        // Draw first joint inside hands.
        LeapBone *bone = [finger bone:LEAP_BONE_TYPE_METACARPAL];
        [self drawJoint:bone.prevJoint];
        
        for (int boneType = LEAP_BONE_TYPE_METACARPAL; boneType <= LEAP_BONE_TYPE_DISTAL; boneType++) {
            LeapBone *bone = [finger bone:boneType];
            [self drawBone:bone];
            [self drawJoint:bone.nextJoint];
        }
    }

    return self;
}

- (void)drawJoint:(LeapVector *)joint {
    
}

- (void)drawBone:(LeapBone *)bone {
    
}

@end
