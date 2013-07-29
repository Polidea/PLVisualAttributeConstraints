//
//  Created by Kamil Jaworski on 29.07.2013.
//  kamil.jaworski@gmail.com
//


#import <Foundation/Foundation.h>

@interface PLMutableMetric : NSObject
@property (assign) CGFloat value;
+ (instancetype)metricWithValue:(CGFloat)value;
@end
