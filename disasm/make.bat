rm output\*.log
rm output\*.asm
rm output\*.o
rm output\*.smc

echo  8000 100000 -e       | bin\disasm.exe --ram driver_files\all.ram --sym driver_files\all.sym --ptr driver_files\all.ptr --data driver_files\all.data --accum driver_files\all.flags --comment driver_files\all.comment --offsets driver_files\all.offsets --sym2 driver_files\all.trace bin\mario.smc 1> output\all.log 2>null

echo  8000  10000 -p -e -q | bin\disasm.exe --sym driver_files\all.sym --ptr driver_files\all.ptr --data driver_files\all.data --accum driver_files\all.flags --comment driver_files\all.comment --offsets driver_files\all.offsets --quiet bin\mario.smc 1> output\b0.asm 2> null
echo 18000  20000 -p -e -q | bin\disasm.exe --sym driver_files\all.sym --ptr driver_files\all.ptr --data driver_files\all.data --accum driver_files\all.flags --comment driver_files\all.comment --offsets driver_files\all.offsets --quiet bin\mario.smc 1> output\b1.asm 2> null
echo 28000  30000 -p -e -q | bin\disasm.exe --sym driver_files\all.sym --ptr driver_files\all.ptr --data driver_files\all.data --accum driver_files\all.flags --comment driver_files\all.comment --offsets driver_files\all.offsets --quiet bin\mario.smc 1> output\b2.asm 2> null
echo 38000  40000 -p -e -q | bin\disasm.exe --sym driver_files\all.sym --ptr driver_files\all.ptr --data driver_files\all.data --accum driver_files\all.flags --comment driver_files\all.comment --offsets driver_files\all.offsets --quiet bin\mario.smc 1> output\b3.asm 2> null
echo 48000  50000 -p -e -q | bin\disasm.exe --sym driver_files\all.sym --ptr driver_files\all.ptr --data driver_files\all.data --accum driver_files\all.flags --comment driver_files\all.comment --offsets driver_files\all.offsets --quiet bin\mario.smc 1> output\b4.asm 2> null
echo 58000  60000 -p -e -q | bin\disasm.exe --sym driver_files\all.sym --ptr driver_files\all.ptr --data driver_files\all.data --accum driver_files\all.flags --comment driver_files\all.comment --offsets driver_files\all.offsets --quiet bin\mario.smc 1> output\b5.asm 2> null
echo 68000  70000 -p -e -q | bin\disasm.exe --sym driver_files\all.sym --ptr driver_files\all.ptr --data driver_files\all.data --accum driver_files\all.flags --comment driver_files\all.comment --offsets driver_files\all.offsets --quiet bin\mario.smc 1> output\b6.asm 2> null
echo 78000  80000 -p -e -q | bin\disasm.exe --sym driver_files\all.sym --ptr driver_files\all.ptr --data driver_files\all.data --accum driver_files\all.flags --comment driver_files\all.comment --offsets driver_files\all.offsets --quiet bin\mario.smc 1> output\b7.asm 2> null
echo 88000  90000 -p -e -q | bin\disasm.exe --sym driver_files\all.sym --ptr driver_files\all.ptr --data driver_files\all.data --accum driver_files\all.flags --comment driver_files\all.comment --offsets driver_files\all.offsets --quiet bin\mario.smc 1> output\b8.asm 2> null
echo 98000  a0000 -p -e -q | bin\disasm.exe --sym driver_files\all.sym --ptr driver_files\all.ptr --data driver_files\all.data --accum driver_files\all.flags --comment driver_files\all.comment --offsets driver_files\all.offsets --quiet bin\mario.smc 1> output\b9.asm 2> null
echo a8000  b0000 -p -e -q | bin\disasm.exe --sym driver_files\all.sym --ptr driver_files\all.ptr --data driver_files\all.data --accum driver_files\all.flags --comment driver_files\all.comment --offsets driver_files\all.offsets --quiet bin\mario.smc 1> output\ba.asm 2> null
echo b8000  c0000 -p -e -q | bin\disasm.exe --sym driver_files\all.sym --ptr driver_files\all.ptr --data driver_files\all.data --accum driver_files\all.flags --comment driver_files\all.comment --offsets driver_files\all.offsets --quiet bin\mario.smc 1> output\bb.asm 2> null
echo c8000  d0000 -p -e -q | bin\disasm.exe --sym driver_files\all.sym --ptr driver_files\all.ptr --data driver_files\all.data --accum driver_files\all.flags --comment driver_files\all.comment --offsets driver_files\all.offsets --quiet bin\mario.smc 1> output\bc.asm 2> null
echo d8000  e0000 -p -e -q | bin\disasm.exe --sym driver_files\all.sym --ptr driver_files\all.ptr --data driver_files\all.data --accum driver_files\all.flags --comment driver_files\all.comment --offsets driver_files\all.offsets --quiet bin\mario.smc 1> output\bd.asm 2> null
echo e8000  f0000 -p -e -q | bin\disasm.exe --sym driver_files\all.sym --ptr driver_files\all.ptr --data driver_files\all.data --accum driver_files\all.flags --comment driver_files\all.comment --offsets driver_files\all.offsets --quiet bin\mario.smc 1> output\be.asm 2> null
echo f8000 100000 -p -e -q | bin\disasm.exe --sym driver_files\all.sym --ptr driver_files\all.ptr --data driver_files\all.data --accum driver_files\all.flags --comment driver_files\all.comment --offsets driver_files\all.offsets --quiet bin\mario.smc 1> output\bf.asm 2> null

cd output

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

cd ..

diff bin\mario.smc output\all.smc
