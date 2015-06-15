//
//  PTGameViewController.m
//  Particle
//
//  Created by Veronica Zheng on 6/14/15.
//  Copyright (c) 2015 Veronica Zheng. All rights reserved.
//

#import "PTGameViewController.h"
#import "LeapObjectiveC.h"
#import "PTHandNode.h"

@interface PTGameViewController () <LeapListener>

@property (nonatomic, strong) LeapController *leapController;
// An array of PTHandNode.
@property (nonatomic, strong) NSMutableArray *handNodes;

@end

@implementation PTGameViewController

-(void)awakeFromNib {
    // create a scene and add the scene to the view
    SCNScene *scene = [SCNScene scene];
    self.gameView.scene = scene;
    self.gameView.backgroundColor = [NSColor blackColor];
    self.gameView.allowsCameraControl = YES;
    self.gameView.showsStatistics = YES;

    // create and add a camera to the scene
    SCNNode *cameraNode = [SCNNode node];
    cameraNode.camera = [SCNCamera camera];
    cameraNode.position = SCNVector3Make(0, 0, 20);
    [scene.rootNode addChildNode:cameraNode];
    
    // create and add a omni light to the scene
    SCNNode *lightNode = [SCNNode node];
    lightNode.light = [SCNLight light];
    lightNode.light.type = SCNLightTypeOmni;
    lightNode.position = SCNVector3Make(0, 10, 10);
    [scene.rootNode addChildNode:lightNode];
    
    // create and add an ambient light to the scene
    SCNNode *ambientLightNode = [SCNNode node];
    ambientLightNode.light = [SCNLight light];
    ambientLightNode.light.type = SCNLightTypeAmbient;
    ambientLightNode.light.color = [NSColor darkGrayColor];
    [scene.rootNode addChildNode:ambientLightNode];
    
    // create and add the particle system to the scene
    SCNParticleSystem *ps = [SCNParticleSystem particleSystemNamed:@"emitters" inDirectory:nil];
    ps.local = YES;
    ps.emitterShape = [SCNSphere sphereWithRadius:5];

    SCNNode *particleNode = [SCNNode node];
    particleNode.position = SCNVector3Make(0, 0, 0);
    [particleNode runAction:
        [SCNAction repeatActionForever:
            [SCNAction rotateByAngle:M_PI * 2 aroundAxis:SCNVector3Make(0.3, 1, 0) duration:8]
         ]
     ];
    [particleNode addParticleSystem:ps];
    [scene.rootNode addChildNode:particleNode];

    self.handNodes = [[NSMutableArray alloc] init];
    [self startLeapMotionTracking];
}

- (void)startLeapMotionTracking {
    self.leapController = [[LeapController alloc] init];
    [self.leapController addListener:self];
}

- (void)dealloc {
    [self.handNodes removeAllObjects];
    [self.leapController removeListener:self];
}

#pragma mark - LeapListener

- (void)onInit:(NSNotification *)notification {
    NSLog(@"Initiated");
}

- (void)onConnect:(NSNotification *)notification {
    NSLog(@"Connected");
}

- (void)onDisconnect:(NSNotification *)notification {
    NSLog(@"Disconnected");
}

- (void)onFrame:(NSNotification *)notification {
    [self.handNodes enumerateObjectsUsingBlock:^(PTHandNode *handNode, NSUInteger idx, BOOL *stop) {
        [handNode removeFromParentNode];
    }];
    [self.handNodes removeAllObjects];

    LeapController *aController = (LeapController *)notification.object;
    LeapFrame *frame = [aController frame:0];
    
    [frame.hands enumerateObjectsUsingBlock:^(LeapHand *hand, NSUInteger idx, BOOL *stop) {
        PTHandNode *handNode = [[PTHandNode alloc] initWithLeapHand:hand];
        [self.gameView.scene.rootNode addChildNode:handNode];
        [self.handNodes addObject:handNode];
    }];
}

@end
