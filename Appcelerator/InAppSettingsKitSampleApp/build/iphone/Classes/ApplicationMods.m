#import "ApplicationMods.h"

@implementation ApplicationMods

+ (NSArray*) compiledMods
{
	NSMutableArray *modules = [NSMutableArray array];
	[modules addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"inappsettingskit",@"name",@"com.inappsettingskit.inappsettingskit",@"moduleid",@"1.0",@"version",@"0e715eb6-95fc-4096-b545-38b2f29f1479",@"guid",@"",@"licensekey",nil]];
	return modules;
}

@end
