#include <cstdio>

namespace Address
{
    const int MAX_FILE_SIZE = 0x400000;
    const unsigned int BANK_SIZE = 0x08000;

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

    inline unsigned int get_index(unsigned char bank, unsigned int pc)
    {
        return bank * BANK_SIZE + pc - 0x08000;
    }

    inline char read_char(FILE * stream)
    {
        char c;
        fread(&c, 1, 1, stream);
        return c;
    }

    std::string to_string(int i, int length, bool in_hex = true);
}

namespace Input
{
    bool is_comment(const std::string& line);
}
