//
//  ServerDataUtil.h
//  XPlan
//
//  Created by Hex on 4/3/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SWAP16(x) \
((uint16_t)((((uint16_t)(x) & 0xff00) >> 8) | \
(((uint16_t)(x) & 0x00ff) << 8)))

#define SWAP32(x) \
((uint32_t)((((uint32_t)(x) & 0xff000000) >> 24) | \
(((uint32_t)(x) & 0x00ff0000) >>  8) | \
(((uint32_t)(x) & 0x0000ff00) <<  8) | \
(((uint32_t)(x) & 0x000000ff) << 24)))

#define SWAP64(x) \
((uint64_t)((((uint64_t)(x) & 0xff00000000000000ULL) >> 56) | \
(((uint64_t)(x) & 0x00ff000000000000ULL) >> 40) | \
(((uint64_t)(x) & 0x0000ff0000000000ULL) >> 24) | \
(((uint64_t)(x) & 0x000000ff00000000ULL) >>  8) | \
(((uint64_t)(x) & 0x00000000ff000000ULL) <<  8) | \
(((uint64_t)(x) & 0x0000000000ff0000ULL) << 24) | \
(((uint64_t)(x) & 0x000000000000ff00ULL) << 40) | \
(((uint64_t)(x) & 0x00000000000000ffULL) << 56)))


#if BYTE_ORDER == LITTLE_ENDIAN
#define BSONTOHOST16(x) (x)
#define BSONTOHOST32(x) (x)
#define BSONTOHOST64(x) (x)
#define HOSTTOBSON16(x) (x)
#define HOSTTOBSON32(x) (x)
#define HOSTTOBSON64(x) (x)

#elif BYTE_ORDER == BIG_ENDIAN
#define BSONTOHOST16(x) SWAP16(x)
#define BSONTOHOST32(x) SWAP32(x)
#define BSONTOHOST64(x) SWAP64(x)
#define HOSTTOBSON16(x) SWAP16(x)
#define HOSTTOBSON32(x) SWAP16(x)
#define HOSTTOBSON64(x) SWAP16(x)

#endif