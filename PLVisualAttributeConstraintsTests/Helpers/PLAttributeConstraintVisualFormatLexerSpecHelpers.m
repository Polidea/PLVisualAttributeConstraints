/*

 Copyright (c) 2013, Kamil Jaworski, Polidea
 All rights reserved.

 mailto: kamil.jaworski@gmail.com

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 * Neither the name of the Polidea nor the
 names of its contributors may be used to endorse or promote products
 derived from this software without specific prior written permission.

 THIS SOFTWARE IS PROVIDED BY KAMIL JAWORSKI, POLIDEA ''AS IS'' AND ANY
 EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL KAMIL JAWORSKI, POLIDEA BE LIABLE FOR ANY
 DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

 */


#import "PLAttributeConstraintVisualFormatLexerSpecHelpers.h"
#import "PLAttributeConstraintVisualFormatLexer.h"
#import "PLAttributeConstraintVisualFormatAtom.h"
#import "Kiwi.h"

@implementation PLAttributeConstraintVisualFormatLexerSpecHelpers {

}

+ (BOOL)assertLexer:(PLAttributeConstraintVisualFormatLexer *)lexer returnsAtomsTypesInOrder:(NSArray *)atomsArray {
    PLAttributeConstraintVisualFormatAtom *atom = nil;
    for (int j = 0; j < atomsArray.count; j++) {
        atom = [lexer next];
        NSInteger expectedAtomTypeIntegerValue = [atomsArray[(NSUInteger) j] integerValue];
        if (atom.atomType != expectedAtomTypeIntegerValue) {
            NSLog(@"Format: %@ Expected atom type: %@, received atom: %@",
                    lexer.text,
                    [PLAttributeConstraintVisualFormatAtom atomNameForAtomType:(PLAtomType) expectedAtomTypeIntegerValue],
                    atom);
            return false;
        }
    }
    return true;
}

//
// Input: array of arrays. Each of inner arrays describe ONE expected atom
//
// Sample 'expected atom array':
//      expected atom type      atom string data    optional starting index
//  @[@(PLAtomTypeIdentifier), @"controlName",      @(23)]
//

+ (BOOL)atom:(PLAttributeConstraintVisualFormatAtom *)atom matchesExpectedAtomDescription:(NSArray *)atomDescriptionArray {

    NSInteger expectedAtomTypeIntegerValue = [atomDescriptionArray[0] integerValue];
    NSString *expectedAtomStringData = atomDescriptionArray[1] == [NSNull null] ? nil : atomDescriptionArray[1];
    NSNumber *optionalExpectedStartIndex = atomDescriptionArray.count > 2 ? atomDescriptionArray[2] : nil;

    assert(expectedAtomStringData == nil || [expectedAtomStringData isKindOfClass:[NSString class]]);

    if (expectedAtomTypeIntegerValue != atom.atomType) {
        NSLog(@"Expected atom type: %@", [PLAttributeConstraintVisualFormatAtom atomNameForAtomType:(PLAtomType) expectedAtomTypeIntegerValue]);
        NSLog(@"Got atom: %@", atom);
        return NO;
    }

    if (expectedAtomStringData == nil && atom.stringData != nil) {
        NSLog(@"Unexpected string data (expected nil): %@", atom.stringData);
        NSLog(@"Got atom: %@", atom);
        return NO;
    }

    if (expectedAtomStringData != nil && ![atom.stringData isEqualToString:expectedAtomStringData]) {
        NSLog(@"Expected atom string data: %@", expectedAtomStringData);
        NSLog(@"Got atom: %@", atom);
        return NO;
    }

    if (optionalExpectedStartIndex && atom.startIndex != [optionalExpectedStartIndex unsignedIntegerValue]) {
        NSLog(@"Expected atom start index: %@", @([optionalExpectedStartIndex unsignedIntegerValue]));
        NSLog(@"Got atom: %@", atom);
        return NO;
    }

    return YES;

}

+ (NSString *)arrowUpStringWithLength:(NSUInteger)length {
    NSMutableString *arrowString = [NSMutableString stringWithCapacity:length];
    for (int j = 0; j < length; j++) {
        [arrowString appendString:(j % 2 == 0) ? @"-" : @" "];
    }
    if (length > 0)[arrowString appendString:@"^"];
    return arrowString;
}

+ (BOOL)assertLexer:(PLAttributeConstraintVisualFormatLexer *)lexer returnsAtomsTypesAndStringDataInOrder:(NSArray *)atomTypeStringDataEntriesArray {

    PLAttributeConstraintVisualFormatAtom *atom = nil;

    for (int j = 0; j < atomTypeStringDataEntriesArray.count; j++) {
        NSArray *currentTemplatePair = atomTypeStringDataEntriesArray[(NSUInteger) j];

        atom = [lexer next];

        if (![self atom:atom matchesExpectedAtomDescription:currentTemplatePair]) {
            NSLog(@"Format:");
            NSLog(@"%@", lexer.text);
            NSLog(@"%@", [self arrowUpStringWithLength:atom.startIndex]);
            return NO;
        }

    }

    return YES;

}

@end
