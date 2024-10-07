.equ OFFSET, 0x20
.text
        lw t0, 0(zero)   # 1
        lw t1, 4(zero) #12  
        lw t2, 8(zero)  #1   
        add  t3,t1,t0   #22
        sub t4,t1,t0     #2
        and t5,t1,t0      #1000  
        xor t6,t1,t0      #0100
        or s0,t1,t0       #1110 
        sll s1,t1,t2     #24
        slt  s2,t1,t0    #0
        sltu s3,t1,t0    #0
        sra  s4,t1,t2    #6
        srl  s5,t1,t0    
        lw t1, 4(zero) #12  
        addi  t3,t1,10  #22
        andi t5,t1,10    #1000  
        xori t6,t1,10     #0100
        ori s0,t1,10     #1110 
        slli s1,t1,2    #24
        slti  s2,t1,10   #0
        sltiu s3,t1,10  
        srai  s4,t1,2  
        srli  s5,t1,10   
        lw t1,0(zero)#0
        lw t2,4(zero) #12
        lw t3,8(zero) #10
        jumb:
        auipc t2,10000
        lui t3,10000
        addi t4,zero,0
        jalr t0,t4,36     
        addi t1,t1,1
        sw t3,12(zero) #10    pc=36
        lw t1,0(zero)#0
        lw t2,4(zero) #12
        lw t3,8(zero) #10
        sw t1,12(zero)#0
        sh t2,16(zero) #12
        sb t3,18(zero) #10














