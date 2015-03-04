#include <string>

//todo: make POD for fast initialization
struct ByteProperties
{
    ByteProperties();

    unsigned char type() const { return m_type; }
    void type(unsigned char t) { m_type = t; }

    unsigned char data_bank() const { return m_data_bank; }
    void data_bank(unsigned char d) { m_data_bank = d; }

    std::string comment() const { return m_comment; }
    void comment(const std::string& c) { m_comment = c; }

    std::string label() const { return m_label; }
    void label(const std::string& l) { m_label = l; }

    int load_offset() const { return m_load_offset; }
    void load_offset(int o) { m_load_offset = o; }

    int reset_index_to;
    int reset_accum_to;

private:
    int m_type;
    int m_load_offset;
    std::string m_comment;
    std::string m_label;
    unsigned char m_data_bank;
};
