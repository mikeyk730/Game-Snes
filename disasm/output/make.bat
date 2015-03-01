rm all.smc
rm *.o
..\bin\wla.exe -vo b0.asm b0.o
..\bin\wla.exe -vo b1.asm b1.o
..\bin\wla.exe -vo b2.asm b2.o
..\bin\wla.exe -vo b3.asm b3.o
..\bin\wla.exe -vo b3.asm b3.o
..\bin\wla.exe -vo b4.asm b4.o
..\bin\wla.exe -vo b5.asm b5.o
..\bin\wla.exe -vo b6.asm b6.o
..\bin\wla.exe -vo b7.asm b7.o
..\bin\wla.exe -vo b8.asm b8.o
..\bin\wla.exe -vo b9.asm b9.o
..\bin\wla.exe -vo bA.asm bA.o
..\bin\wla.exe -vo bB.asm bB.o
..\bin\wla.exe -vo bC.asm bC.o
..\bin\wla.exe -vo bD.asm bD.o
..\bin\wla.exe -vo bE.asm bE.o
..\bin\wla.exe -vo bF.asm bF.o
..\bin\wlalink.exe -dvr smw.proj all.smc

