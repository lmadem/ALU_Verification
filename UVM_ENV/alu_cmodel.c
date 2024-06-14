#include <svdpi.h>


unsigned int alu_dpi_model (unsigned int opa, unsigned int opb, unsigned int op, unsigned int width)
{
  switch (op) {
    case 0: return opa + opb;
    case 1: {
      if(opa >= opb)
        return opa - opb;
      else
        return opb - opa;
    }
    case 2: return opa * opb;
    case 3: return opa / opb;
    case 4: return opa | opb;
    case 5: return opa & opb;
    case 6: return (opa == opb) ? 1 : 0;
    case 7: {
      unsigned int shifted_opa = opa << 1;
      unsigned int shifted_opb = opb >> 1;
      unsigned int combined = (shifted_opa << width) | (shifted_opb & (1 << width) - 1);
      return combined;
  default: return 0;
  }
  return 0;
}
}
