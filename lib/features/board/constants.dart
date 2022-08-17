// NOTE: https://en.wikipedia.org/wiki/Hamming_weight
//binary: 0101...
final m1 = BigInt.parse('0x5555555555555555');
//binary: 00110011..
final m2 = BigInt.parse('0x3333333333333333');
//binary:  4 zeros,  4 ones ...
final m4 = BigInt.parse('0x0f0f0f0f0f0f0f0f');
//binary:  8 zeros,  8 ones ...
final m8 = BigInt.parse('0x00ff00ff00ff00ff');
//binary: 16 zeros, 16 ones ...
final m16 = BigInt.parse('0x0000ffff0000ffff');
//binary: 32 zeros, 32 ones
final m32 = BigInt.parse('0x00000000ffffffff');
//the sum of 256 to the power of 0,1,2,3...
final h01 = BigInt.parse('0x0101010101010101');

final initWBits = BigInt.parse('0x0000001008000000');
final initBBits = BigInt.parse('0x0000000810000000');

final one = BigInt.one;
final zero = BigInt.zero;

const turnBlack = 0;
const turnWhite = 1;
