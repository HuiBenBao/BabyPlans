//
//  NSString+Category.m
//  BabyPlans
//
//  Created by apple on 16/4/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "NSString+Category.h"
#include <regex.h>
#import <CommonCrypto/CommonDigest.h>


@implementation NSString (Category)

- (NSString *)trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
- (BOOL)isValidPhoneNo {
    NSString *phoneExpression=[NSString stringWithUTF8String:"^1[123456789][0-9]{9}$"];
    return [self grep:phoneExpression options:REG_ICASE] ? YES : NO;
}
-(BOOL) grep:(NSString*)pattern options:(int)options
{
    //NSLog(@"NSString_RegEx - grep");
    
    NSArray * substrings = [self substringsMatchingRegularExpression:pattern count:-1 options:options ranges:NULL error:NULL];
    return (substrings && [substrings count] > 0);
}

- (BOOL)isNumber {
    NSScanner *sc = [NSScanner scannerWithString: self];
    // We can pass NULL because we don't actually need the value to test
    // for if the string is numeric. This is allowable.
    if ( [sc scanFloat:NULL] ) {
        // Ensure nothing left in scanner so that "42foo" is not accepted.
        // ("42" would be consumed by scanFloat above leaving "foo".)
        return [sc isAtEnd];
    }
    // Couldn't even scan a float :(
    return NO;
}


-(NSArray*) substringsMatchingRegularExpression:(NSString*)pattern count:(int)nmatch options:(int)options ranges:(NSArray**)ranges error:(NSError**)error
{
    // NSLog(@"NSString_RegEx - substringsMatchingRegularExpression");
    
    options |= REG_EXTENDED;
    if(error)
        *error = nil;
    
    int errcode = 0;
    regex_t preg;
    regmatch_t * pmatch = NULL;
    NSMutableArray * outMatches = nil;
    
    // Compile the regular expression
    errcode = regcomp(&preg, [pattern UTF8String], options);
    if(errcode != 0)
        goto catch_error;	// regcomp error
    
    // Match the regular expression against substring self
    pmatch = calloc(sizeof(regmatch_t), nmatch+1);
    errcode = regexec(&preg, [self UTF8String], (nmatch<0 ? 0 : nmatch+1), pmatch, 0);
    
    if(errcode != 0)
        goto catch_error;	// regexec error
    
    if(nmatch == -1)
    {
        outMatches = [NSMutableArray arrayWithArray:[NSArray arrayWithObject:self]];
        goto catch_exit;	// simple match
    }
    
    // Iterate through pmatch
    outMatches = [NSMutableArray array];
    if(ranges)
        *ranges = [NSMutableArray array];
    int i;
    for (i=0; i<nmatch+1; i++)
    {
        if(pmatch[i].rm_so == -1 || pmatch[i].rm_eo == -1)
            break;
        
        NSRange range = NSMakeRange((NSUInteger)pmatch[i].rm_so, (NSUInteger)(pmatch[i].rm_eo - pmatch[i].rm_so));
        NSString * substring = [self substringWithRange:range];
        [outMatches addObject:substring];
        
        if(ranges)
        {
            NSValue * value = [NSValue valueWithRange:range];
            [(NSMutableArray *)*ranges addObject:value];
        }
    }
    
catch_error:
    if(errcode != 0 && error)
    {
        // Construct error object
        NSMutableDictionary * userInfo = [NSMutableDictionary dictionary];
        char errbuf[256];
        NSInteger len = regerror(errcode, &preg, errbuf, sizeof(errbuf));
        if(len > 0)
            [userInfo setObject:[NSString stringWithUTF8String:errbuf] forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"regerror" code:errcode userInfo:userInfo];
    }
    
catch_exit:
    if(pmatch)
        free(pmatch);
    regfree(&preg);
    return outMatches;
}

- (NSString *)MD5String {
    // Get the c string from the NSString
    const char *cString = [self UTF8String];
    unsigned char result[16];
    
    // MD5 encryption
    CC_MD5( cString, (int)strlen(cString), result );
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
@end
