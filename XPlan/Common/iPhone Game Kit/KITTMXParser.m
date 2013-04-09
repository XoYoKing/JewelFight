//
//  See the file 'LICENSE_iPhoneGameKit.txt' for the license governing this code.
//      The license can also be obtained online at:
//          http://www.iPhoneGameKit.com/license
//

#import "iPhoneGameKit.h"
#import <objc/runtime.h>  

//
// this turns standard TMX files into HD by loading hires versions of tileset images,
// scaling up tile sizes, and scaling up dimensions and positions
// 
// differences from Cocos2D's CCTMXXMLParser.m are noted by "KIT:" comments
//
@implementation CCTMXMapInfo (KIT)

#if kKITAutoHDTMXFiles

+(void) load
{
	//
	// latest versions of xcode complain when overriding superclass
	// methods with a category, so use method swizzling:
	// http://pilky.me/view/21
	//
    method_exchangeImplementations(
		class_getInstanceMethod(self, @selector(parseXMLFile:)),
		class_getInstanceMethod(self, @selector(autoParseXMLFile:)));
	
    method_exchangeImplementations(
		class_getInstanceMethod(self, @selector(parser:didStartElement:namespaceURI:qualifiedName:attributes:)),
		class_getInstanceMethod(self, @selector(autoParser:didStartElement:namespaceURI:qualifiedName:attributes:)));
}

- (void) autoParseXMLFile:(NSString *)xmlFilename
{
	NSURL *url = [NSURL fileURLWithPath:[[CCFileUtils sharedFileUtils] fullPathFromRelativePath:xmlFilename] ];
	
	NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
	
	// we'll do the parsing
	[parser setDelegate:self];
	[parser setShouldProcessNamespaces:NO];
	[parser setShouldReportNamespacePrefixes:NO];
	[parser setShouldResolveExternalEntities:NO];
	[parser parse];

	KITAssert1( ! [parser parserError], @"Error parsing file: %@.", xmlFilename );

	[parser release];
}

