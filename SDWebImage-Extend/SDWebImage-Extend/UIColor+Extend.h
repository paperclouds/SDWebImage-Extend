//
//  UIColor+Extend.h
//  Wifi
//
//  Created by muxi on 14/11/19.
//  Copyright (c) 2014年 muxi. All rights reserved.
//

#import <UIKit/UIKit.h>

#define rgb(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]
#define rgba(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define hexColor(colorV) [UIColor colorWithHexColorString:@#colorV]
#define hexColorAlpha(colorV,a) [UIColor colorWithHexColorString:@#colorV alpha:a];
#define ramdomColor [UIColor colorWithRed:arc4random_uniform(255)/255.0f green:arc4random_uniform(255)/255.0f blue:arc4random_uniform(255)/255.0f alpha:1.0f]

@interface UIColor (Extend)

+ (UIColor *)colorWithHex:(UInt32)hex;

/**
 *  十六进制颜色
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString;

/**
 *  十六进制颜色:含alpha
 */
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

/**
 Creates and returns a color object using the specified hexadecimal int.
 
 @param aRGB The hexadecimal int like 0x121212
 
 @return The color object.
 */
+ (UIColor *)colorWithRGB:(int)aRGB;

/**
 Creates and returns a color object using the specified hexadecimal int and opacity.
 
 @param aRGB The hexadecimal int like 0x121212
 @param aAlpha The opacity value of the color object, specified as a value from 0.0 to 1.0.
 
 @return The color object.
 */
+ (UIColor *)colorWithRGB:(int)aRGB WithAlpha:(CGFloat)aAlpha;

@end
