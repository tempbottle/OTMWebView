//
//  OTMWebViewProgressBar.m
//  
//
//  Created by Ryan on 7/22/14.
//
//

#import "OTMWebViewProgressBar.h"
#import "OTMWebViewProgressBarLayer.h"

@interface OTMWebViewProgressBar ()
@property (strong, nonatomic) OTMWebViewProgressBarLayer *progressBarLayer;
@end

@implementation OTMWebViewProgressBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		
		self.progressBarLayer = [[OTMWebViewProgressBarLayer alloc]init];
		[self.layer addSublayer:self.progressBarLayer];
		self.progress = 0.0;
		self.fadeOnFinish = YES;
		self.fadeOnFinishAnimationDuration = 0.75;
		self.fadeOnFinishDelay = 0.25;
    }
    return self;
}

-(void)layoutSubviews {
	
	self.progressBarLayer.frame = self.bounds;
}

-(void)setProgress:(double)progress {
	

	[self setProgress:progress animated:NO];
}

-(double)progress {
	
	return self.progressBarLayer.progress;
}

-(void)setProgress:(double)progress animated:(BOOL)animated {
		
	[self setProgress:progress animationDuration:animated ? 0.1 : 0.0];
}

-(void)setProgress:(double)progress animationDuration:(NSTimeInterval)animationDuration {
		
	if (animationDuration > 0.0) {
	
		CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"progress"];
		animation.fromValue = @(((OTMWebViewProgressBarLayer *)self.progressBarLayer.presentationLayer).progress);
		animation.toValue = @(progress);
		animation.duration = animationDuration;
		[self.progressBarLayer addAnimation:animation forKey:nil];

	} else {
		
		[self.progressBarLayer setNeedsDisplay];
	}
	
	self.progressBarLayer.progress = progress;
	
	[self.progressBarLayer removeAnimationForKey:@"fadeAnimation"];
	
	if (progress >= 1.0 && self.fadeOnFinish) {
		
		CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"alpha"];
		fadeAnimation.duration = self.fadeOnFinishAnimationDuration;
		fadeAnimation.beginTime = [self.progressBarLayer convertTime:CACurrentMediaTime() fromLayer:nil] + self.fadeOnFinishDelay;
		fadeAnimation.delegate = self;
		fadeAnimation.removedOnCompletion = NO;
		[self.progressBarLayer addAnimation:fadeAnimation forKey:@"fadeAnimation"];
	}
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
	
	if (anim == [self.progressBarLayer animationForKey:@"fadeAnimation"]) {
		
		if (flag) {
			self.progress = 0.0;
		}
		
		[self.progressBarLayer removeAnimationForKey:@"fadeAnimation"];
	}
}

-(void)setTintColor:(UIColor *)tintColor {
	
	self.progressBarLayer.tintColor = tintColor;
}

-(UIColor *)tintColor {
	
	return self.progressBarLayer.tintColor;
}

@end

