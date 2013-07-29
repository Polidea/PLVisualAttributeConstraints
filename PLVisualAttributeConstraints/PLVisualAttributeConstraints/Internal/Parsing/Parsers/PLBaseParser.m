//
//  Created by Kamil Jaworski on 29.07.2013.
//  kamil.jaworski@gmail.com
//


#import "PLBaseParser.h"
#import "PLAttributeConstraintVisualFormatLexerProtocol.h"

@implementation PLBaseParser {

}

+ (id)parserWithLexer:(id <PLAttributeConstraintVisualFormatLexerProtocol>)lexer {
    return [[self alloc] initWithLexer:lexer];
}

- (id)initWithLexer:(id <PLAttributeConstraintVisualFormatLexerProtocol>)lexer {
    self = [super init];
    if (self) {
        _lexer = lexer;
        _parsedWithSuccess = NO;
    }
    return self;
}

- (BOOL)parsedWithSuccess {
    return _parsedWithSuccess;
}

- (BOOL)parseSuppressingFailure {
    NSAssert(_lexer != nil, @"PLBaseParser: no lexer provided.", nil);
    return [self __parseReportingErrorOnFailure:NO];
}

- (BOOL)parseReportingFailure {
    NSAssert(_lexer != nil, @"PLBaseParser: no lexer provided.", nil);
    return [self __parseReportingErrorOnFailure:YES];
}

- (BOOL)__parseReportingErrorOnFailure:(BOOL)reportErrorOnFailure {
    @throw [NSException exceptionWithName:@"PLBaseParser"
                                   reason:@"You should override this method"
                                 userInfo:nil];
}

@end
