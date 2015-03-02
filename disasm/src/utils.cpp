#include <iomanip>
#include <string>
#include <sstream>
#include "utils.h"

using namespace std;

namespace Address
{
    string to_string(int i, int length, bool in_hex)
    {
        ostringstream ss;
        ss.setf(ios::uppercase);

        if (in_hex)
            ss << hex << setfill('0') << setw(length) << i;
        else
            ss << dec << setfill('0') << setw(length) << i;

        return ss.str();
    }
}

namespace Input
{
    bool is_comment(const string& line)
    {
        return (line.length() < 1 || line[0] == ';');
    }
}
