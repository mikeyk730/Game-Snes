#include <string>

namespace Annotation
{
    inline std::string Word(bool is_accum_16, bool is_index_16){
        return ".W";
    }

    inline std::string AccumDependentWord(bool is_accum_16, bool is_index_16){
        return (is_accum_16 ? ".W" : ".B");
    }

    inline std::string IndexDependentWord(bool is_accum_16, bool is_index_16){
        return (is_index_16 ? ".W" : ".B");
    }

    inline std::string Long(bool is_accum_16, bool is_index_16){
        return ".L";
    }
}