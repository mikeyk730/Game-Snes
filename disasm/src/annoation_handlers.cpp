#include <string>
#include "annotation_handlers.h"

using namespace std;

namespace
{
    inline std::string Word(bool is_accum_16, bool is_index_16, bool is_symbolic_address){
        return ".W";
    }

    inline std::string AccumDependentWord(bool is_accum_16, bool is_index_16, bool is_symbolic_address){
        return (is_accum_16 ? ".W" : ".B");
    }

    inline std::string IndexDependentWord(bool is_accum_16, bool is_index_16, bool is_symbolic_address){
        return (is_index_16 ? ".W" : ".B");
    }

    inline std::string Long(bool is_accum_16, bool is_index_16, bool is_symbolic_address){
        return ".L";
    }
}

AnnotationProvider::~AnnotationProvider()
{ }

DefaultAnnotations::DefaultAnnotations()
{
    m_handlers.insert(make_pair(0x69, &AccumDependentWord));
    m_handlers.insert(make_pair(0x6D, &Word));
    m_handlers.insert(make_pair(0x6F, &Long));
    m_handlers.insert(make_pair(0x7D, &Word));
    m_handlers.insert(make_pair(0x7F, &Long));
    m_handlers.insert(make_pair(0x79, &Word));
    m_handlers.insert(make_pair(0x29, &AccumDependentWord));
    m_handlers.insert(make_pair(0x2D, &Word));
    m_handlers.insert(make_pair(0x2F, &Long));
    m_handlers.insert(make_pair(0x3D, &Word));
    m_handlers.insert(make_pair(0x3F, &Long));
    m_handlers.insert(make_pair(0x39, &Word));
    m_handlers.insert(make_pair(0x0E, &Word));
    m_handlers.insert(make_pair(0x1E, &Word));
    m_handlers.insert(make_pair(0x89, &AccumDependentWord));
    m_handlers.insert(make_pair(0x2C, &Word));
    m_handlers.insert(make_pair(0x3C, &Word));
    m_handlers.insert(make_pair(0xC9, &AccumDependentWord));
    m_handlers.insert(make_pair(0xCD, &Word));
    m_handlers.insert(make_pair(0xCF, &Long));
    m_handlers.insert(make_pair(0xDD, &Word));
    m_handlers.insert(make_pair(0xDF, &Long));
    m_handlers.insert(make_pair(0xD9, &Word));
    m_handlers.insert(make_pair(0xE0, &IndexDependentWord));
    m_handlers.insert(make_pair(0xEC, &Word));
    m_handlers.insert(make_pair(0xC0, &IndexDependentWord));
    m_handlers.insert(make_pair(0xCC, &Word));
    m_handlers.insert(make_pair(0xCE, &Word));
    m_handlers.insert(make_pair(0xDE, &Word));
    m_handlers.insert(make_pair(0x49, &AccumDependentWord));
    m_handlers.insert(make_pair(0x4D, &Word));
    m_handlers.insert(make_pair(0x4F, &Long));
    m_handlers.insert(make_pair(0x5D, &Word));
    m_handlers.insert(make_pair(0x5F, &Long));
    m_handlers.insert(make_pair(0x59, &Word));
    m_handlers.insert(make_pair(0xEE, &Word));
    m_handlers.insert(make_pair(0xFE, &Word));
    m_handlers.insert(make_pair(0x5C, &Long));
    m_handlers.insert(make_pair(0x4C, &Word));
    m_handlers.insert(make_pair(0x22, &Long));
    m_handlers.insert(make_pair(0x20, &Word));
    m_handlers.insert(make_pair(0xA9, &AccumDependentWord));
    m_handlers.insert(make_pair(0xAD, &Word));
    m_handlers.insert(make_pair(0xAF, &Long));
    m_handlers.insert(make_pair(0xBD, &Word));
    m_handlers.insert(make_pair(0xBF, &Long));
    m_handlers.insert(make_pair(0xB9, &Word));
    m_handlers.insert(make_pair(0xA2, &IndexDependentWord));
    m_handlers.insert(make_pair(0xAE, &Word));
    m_handlers.insert(make_pair(0xBE, &Word));
    m_handlers.insert(make_pair(0xA0, &IndexDependentWord));
    m_handlers.insert(make_pair(0xAC, &Word));
    m_handlers.insert(make_pair(0xBC, &Word));
    m_handlers.insert(make_pair(0x4E, &Word));
    m_handlers.insert(make_pair(0x5E, &Word));
    m_handlers.insert(make_pair(0x09, &AccumDependentWord));
    m_handlers.insert(make_pair(0x0D, &Word));
    m_handlers.insert(make_pair(0x0F, &Long));
    m_handlers.insert(make_pair(0x1D, &Word));
    m_handlers.insert(make_pair(0x1F, &Long));
    m_handlers.insert(make_pair(0x19, &Word));
    m_handlers.insert(make_pair(0x2E, &AccumDependentWord));
    m_handlers.insert(make_pair(0x3E, &Word));
    m_handlers.insert(make_pair(0x6E, &Word));
    m_handlers.insert(make_pair(0x7E, &Word));
    m_handlers.insert(make_pair(0xE9, &AccumDependentWord));
    m_handlers.insert(make_pair(0xED, &Word));
    m_handlers.insert(make_pair(0xEF, &Long));
    m_handlers.insert(make_pair(0xFD, &Word));
    m_handlers.insert(make_pair(0xFF, &Long));
    m_handlers.insert(make_pair(0xF9, &Word));
    m_handlers.insert(make_pair(0x8D, &Word));
    m_handlers.insert(make_pair(0x8F, &Long));
    m_handlers.insert(make_pair(0x9D, &Word));
    m_handlers.insert(make_pair(0x9F, &Long));
    m_handlers.insert(make_pair(0x99, &Word));
    m_handlers.insert(make_pair(0x8E, &Word));
    m_handlers.insert(make_pair(0x8C, &Word));
    m_handlers.insert(make_pair(0x9C, &Word));
    m_handlers.insert(make_pair(0x9E, &Word));
    m_handlers.insert(make_pair(0x1C, &Word));
    m_handlers.insert(make_pair(0x0C, &Word));
}
 
string DefaultAnnotations::get_annotation(int opcode, bool is_accum_16, bool is_index_16, bool is_symbolic_address)
{
    auto it = m_handlers.find(opcode);
    if (it != m_handlers.end()){
        auto handler = it->second;
        return (*handler)(is_accum_16, is_index_16, is_symbolic_address);
    }
    return "";
}

DefaultAnnotations::~DefaultAnnotations()
{ }
