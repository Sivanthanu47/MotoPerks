//
// Created by Raja T S Sekhar on 08/02/14.
//

#import "CBStrings.h"


@implementation CBStrings

+ (id)sharedStrings {
    static CBStrings *sharedStrings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStrings = [[self alloc] init];
    });
    return sharedStrings;
}

- (void)initializeStrings {
    _cbStrings = [NSDictionary dictionaryWithContentsOfFile:
            [[NSBundle mainBundle] pathForResource:@"strings" ofType:@"plist"]];
}

- (NSString *)getString:(NSString *)forKey {
    if (_cbStrings == nil) {
        [self initializeStrings];
    }
    NSString *strValue = nil;
    strValue = [_cbStrings objectForKey:forKey];
    if (strValue == nil) {
        strValue = @"";
    }
    return strValue;
}
- (UIColor *)colorFromString:(NSString *)hexString {
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    unsigned hex;
    BOOL success = [scanner scanHexInt:&hex];
    
    if (!success) return nil;
    if ([hexString length] <= 6) {
        return UIColorFromRGB(hex);
    } else {
        unsigned color = (hex & 0xFFFFFF00) >> 8;
        CGFloat alpha = 1.0 * (hex & 0xFF) / 255.0;
        return UIColorFromRGBA(color, alpha);
    }
}

- (NSString *)getAlertMessage:(NSString *)forKey {
    if (_cbStrings == nil) {
        [self initializeStrings];
    }
    NSDictionary *strDictionary = nil;
    NSString *strValue = nil;
    strDictionary = [_cbStrings objectForKey:@"AlertMessage"];
    strValue = [strDictionary objectForKey:forKey];
    if (strValue == nil) {
        strValue = @"";
    }
    return strValue;
}

- (NSString *)getPageTitle:(NSString *)forKey {
    if (_cbStrings == nil) {
        [self initializeStrings];
    }
    NSDictionary *strDictionary = nil;
    NSString *strValue = nil;
    strDictionary = [_cbStrings objectForKey:@"PageTitles"];
    strValue = [strDictionary objectForKey:forKey];
    if (strValue == nil) {
        strValue = @"";
    }
    return strValue;
}

@end