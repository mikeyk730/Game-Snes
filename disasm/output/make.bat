rm all.smc
rm *.o
wla -vo b0.asm b0.o
wla -vo b1.asm b1.o
wla -vo b2.asm b2.o
wla -vo b3.asm b3.o
wla -vo b3.asm b3.o
wla -vo b4.asm b4.o
wla -vo b5.asm b5.o
wla -vo b6.asm b6.o
wla -vo b7.asm b7.o
wla -vo b8.asm b8.o
wla -vo b9.asm b9.o
wla -vo bA.asm bA.o
wla -vo bB.asm bB.o
wla -vo bC.asm bC.o
wla -vo bD.asm bD.o
wla -vo bE.asm bE.o
wla -vo bF.asm bF.o
wlalink -dvr smw.proj all.smc

