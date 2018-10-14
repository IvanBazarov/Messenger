//
//  Themes.m
//  Messenger
//
//  Created by Иван Базаров on 14.10.2018.
//  Copyright © 2018 Иван Базаров. All rights reserved.
//

#import "Themes.h"

@implementation Themes: NSObject

- (UIColor *)theme1 {
    return [UIColor redColor];
}

- (UIColor *)theme2 {
    return [UIColor blueColor];
}

- (UIColor *)theme3 {
    return [UIColor greenColor];
}

- (UIColor *)defaultColor {
    return [UIColor whiteColor];
}
@end
