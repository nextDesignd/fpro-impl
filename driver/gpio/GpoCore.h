#ifndef GPOCORE_H
#define GPOCORE_H

#include <stdint.h>

class GpoCore {
    enum {
        DATA_REG = 0
    };

    public:
        GpoCore(uint32_t core_base_addr);
        ~GpoCore();

        void write(uint32_t data);
        void write(int bit_value, int bit_pos);

    private:
        uint32_t base_addr;
        uint32_t wr_data;

};
#endif
