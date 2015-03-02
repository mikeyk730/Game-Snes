#include <string>
#include <map>

struct AnnotationProvider
{
    virtual std::string get_annotation(int opcode, bool is_accum_16, bool is_index_16, bool is_symbolic_address) = 0;
    virtual ~AnnotationProvider() = 0;
};

struct DefaultAnnotations : public AnnotationProvider
{
    DefaultAnnotations();
    virtual std::string get_annotation(int opcode, bool is_accum_16, bool is_index_16, bool is_symbolic_address);
    virtual ~DefaultAnnotations();
private:
    typedef std::string(*HandlerPtr)(bool, bool, bool);
    std::map<int, HandlerPtr> m_handlers;
};
