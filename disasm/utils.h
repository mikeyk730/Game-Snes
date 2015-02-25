#include <cstdio>

namespace Address
{
    inline unsigned int address_16bit(unsigned char i, unsigned char j)
    {
        return j * 256 + i;
    }

    inline unsigned int address_24bit(unsigned char i, unsigned char j, unsigned char k)
    {
        return (k << 16) + (j << 8) + i;
    }

    inline unsigned int full_address(unsigned char bank, unsigned int pc){
        return bank * 65536 + pc;
    }

    inline unsigned char bank_from_addr24(unsigned int a)
    {
        return ((a >> 16) & 0x0FF);
    }

    inline unsigned int addr16_from_addr24(unsigned int a)
    {
        return (a & 0x0FFFF);
    }

    inline char read_char(FILE * stream)
    {
        char c;
        fread(&c, 1, 1, stream);
        return c;
    }
}