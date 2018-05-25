//
//  UIImageView+Network.m
//  SDWebImage-Extend
//
//  Created by paperclouds on 2018/5/25.
//  Copyright © 2018年 hechang. All rights reserved.
//

#import "UIImageView+Network.h"
#import <UIImageView+WebCache.h>
#import <objc/runtime.h>
#import "UIView+WebCacheOperation.h"
#import "UIViewExt.m"
#import "UIColor+Extend.h"

static char TAG_ACTIVITY_INDICATOR;
static char TAG_ACTIVITY_STYLE;
static char TAG_ACTIVITY_SHOW;

static char imageURLKey;

@implementation UIImageView (Network)

-(void)sd_ssetImageWithURL:(NSString *)url{
    [self sd_ssetImageWithURL:[NSURL URLWithString:url] placeholderImage:[self getPlaceHolderImage] options:0 progress:nil completed:nil];
}

-(UIImage*)getPlaceHolderImage{
    UIImageView *imageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholder_image"]];
    imageView.width= imageView.height=self.height/2;
    UIView *placeHolderView=[[UIView alloc] initWithFrame:self.bounds];
    placeHolderView.backgroundColor= [UIColor colorWithHexString:@"#8f8f8f"];
    [placeHolderView addSubview:imageView];
    imageView.centerX=placeHolderView.width/2;
    imageView.centerY=placeHolderView.height/2;
//         下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了，关键就是第三个参数。
    CGSize s = placeHolderView.bounds.size;
    s.height-=1;
    UIGraphicsBeginImageContextWithOptions(s, YES, [UIScreen mainScreen].scale);

    [placeHolderView.layer renderInContext:UIGraphicsGetCurrentContext()];
    placeHolderView.layer.contents = nil;
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return image;
}

-(void)sd_ssetImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDExternalCompletionBlock)completedBlock{
    
    [self sd_cancelCurrentImageLoad];
    objc_setAssociatedObject(self, &imageURLKey, url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (!(options & SDWebImageDelayPlaceholder)) {
        dispatch_main_async_safe(^{
            self.image = placeholder;
        });
    }
    
    if (url) {
        
        // check if activityView is enabled or not
        if ([self showActivityIndicatorView]) {
            [self addActivityIndicator];
        }
        __weak __typeof(self)wself = self;
        
        id <SDWebImageOperation> operation = [SDWebImageManager.sharedManager loadImageWithURL:url options:options progress:progressBlock completed:^(UIImage *image, NSData *data, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            
            [wself removeActivityIndicator];
            
            if (!wself) return;
            
            dispatch_main_async_safe(^{
                
                if (!wself) return;
                
                if (image && (options & SDWebImageAvoidAutoSetImage) && completedBlock)
                    
                {
                    
                    completedBlock(image, error, cacheType, url);
                    
                    return;
                    
                }
                
                else if (image) {
                    
                    CATransition *animation = [CATransition animation];
                    
                    animation.duration = .85f;
                    
                    animation.type = kCATransitionFade;
                    
                    animation.removedOnCompletion = YES;
                    
                    [wself.layer addAnimation:animation forKey:@"transition"];
                    
                    wself.image = image;
                    
                    [wself setNeedsLayout];
                    
                } else {
                    
                    if ((options & SDWebImageDelayPlaceholder)) {
                        
                        wself.image = placeholder;
                        
                        [wself setNeedsLayout];
                        
                    }
                    
                }
                
                if (completedBlock && finished) {
                    
                    completedBlock(image, error, cacheType, url);
                    
                }
                
            });
            
        }];
        
        [self.layer removeAnimationForKey:@"transition"];
        
        [self sd_setImageLoadOperation:operation forKey:@"UIImageViewImageLoad"];
        
    } else {
        
        dispatch_main_async_safe(^{
            
            [self removeActivityIndicator];
            
            if (completedBlock) {
                
                NSError *error = [NSError errorWithDomain:SDWebImageErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey : @"Trying to load a nil url"}];
                
                completedBlock(nil, error, SDImageCacheTypeNone, url);
                
            }
            
        });
        
    }
}

- (void)sd_cancelCurrentImageLoad {
    [self sd_cancelImageLoadOperationWithKey:@"UIImageViewImageLoad"];
}

#pragma mark -
- (UIActivityIndicatorView *)activityIndicator {
    return (UIActivityIndicatorView *)objc_getAssociatedObject(self, &TAG_ACTIVITY_INDICATOR);
}

- (void)setActivityIndicator:(UIActivityIndicatorView *)activityIndicator {
    objc_setAssociatedObject(self, &TAG_ACTIVITY_INDICATOR, activityIndicator, OBJC_ASSOCIATION_RETAIN);
}

- (void)setShowActivityIndicatorView:(BOOL)show{
    objc_setAssociatedObject(self, &TAG_ACTIVITY_SHOW, [NSNumber numberWithBool:show], OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)showActivityIndicatorView{
    return [objc_getAssociatedObject(self, &TAG_ACTIVITY_SHOW) boolValue];
}

- (int)getIndicatorStyle{
    return [objc_getAssociatedObject(self, &TAG_ACTIVITY_STYLE) intValue];
}

- (void)addActivityIndicator {
    if (!self.activityIndicator) {
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:[self getIndicatorStyle]];
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
        
        dispatch_main_async_safe(^{
            [self addSubview:self.activityIndicator];
            
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.activityIndicator
                                                             attribute:NSLayoutAttributeCenterX
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeCenterX
                                                            multiplier:1.0
                                                              constant:0.0]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.activityIndicator
                                                             attribute:NSLayoutAttributeCenterY
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeCenterY
                                                            multiplier:1.0
                                                              constant:0.0]];
        });
    }
    
    dispatch_main_async_safe(^{
        [self.activityIndicator startAnimating];
    });
    
}

- (void)removeActivityIndicator {
    if (self.activityIndicator) {
        [self.activityIndicator removeFromSuperview];
        self.activityIndicator = nil;
    }
}

@end
