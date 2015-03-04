#include <string>
#include <map>
#include <memory>

struct AnnotationProvider
{
    virtual std::string get_annotation(int opcode, bool is_accum_16, bool is_index_16, bool is_symbolic_address) = 0;
    virtual ~AnnotationProvider() = 0;
};

struct DefaultAnnotations : public AnnotationProvider
{
    DefaultAnnotations();
    virtual std::string get_annotation(int opcode, bool is_accum_16, bool is_index_16, bool is_symbolic_address);
private:
    typedef std::string(*HandlerPtr)(bool, bool, bool);
    std::map<int, HandlerPtr> m_handlers;
};

struct SmasAnnotations : public AnnotationProvider
{
    SmasAnnotations();
    virtual std::string get_annotation(int opcode, bool is_accum_16, bool is_index_16, bool is_symbolic_address);
private:
    typedef std::string(*HandlerPtr)(bool, bool, bool);
    std::map<int, HandlerPtr> m_handlers;
};

std::shared_ptr<AnnotationProvider> CreateAnnotationProvider(const std::string& type);