// the XML parser calls here with all the elements
-(void)autoParser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{	
	// KIT: added these variables
	BOOL isHD = [KITApp isHD];
    BOOL isDoubleHD = [KITApp isDoubleHD];
	float scaleFactor = ([KITApp isDoubleHD] || [KITApp isHDNonRetina] ? 2.0f : 1.0f);
    CGSize tileSizeInPoints = tileSize_;
    if (isDoubleHD)
    {
        tileSizeInPoints.width *= 0.25f;
        tileSizeInPoints.height *= 0.25f;
    }
	else if( isHD )
	{
		tileSizeInPoints.width *= 0.5f;
		tileSizeInPoints.height *= 0.5f;
	}

	if([elementName isEqualToString:@"map"]) {
		NSString *version = [attributeDict valueForKey:@"version"];
		if( ! [version isEqualToString:@"1.0"] )
			CCLOG(@"cocos2d: TMXFormat: Unsupported TMX version: %@", version);
		NSString *orientationStr = [attributeDict valueForKey:@"orientation"];
		if( [orientationStr isEqualToString:@"orthogonal"])
			orientation_ = CCTMXOrientationOrtho;
		else if ( [orientationStr isEqualToString:@"isometric"])
			orientation_ = CCTMXOrientationIso;
		else if( [orientationStr isEqualToString:@"hexagonal"])
			orientation_ = CCTMXOrientationHex;
		else
			CCLOG(@"cocos2d: TMXFomat: Unsupported orientation: %d", orientation_);

		mapSize_.width = [[attributeDict valueForKey:@"width"] intValue];
		mapSize_.height = [[attributeDict valueForKey:@"height"] intValue];
		tileSize_.width = [[attributeDict valueForKey:@"tilewidth"] intValue];
		tileSize_.height = [[attributeDict valueForKey:@"tileheight"] intValue];
		// KIT: scale up the tileSize
        
		if( isDoubleHD )
		{
            tileSize_.width *= 4.0f;
            tileSize_.height *= 4.0f;
        }
        else if (isHD)
        {
			tileSize_.width *= 2.0f;
			tileSize_.height *= 2.0f;
		}
        

		// The parent element is now "map"
		parentElement = TMXPropertyMap;
	} else if([elementName isEqualToString:@"tileset"]) {
		
		// If this is an external tileset then start parsing that
		NSString *externalTilesetFilename = [attributeDict valueForKey:@"source"];
		if (externalTilesetFilename) {
				// Tileset file will be relative to the map file. So we need to convert it to an absolute path
				NSString *dir = [filename_ stringByDeletingLastPathComponent];	// Directory of map file
				externalTilesetFilename = [dir stringByAppendingPathComponent:externalTilesetFilename];	// Append path to tileset file
				
				[self autoParseXMLFile:externalTilesetFilename];
		} else {
				
			CCTMXTilesetInfo *tileset = [CCTMXTilesetInfo new];
			tileset.name = [attributeDict valueForKey:@"name"];
			tileset.firstGid = [[attributeDict valueForKey:@"firstgid"] intValue];
			tileset.spacing = [[attributeDict valueForKey:@"spacing"] intValue];
			tileset.margin = [[attributeDict valueForKey:@"margin"] intValue];
			CGSize s;
			s.width = [[attributeDict valueForKey:@"tilewidth"] intValue];
			s.height = [[attributeDict valueForKey:@"tileheight"] intValue];
            if (isDoubleHD)
            {
                s.width *= 4.0f;
                s.height *= 4.0f;
            }
			else if( isHD )
			{
				s.width *= 2.0f;
				s.height *= 2.0f;
			}
			tileset.tileSize = s;
			
			[tilesets_ addObject:tileset];
			[tileset release];
		}

	}else if([elementName isEqualToString:@"tile"]){
		CCTMXTilesetInfo* info = [tilesets_ lastObject];
		NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:3];
		parentGID_ =  [info firstGid] + [[attributeDict valueForKey:@"id"] intValue];
		[tileProperties_ setObject:dict forKey:[NSNumber numberWithInt:parentGID_]];
		
		parentElement = TMXPropertyTile;
		
	}else if([elementName isEqualToString:@"layer"]) {
		CCTMXLayerInfo *layer = [CCTMXLayerInfo new];
		layer.name = [attributeDict valueForKey:@"name"];
		
		CGSize s;
		s.width = [[attributeDict valueForKey:@"width"] intValue];
		s.height = [[attributeDict valueForKey:@"height"] intValue];
		layer.layerSize = s;
		
		layer.visible = ![[attributeDict valueForKey:@"visible"] isEqualToString:@"0"];
		
		if( [attributeDict valueForKey:@"opacity"] )
			layer.opacity = 255 * [[attributeDict valueForKey:@"opacity"] floatValue];
		else
			layer.opacity = 255;
		
		int x = [[attributeDict valueForKey:@"x"] intValue];
		int y = [[attributeDict valueForKey:@"y"] intValue];
		layer.offset = ccp(x,y);
		
		[layers_ addObject:layer];
		[layer release];
		
		// The parent element is now "layer"
		parentElement = TMXPropertyLayer;
	
	} else if([elementName isEqualToString:@"objectgroup"]) {
		
		CCTMXObjectGroup *objectGroup = [[CCTMXObjectGroup alloc] init];
		objectGroup.groupName = [attributeDict valueForKey:@"name"];
		CGPoint positionOffset;
		// KIT: scale up object group positions and use tile size in points
		positionOffset.x = [[attributeDict valueForKey:@"x"] intValue] * tileSizeInPoints.width * scaleFactor;
		positionOffset.y = [[attributeDict valueForKey:@"y"] intValue] * tileSizeInPoints.height * scaleFactor;
		objectGroup.positionOffset = positionOffset;
		
		[objectGroups_ addObject:objectGroup];
		[objectGroup release];
		
		// The parent element is now "objectgroup"
		parentElement = TMXPropertyObjectGroup;
			
	} else if([elementName isEqualToString:@"image"]) {

		CCTMXTilesetInfo *tileset = [tilesets_ lastObject];
		
		// build full path
		NSString *imagename = [attributeDict valueForKey:@"source"];		
		NSString *path = [filename_ stringByDeletingLastPathComponent];		
		// KIT: use hires version of tileset image
		tileset.sourceImage = [path stringByAppendingPathComponent:imagename];
		KITAssert1([KITApp resourceExists:tileset.sourceImage], @"Tileset is missing: %@", tileset.sourceImage);

	} else if([elementName isEqualToString:@"data"]) {
		NSString *encoding = [attributeDict valueForKey:@"encoding"];
		NSString *compression = [attributeDict valueForKey:@"compression"];
		
		if( [encoding isEqualToString:@"base64"] ) {
			layerAttribs |= TMXLayerAttribBase64;
			storingCharacters = YES;
			
			if( [compression isEqualToString:@"gzip"] )
				layerAttribs |= TMXLayerAttribGzip;

			else if( [compression isEqualToString:@"zlib"] )
				layerAttribs |= TMXLayerAttribZlib;

			KITAssert( !compression || [compression isEqualToString:@"gzip"] || [compression isEqualToString:@"zlib"], @"TMX: unsupported compression method" );
		}
		
		KITAssert( layerAttribs != TMXLayerAttribNone, @"TMX tile map: Only base64 and/or gzip/zlib maps are supported" );
		
	} else if([elementName isEqualToString:@"object"]) {
	
		CCTMXObjectGroup *objectGroup = [objectGroups_ lastObject];
		
		// The value for "type" was blank or not a valid class name
		// Create an instance of TMXObjectInfo to store the object and its properties
		NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:5];
		
		// Set the name of the object to the value for "name"
		[dict setValue:[attributeDict valueForKey:@"name"] forKey:@"name"];
		
		// Assign all the attributes as key/name pairs in the properties dictionary
		[dict setValue:[attributeDict valueForKey:@"type"] forKey:@"type"];
		// KIT: scale up object position.x
		int x = [[attributeDict valueForKey:@"x"] intValue]*scaleFactor + objectGroup.positionOffset.x;
		[dict setValue:[NSNumber numberWithInt:x] forKey:@"x"];
		// KIT: scale up object position.y
		int y = [[attributeDict valueForKey:@"y"] intValue]*scaleFactor + objectGroup.positionOffset.y;
		// Correct y position. (Tiled uses Flipped, cocos2d uses Standard)
		// KIT: multiply in scale factor and use tile size in points
		y = (mapSize_.height * tileSizeInPoints.height * scaleFactor) - y - [[attributeDict valueForKey:@"height"] intValue]*scaleFactor;
		[dict setValue:[NSNumber numberWithInt:y] forKey:@"y"];
		// KIT: scale up object width and height
		int width = [[attributeDict valueForKey:@"width"] intValue]*scaleFactor;
		int height = [[attributeDict valueForKey:@"height"] intValue]*scaleFactor;
		[dict setValue:[NSNumber numberWithInt:width] forKey:@"width"];
		[dict setValue:[NSNumber numberWithInt:height] forKey:@"height"];
		
		// Add the object to the objectGroup
		[[objectGroup objects] addObject:dict];
		[dict release];
		
		// The parent element is now "object"
		parentElement = TMXPropertyObject;
		
	} else if([elementName isEqualToString:@"property"]) {
	
		if ( parentElement == TMXPropertyNone ) {
		
			CCLOG( @"TMX tile map: Parent element is unsupported. Cannot add property named '%@' with value '%@'",
			[attributeDict valueForKey:@"name"], [attributeDict valueForKey:@"value"] );
			
		} else if ( parentElement == TMXPropertyMap ) {
		
			// The parent element is the map
			[properties_ setValue:[attributeDict valueForKey:@"value"] forKey:[attributeDict valueForKey:@"name"]];
			
		} else if ( parentElement == TMXPropertyLayer ) {
		
			// The parent element is the last layer
			CCTMXLayerInfo *layer = [layers_ lastObject];
			// Add the property to the layer
			[[layer properties] setValue:[attributeDict valueForKey:@"value"] forKey:[attributeDict valueForKey:@"name"]];
			
		} else if ( parentElement == TMXPropertyObjectGroup ) {
			
			// The parent element is the last object group
			CCTMXObjectGroup *objectGroup = [objectGroups_ lastObject];
			[[objectGroup properties] setValue:[attributeDict valueForKey:@"value"] forKey:[attributeDict valueForKey:@"name"]];
			
		} else if ( parentElement == TMXPropertyObject ) {
			
			// The parent element is the last object
			CCTMXObjectGroup *objectGroup = [objectGroups_ lastObject];
			NSMutableDictionary *dict = [[objectGroup objects] lastObject];
			
			NSString *propertyName = [attributeDict valueForKey:@"name"];
			NSString *propertyValue = [attributeDict valueForKey:@"value"];

			[dict setValue:propertyValue forKey:propertyName];
		} else if ( parentElement == TMXPropertyTile ) {
			
			NSMutableDictionary* dict = [tileProperties_ objectForKey:[NSNumber numberWithInt:parentGID_]];
			NSString *propertyName = [attributeDict valueForKey:@"name"];
			NSString *propertyValue = [attributeDict valueForKey:@"value"];
			[dict setObject:propertyValue forKey:propertyName];
			
		}
	}
}

#endif

@end
