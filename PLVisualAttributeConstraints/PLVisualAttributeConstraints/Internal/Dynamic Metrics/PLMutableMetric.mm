//
//  Created by Kamil Jaworski on 29.07.2013.
//  kamil.jaworski@gmail.com
//


#import "PLMutableMetric.h"

@implementation PLMutableMetric {

}

+ (instancetype)metricWithValue:(CGFloat)value {
    return [[self alloc] initWithValue:value];
}

- (instancetype)initWithValue:(CGFloat)value {
    self = [super init];
    if (self) {
        self.value = value;
    }
    return self;
}



@end
