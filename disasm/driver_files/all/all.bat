cat ..\bank*.sym      | sort  1>all.sym 
cat ..\bank*.data     | sort  1>all.data 
cat ..\bank*.flags    | sort  1>all.flags 
cat ..\bank*.trace    | sort  1>all.trace 
cat ..\bank*.code     | sort  1>all.code 
cat ..\bank*.comment          1>all.comment 

echo 8000 100000 -e | disasm.exe --ram all.ram --sym all.sym --ptr all.ptr --data all.data --accum all.flags --comment all.comment --sym2 all.trace --offsets all.offsets mario.smc 1> all.log 2>null
