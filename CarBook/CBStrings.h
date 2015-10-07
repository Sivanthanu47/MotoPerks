//
// Created by Raja T S Sekhar on 08/02/14.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define UIColorFromRGBA(rgbValue, alphaValue) ([UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 \
blue:((float)(rgbValue & 0xFF)) / 255.0 \
alpha:alphaValue])
#define UIColorFromRGB(rgbValue) (UIColorFromRGBA((rgbValue), 1.0))

@interface CBStrings : NSObject {

}

@property(nonatomic, strong) NSDictionary *cbStrings;

+ (id)sharedStrings;

- (void)initializeStrings;

- (NSString *)getString:(NSString *)forKey;

- (NSString *)getAlertMessage:(NSString *)forKey;

- (NSString *)getPageTitle:(NSString *)forKey;

- (UIColor *)colorFromString:(NSString *)hexString;

@end