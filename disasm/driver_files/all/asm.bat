cat ..\bank*.sym      | sort  1>all.sym 
cat ..\bank*.data     | sort  1>all.data 
cat ..\bank*.flags    | sort  1>all.flags 
cat ..\bank*.trace    | sort  1>all.trace 
cat ..\bank*.code     | sort  1>all.code 
cat ..\bank*.comment          1>all.comment 

echo  8000 10000 -p -e -q | disasm.exe --sym all.sym --ptr all.ptr --data all.data --accum all.flags --comment all.comment --offsets all.offsets --quiet mario.smc 1> b0.asm 2> null
echo 18000 20000 -p -e -q | disasm.exe --sym all.sym --ptr all.ptr --data all.data --accum all.flags --comment all.comment --offsets all.offsets --quiet mario.smc 1> b1.asm 2> null
echo 28000 30000 -p -e -q | disasm.exe --sym all.sym --ptr all.ptr --data all.data --accum all.flags --comment all.comment --offsets all.offsets --quiet mario.smc 1> b2.asm 2> null
echo 38000 40000 -p -e -q | disasm.exe --sym all.sym --ptr all.ptr --data all.data --accum all.flags --comment all.comment --offsets all.offsets --quiet mario.smc 1> b3.asm 2> null
echo 48000 50000 -p -e -q | disasm.exe --sym all.sym --ptr all.ptr --data all.data --accum all.flags --comment all.comment --offsets all.offsets --quiet mario.smc 1> b4.asm 2> null
echo 58000 60000 -p -e -q | disasm.exe --sym all.sym --ptr all.ptr --data all.data --accum all.flags --comment all.comment --offsets all.offsets --quiet mario.smc 1> b5.asm 2> null
echo 68000 70000 -p -e -q | disasm.exe --sym all.sym --ptr all.ptr --data all.data --accum all.flags --comment all.comment --offsets all.offsets --quiet mario.smc 1> b6.asm 2> null
echo 78000 80000 -p -e -q | disasm.exe --sym all.sym --ptr all.ptr --data all.data --accum all.flags --comment all.comment --offsets all.offsets --quiet mario.smc 1> b7.asm 2> null
echo 88000 90000 -p -e -q | disasm.exe --sym all.sym --ptr all.ptr --data all.data --accum all.flags --comment all.comment --offsets all.offsets --quiet mario.smc 1> b8.asm 2> null
echo 98000 a0000 -p -e -q | disasm.exe --sym all.sym --ptr all.ptr --data all.data --accum all.flags --comment all.comment --offsets all.offsets --quiet mario.smc 1> b9.asm 2> null
echo a8000 b0000 -p -e -q | disasm.exe --sym all.sym --ptr all.ptr --data all.data --accum all.flags --comment all.comment --offsets all.offsets --quiet mario.smc 1> ba.asm 2> null
echo b8000 c0000 -p -e -q | disasm.exe --sym all.sym --ptr all.ptr --data all.data --accum all.flags --comment all.comment --offsets all.offsets --quiet mario.smc 1> bb.asm 2> null
echo c8000 d0000 -p -e -q | disasm.exe --sym all.sym --ptr all.ptr --data all.data --accum all.flags --comment all.comment --offsets all.offsets --quiet mario.smc 1> bc.asm 2> null
echo d8000 e0000 -p -e -q | disasm.exe --sym all.sym --ptr all.ptr --data all.data --accum all.flags --comment all.comment --offsets all.offsets --quiet mario.smc 1> bd.asm 2> null
echo e8000 f0000 -p -e -q | disasm.exe --sym all.sym --ptr all.ptr --data all.data --accum all.flags --comment all.comment --offsets all.offsets --quiet mario.smc 1> be.asm 2> null
echo f8000 100000 -p -e -q | disasm.exe --sym all.sym --ptr all.ptr --data all.data --accum all.flags --comment all.comment --offsets all.offsets --quiet mario.smc 1> bf.asm 2> null

