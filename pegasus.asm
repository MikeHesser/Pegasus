;----- Pegasus
;-------- (C) 1988
;----------- By Mike Hesser
;
        ORG  #8D00
oooo:   EQU  #8D00
        ENT  $
printf: EQU  #BB5A
prganf: EQU  #0300
prgend: EQU  #84FF
curxp:  EQU  #B286
curyp:  EQU  #B285
cbuff:  EQU  #8500
bhimem: EQU  #AE7B              ; 664 #ae5e
lowbuf: EQU  #40        

ted:    CALL init
tedm:   CALL #BB81
        CALL #BB06
        CALL #BB84
        LD   IX,keytab
        CALL keyrec
        JR   NC,tedm
        LD   A,(copyf)
        OR   A
        JR   NZ,tedm
        LD   A,E
        CP   32
        JR   C,tedm
        CP   127
        JR   NC,tedm
        CALL char
        JR   tedm
char:   LD   A,C
        CP   79
        RET  Z
        INC  C
        INC  B
        LD   A,E
        LD   (wflag),A
        CALL printf
        LD   A,C
        CP   B
        JR   NZ,li>>
        XOR  A
chistr: LD   (HL),E
        INC  HL
        LD   (HL),A
        RET
li>>:   PUSH HL
li>>l:  LD   A,(HL)
        LD   (HL),E
        LD   E,A
        INC  HL
        OR   A
        JR   Z,li>>2
        CALL printf
        JR   li>>l
li>>2:  LD   (HL),A
        POP  HL
        INC  HL
        LD   A,B
t14:    LD   (curxp),A
        RET
;--DEL
codel:  LD   A,B
        OR   A
        RET  Z
        CALL curle1
;--CLR
coclr:  LD   A,B
        CP   C
        RET  Z
        PUSH HL
clrloo: INC  HL
        LD   A,(HL)
        DEC  HL
        LD   (HL),A
        INC  HL
        OR   A
        JR   Z,clrend
        CALL printf
        JR   clrloo
clrend: LD   A,32
        LD   (wflag),A
        CALL printf
        POP  HL
        LD   A,B
t2:     LD   (curxp),A
        DEC  C
        AND  A
        RET
;--CURSOR LINKS
curle:  LD   A,B
        OR   A
        RET  Z
curle1: DEC  B
        DEC  HL
        LD   A,8
        JR   currk1
;--CURSOR RECHTS
curre:  LD   A,B
        CP   C
        RET  Z
t3:     LD   A,(curxp)
        CP   79
        RET  Z
        INC  B
        INC  HL
        LD   A,9
currk1: CALL printf
        AND  A
        RET
;--ENTER
enter:  PUSH BC
        CALL entert
        POP  BC
        CCF
        RET  NC
        LD   A,B
        OR   A
        JR   NZ,enert0
        LD   DE,2
        CALL enmem_
        CCF
        RET  NC
        LD   A,C
        LD   C,E
        LD   B,D
        CALL lddr1
        LD   HL,(prakt)
        LD   (HL),2
        INC  HL
        LD   (HL),B
        INC  HL
        LD   B,A
        PUSH HL
        CALL ak=ma_
        POP  HL
        JR   NZ,enterw
        LD   A,B
        OR   A
        JR   NZ,enterw
        LD   (prakt),HL
        JR   enert@
enterw: LD   E,0
        CALL scu_d
        LD   A,18
        CALL printf
        JR   enert1
enert0: CALL ak=ma_
        JR   Z,enert@
        CALL lf1
        JP   curdk
enert@: CALL incaz
        CALL lf
enert1: LD   HL,(mazei)
        INC  HL
        LD   (mazei),HL
        LD   BC,0´
        LD   HL,lowbuf
        AND  A
        RET
entert: LD   A,(wflag)
        OR   A
        RET  Z
        PUSH HL
        PUSH BC
        LD   HL,lowbuf
        LD   IY,bbuff
        CALL abw
        JR   C,entee1
        LD   HL,bbuff
        INC  HL
        LD   A,(HL)
        CP   192
        JR   NZ,enter2
        INC  HL
        PUSH DE
        LD   D,H
        LD   D,L
        CALL c'labi
        POP  DE
        JR   C,entee1
enter2: LD   HL,bbuff
        PUSH HL
        PUSH HL
        CALL baw
        POP  IY
        LD   HL,ciibuf
        CALL abw
        POP  HL
        JR   C,entee1
        PUSH DE
        CALL cuupu1
        POP  DE
        AND  A
entee1: POP  BC
        POP  HL
        RET  C
        LD   D,0
        CALL enmem_
        RET  C
        LD   A,D
        LD   (wflag),A
        LD   B,A
        LD   C,E
        CALL ak=ma_
        JR   NZ,insert
        LD   DE,(prakt)
        LD   HL,bbuff
        LDIR
        EX   DE,HL
        LD   (prakt),HL
        LD   (HL),B
        INC  HL
        LD   (HL),B
        INC  HL
        LD   (pren2),HL
        AND  A
        RET
insert: PUSH BC
ins_1:  LD   HL,(prakt)
        LD   D,(HL)
        LD   A,D
        SUB  X
        JR   Z,inske
        JR   NC,inset3
        LD   A,C
        SUB  D
        LD   C,A
        LD   A,D
        CALL lddr1
        JR   inske
lddr1:  LD   HL,(pren2)
        LD   D,H
        LD   E,L
        ADD  HL,BC
        LD   (pren2),HL
        EX   DE,HL
        PUSH HL
        LD   BC,(prakt)
        SBC  HL,BC
        LD   B,H
        LD   C,L
        POP  HL
        INC  BC
        LDDR
        RET
inset3: CALL inset1
        JR   inske
inset1: LD   HL,(prakt)
inset2: LD   C,(HL)
        ADD  HL,BC
        PUSH HL
        LD   C,A
        AND  A
        SBC  HL,BC
        EX   DE,HL
        POP  BC
        PUSH BC
        LD   HL,(pren2)
        AND  A
        SBC  HL,BC
        LD   B,H
        LD   C,L
        LD   L,A
        LD   A,B
        OR   C
        LD   A,L
        POP  HL
        RET  Z
        LDIR
        LD   HL,(pren2)
        LD   C,A
        AND  A
        SBC  HL,BC
        LD   (pren2),HL
        RET
 inske: POP  BC
 inske2:LD   HL,bbuff
 inske3:LD   DE,(prakt)
        LDIR
        AND  A
        RET
 ;--CURSOR AUF
 curup: LD   DE,(akzei)
        LD   A,D
        OR   E
        RET  Z
        PUSH BC
        CALL entert
        POP  BC
        CCF
        RET  NC
        CALL ak=ma_
        JR   NZ,curup2
        LD   A,C
        OR   A
        JR   Z,curup2
        LD   HL,(mazei)
        INC  HL
        LD   (mazei),HL
 curup2:LD   HL,(akzei)
        DEC  HL
        LD   (akzei),HL
        EX   DE,HL
        CALL searz
 cuupu_:LD   A,11
 cuupu: CALL printf
        LD   (prakt),HL
 cuupu1:CALL baw
        LD   DE,lowbuf
        LD   HL,ciibuf
        LD   BC,80
        LDIR
 t4:    LD   A,(curxp)
        PUSH AF
        CALL linout
 curle5:LD   A,18
        CALL printf
        POP  AF
        CP   C
        JR   C,curle6
        LD   A,C
 curle6:LD   (curxp),A
        LD   HL,lowbuf
        LD   D,0
        LD   E,A
        ADD  HL,DE
        LD   B,A
        RET
 curdo: PUSH HL
        CALL ak=ma_
        POP  HL
        RET  Z
        CALL entert
        CCF
        RET  NC
 curdk: CALL incaz
        EX   DE,HL
        CALL searz
        LD   A,10
        JR   cuupu
c're:   LD   A,C
        SUB  B
        LD   D,0
        LD   E,A
        ADD  HL,DE
        LD   B,C
c'rek:  LD   A,B
t4:     LD   (curxp),A
        AND  A
        RET
c'le:   LD   HL,lowbuf
        LD   B,0
        JR   c'rek
clin:   PUSH HL
        CALL ak=ma_
        POP  HL
        RET  Z
        LD   E,A
        CALL scu_d
t5:     LD   HL,(curyp)
        PUSH HL
        LD   HL,(prakt)
        LD   A,(HL)
        LD   B,0
        CALL inset2
        LD   HL,(mazei)
        DEC  HL
        LD   (mazei),HL
        CALL lf1
        LD   DE,(akzei)
        AND  A
        SBC  HL,DE
 t6:    LD   A,(curyp)
        LD   C,A
        LD   A,25
        SUB  C
        LD   C,A
        LD   A,H
        OR   A
        JR   NZ,clin1
        LD   A,L
        CP   C
        JR   NC,clin1
        LD   A,L
        CP   C
        JR   C,clin5
clin1:  LD   A,24
t7:     LD   (curyp),A
        LD   B,0
        EX   DE,HL
        ADD  HL,BC
        EX   DE,HL
        DEC  DE
        CALL searz
        CALL baw
        CALL linout
clin5:  POP  HL
t8:     LD   (curyp),HL
        LD   HL,(prakt)
        JP   cuupu1
;-- ASSEMBLE
assem:  LD   HL,astxt
        CALL txout
        LD   HL,bdtxt
        CALL yes_no
        LD   (bildf),A
        LD   HL,drtxt
        CALL yes_no
        LD   (druckf),A
        JR   NZ,ass'1
        LD   (bildf),A
ass'1:  LD   HL,cstxt
        CALL yes_no
        LD   (cassf),A
        CALL lf
        XOR  A
        LD   (pflag),A
        LD   HL,(prend)
        LD   (HL),A
        DEC  HL
        LD   (HL),A
        CALL aps
        INC  A
        LD   (pflag),A
        LD   A,(cassf)
        OR   A
        JR   Z,pegas1
        CALL savlu2
        LD   DE,cbuff
        CALL #BC8C
        JP   NC,bctoed
        PUSH HL
        POP  IX
        LD   (IX+18),2
        LD   HL,(et)
        LD   (IX+26),L
        LD   (IX+27),H
        LD   HL,(og)
        LD   (IX+21),L
        LD   (IX+22),H
        LD   DE,(pc)
        EX   DE,HL
        AND  A
        SBC  HL,DE
        LD   (IX+24),L
        LD   (IX+25),H
pegas1: CALL aps
        LD   A,(bildf)
        OR   A
        JR   Z,pabcde
        CALL lf
        LD   HL,(labado)
pg2:    LD   B,6
pg3:    PUSH BC
        CALL p3
        CALL esc_
        POP  BC
        JR   C,pabcde
        DJNZ pg3
        CALL lf
        JR   pg2
p3:     LD   E,(HL)
        DEC  HL
        LD   D,(HL)
        LD   A,D
        OR   E
        JR   NZ,p6
        POP  HL
        JR   pabcde
p6:     LD   B,6
p1:     LD   A,(DE)
        BIT  7,A
        JR   NZ,pabcd1
        INC  DE
        CALL pinf
        DJNZ p1
pabcd1: RES  7,A
        CALL pinf
p2:     LD   IY,ciibuf
p4:     CALL spac
        DJNZ p4
        DEC  HL
        LD   E,(HL)
        DEC  HL
        LD   A,(HL)
        DEC  HL
        CALL hex'
        CALL spac
        LD   (IY),0
        LD   DE,ciibuf
p5:     LD   A,(DE)
        OR   A
        RET  Z
        INC  DE
        CALL pinf
        JR   p5
pabcde: CALL lf
        LD   IY,ciibuf
        LD   HL,inf_
        CALL txtal'
        LD   DE,(og)
        CALL hex'1
        CALL txtal'
        LD   DE,(pc)
        CALL hex'1
        CALL txtal'
        LD   DE,(et)
        CALL hex'1
        LD   (IY),0
        CALL linout
        CALL lf
        XOR  A
        LD   (druckf),A
        LD   A,(cassf)
        OR   A
        JP   NZ,sa1
        LD   HL,auftxt
        CALL yes_no
        JP   NZ,bctoed
        CALL savlu2
        LD   DE,cbuff
        CALL #BC8C
        LD   HL,(pc)
        LD   DE,(og)
        JP   sak
 aps:   LD   HL,0
        LD   (aszei),HL
        LD   HL,(pren2)
        PUSH HL
        POP  IY
        LD   (og),HL
        LD   (pc),HL
        LD   (et),HL
        EX   DE,HL
        LD   HL,(prend)
        LD   (labad),HL
        LD   (labado),HL
        AND  A
        SBC  HL,DE
        LD   (freeme),HL
        LD   HL,(pranf)
mnlo1:  LD   (akadr),HL
        XOR  A
        LD   (pcadd),A
        LD   A,(cassf)
        OR   A
        JR   Z,w7
        LD   IY,bbuff
w7:     LD   A,(HL)
        CP   2
        JR   Z,mn_w2
        INC  HL
        OR   (HL)
        RET  Z
        CALL ass
        JR   C,syx_
        LD   A,(bildf)
        OR   A
        CALL NZ,bilda
        LD   A,(pcadd)
        LD   C,A
        LD   B,0
        LD   HL,(pc)
        ADD  HL,BC
        LD   (pc),HL
mn_w2:  LD   HL,(aszei)
        INC  HL
        LD   (aszei),HL
        LD   HL,(akadr)
        LD   B,0
        LD   C,(HL)
        ADD  HL,BC
        JR   mnlo1
syx_:   LD   A,1
err:    LD   DE,(aszei)
        LD   (akzei),DE
err2:   PUSH AF
        CALL bctoe2
        POP  AF
        PUSH HL
        PUSH BC
        LD   B,A
t9:     LD   A,(curxp)
        LD   C,A
        LD   HL,#18
t10:    LD   (curyp),HL
errshw: LD   HL,errtab
errlo1: DEC  B
        JR   Z,errw1
errlo2: LD   A,(HL)
        INC  HL
        OR   A
        JR   NZ,errlo2
        JR   errlo1
errw1:  LD   A,24
        CALL printf
        CALL txout
        LD   A,24
        CALL printf
        LD   H,C
        LD   L,0
t11:    LD   (curyp),HL
        CALL #BC92
        POP  BC
        POP  HL
        LD   SP,#C000
        JP   tedm
bilda:  LD   A,(pflag)
        OR   A
        RET  Z
        PUSH IY
        LD   IY,ciibuf
        LD   DE,(pc)
        LD   A,D
        CALL hex'
        LD   A,(cassf)
        OR   A
        JR   Z,b2
        LD   DE,bbuff
b2:     CALL spac
        LD   A,(pcadd)
        OR   A
        JR   Z,bilda3
        CP   5
        JR   C,bilda2
        LD   A,4
bilda2: LD   B,A
bilda1: LD   A,(DE)
        CALL hex8
        INC  DE
        DJNZ bilda1
        LD   (IY),0
        CALL linout
bilda3: LD   HL,curxp
        LD   A,15
        SUB  (HL)
        LD   B,A
bilda4: LD   A,32
        CALL pinf
        DJNZ bilda4
        LD   HL,(akadr)
        CALL baw
        LD   HL,ciibuf
        CALL linou2
        POP  IY
        CALL lf
        CALL esc_
        RET  NC
        POP  HL
        RET
bctoed: LD   SP,#C000
        CALL bctoe2
        JP   tedm
bctoe2: LD   A,2
        CALL #BC0E
        LD   DE,(akzei)
        PUSH DE
        CALL searz
        LD   B,25
        JR   btelo1
btelo:  CALL lf
btelo1: PUSH BC
        PUSH HL
        CALL cuupu1
        CALL ak=ma_
        POP  HL
        POP  BC
        JR   Z,bteend
        LD   E,(HL)
        LD   D,0
        ADD  HL,DE
        DJNZ btelo
        JR   bteen1
bteend: LD   A,20
        CALL printf
bteen1: LD   HL,0
t12:    LD   (curyp),HL
        CALL #BC92
        POP  DE
        CALL searz
        LD   (prakt),HL
        JP   cuupu1
basic:  LD   HL,(pranf)
        DEC  HL
        LD   (bhimem),HL
        CALL #B900
        JP   #C064
save:   CALL savlu2
        CALL catta
        JR   C,save
        LD   DE,cbuff
        CALL #BC8C
        JR   C,save1
        CALL #BC8F
        JP   bctoed
save1:  LD   HL,(pren2)
        PUSH HL
        DEC  HL
        LD   DE,(mazei)
        LD   (HL),D
        DEC  HL
        LD   (HL),E
        POP  HL
        LD   DE,(pranf)
sak:    AND  A
        SBC  HL,DE
        EX   DE,HL
        LD   A,2
        LD   BC,0
        CALL #BC98
sa1:    CALL #BC8F
sa0:    XOR  A
        LD   HL,(pren2)
        DEC  HL
        LD   (HL),A
        DEC  HL
        LD   (HL),A
        JP   bctoed
load:   CALL savlu2
        CALL catta
        JR   C,load
        LD   DE,cbuff
        CALL #BC77
        JR   C,load1
        CALL #BC7A
        JP   bctoed
load1:  LD   HL,(pren2)
        DEC  HL
        DEC  HL
        LD   D,H
        LD   E,L
        AND  A
        ADD  HL,BC
        JP   C,bctoed
        PUSH HL
        LD   B,H
        LD   C,L
        LD   HL,(prend)
        AND  A
        SBC  HL,BC
        JP   C,bctoed
        LD   H,D
        LD   L,E
        CALL #BC83
        CALL #BC7A
        POP  HL
        LD   (pren2),HL
        DEC  HL
        LD   D,(HL)
        DEC  HL
        LD   E,(HL)
        LD   HL,(mazei)
        ADD  HL,DE
        LD   (mazei),HL
        LD   HL,0
        LD   (akzei),HL
        JP   sa0
catta:  LD   A,B
        OR   A
        RET  NZ
        LD   DE,2048
        CALL enmem_
        RET  C
        PUSH HL
        PUSH BC
        LD   DE,oooo-4096
        CALL #BC9B
        POP  BC
        POP  HL
        SCF
        DEFS 3
        RET
savlu2: LD   HL,datxt
savlu3: CALL txout
        LD   HL,ciibuf
        LD   (HL),0
t1:     CALL #BD3A
        JP   Z,bctoed
        PUSH HL
        LD   B,#FF
savlo:  INC  B
        LD   A,(HL)
        CALL gr'klb
        LD   (HL),A
        INC  HL
        OR   A
        JR   NZ,savlo
        POP  HL
        RET
go:     LD   HL,bctoed
        PUSH HL
        LD   HL,(et)
        JP   (HL)
dbrk:   LD   (zwbuf1),SP
        PUSH IY
        PUSH IX
        PUSH BC
        PUSH DE
        PUSH HL
        LD   HL,(zwbuf1)
        PUSH HL
        PUSH AF
        LD   HL,db_
        CALL txout
        LD   IY,ciibuf
        POP  DE
        LD   A,D
        CALL hex8
        CALL spac
        XOR  A
        LD   D,A
        INC  A
        CALL binb'
        LD   L,6
dbrk1:  CALL spac
        POP  DE
        LD   A,D
        CALL hex'
        DEC  L
        JR   NZ,dbrk1
        XOR  A
        CALL wrbuf2
        LD   HL,ciibuf
        CALL txout
        CALL #BB06
        JP   bctoed
esc:    LD   A,(copyf)
        OR   A
        RET  Z
        XOR  A
        LD   (copyf),A
        LD   A,7
        JP   #BB5A
copy:   PUSH HL
        LD   A,7
        CALL #BB5A
        LD   HL,(akzei)
        LD   A,(copyf)
        OR   A
        JR   NZ,copy1
        INC  A
        LD   (copyf),A
        LD   (copz1),HL
        POP  HL
        RET
copy1:  LD   A,2
        LD   (copyf),A
        LD   DE,(copz1)
        CALL hl=de_
        JR   NC,copy2
        LD   (copz1),HL
        EX   DE,HL
copy2:  PUSH BC
        PUSH HL
        AND  A
        SBC  HL,DE
        LD   (copz2),HL
        CALL searz
        LD   (copz3),HL        
        POP  DE
        PUSH HL
        CALL searz
        POP  DE
        LD   C,(HL)
        LD   B,0
        ADD  HL,BC
        AND  A
        SBC  HL,DE
        LD   (copz4),HL
        POP  BC
        POP  HL
        RET
ctrl.k: LD   A,(copyf)
        CP   2
        CCF
        RET  NZ
        LD   DE,(akzei)
        LD   HL,(copz1)
        CALL hl=de_
        JR   NC,ct2
        PUSH DE
        LD   DE,(copz2)
        ADD  HL,DE
        POP  DE
        CALL hl=de_
        RET  NC
ct2:    LD   DE,(copz4)
        CALL enmem_
        CCF
        RET  NC
        LD   B,D
        LD   C,E
        PUSH BC
        CALL lddr1
        POP  BC
        LD   HL,(copz3)
        LD   DE,(prakt)
        CALL hl=de_
        JR   C,ctrlk1
        ADD  HL,BC
ctrlk1: CALL inske3
        CALL esc
        LD   HL,(mazei)
        LD   BC,(copz2)
        ADD  HL,BC
        INC  HL   
        LD   (mazei),HL
        JP   bctoed
c'lab:  LD   HL,labn_
        CALL savlu3
        PUSH HL
        DEC  B
        LD   C,B
        LD   B,0
        ADD  HL,BC
        SET  7,(HL)   
        POP  DE
        CALL c'labi
        JR   NC,c1
        LD   HL,(aszei)
c2:     LD   (akzei),HL
c1:     JP   bctoed
c'labi: LD   HL,0
        LD   (aszei),HL
        LD   HL,(pranf)
c'w9:   PUSH HL
        LD   A,(HL)
        INC  HL
        OR   (HL)
        JR   Z,c'end
        LD   A,(HL)
        INC  HL
        CP   192
        JR   NZ,c'w8
        PUSH HL
        PUSH DE
c'w0:   LD   A,(DE)
        CP   (HL)
        JR   NZ,c'w1
        RLCA
        JR   C,c'w2
c'w3:   INC  DE
        INC  HL
        JR   c'w0
c'w1:   POP  DE
        POP  HL
c'w8:   LD   HL,(aszei)
        INC  HL
        LD   (aszei),HL
        POP  HL
        LD   B,0
        LD   C,(HL)
        ADD  HL,BC
        JR   c'w9
c'end:  POP  HL
        RET
c'w2:   POP  DE
        POP  HL
        POP  HL
        LD   BC,(prakt)
        LD   A,B
        CP   H
        SCF
        RET  NZ
        LD   A,C
        CP   L
        SCF
        RET  NZ
        PUSH HL
        JR   c'w8
c'up:   LD   HL,0
        JR   c2
c'down: LD   HL,(mazei)
        JR   c2
new:    LD   HL,lotab
        CALL yes_no
        JP   NZ,bctoed
        LD   A,(copyf)
        CP   1
        JR   C,new2
        JP   Z,bctoed
        LD   HL,(copz3)
        PUSH HL
        LD   BC,(copz4)
        ADD  HL,BC
        EX   DE,HL
        LD   HL,(pren2)
        PUSH HL
        SBC  HL,BC
        LD   (pren2),HL
        POP  HL
        SBC  HL,DE
        LD   B,H
        LD   C,L
        EX   DE,HL
        POP  DE
        LDIR
        LD   A,B
        LD   (copyf),A
        LD   BC,(copz2)
        INC  BC
        LD   HL,(mazei)
        AND  A
        SBC  HL,BC
        LD   (mazei),HL
        LD   DE,(akzei)
        JR   C,new3
        LD   (akzei),HL
new3:   JP   bctoed
new2:   LD   HL,tedm
        PUSH HL
init:   LD   A,2
        CALL #BC0E
        CALL #BC02
        CALL #BC65
t13:    LD   A,32
        LD   HL,#A7
        CALL #BC68
        LD   HL,dbrk
        LD   A,#C3
        LD   (#30),A
        LD   (#31),HL
        LD   HL,bctoed
        LD   (0),A
        LD   (1),HL
        LD   (et),HL
        LD   HL,0
        LD   (akzei),HL
        LD   (mazei),HL
        LD   B,H
        LD   C,H
        LD   HL,prganf
        LD   (pranf),HL
        LD   (prakt),HL
        XOR  A
        LD   (copyf),A
        LD   (HL),A
        INC  HL
        LD   (HL),A
        INC  HL
        LD   (pren2),HL
        LD   HL,prgend
        LD   (prend),HL
        LD   HL,titel_
        CALL txout
        LD   HL,lowbuf
        RET
incaz:  LD   HL,(akzei)
        INC  HL
        LD   (akzei),HL
        RET
ak=ma_: LD   HL,(akzei)
        LD   DE,(mazei)
hl=de_: LD   A,H
        SUB  D
        RET  NZ
        LD   A,L
        SUB  E
        RET
enmem_: PUSH HL
        PUSH DE
        LD   HL,(prend)
        LD   DE,(pren2)
        AND  A
        SBC  HL,DE
        POP  DE
        CALL hl=de_
        POP  HL
        RET
lf:     LD   A,10
        CALL pinf
lf1:    LD   A,13
pinf:   CALL #BB5a
        LD   I,A
        LD   A,(druckf)
        OR   A
        RET  Z
prinfl: LD   A,I
        CALL #BD2B
        CCF
        RET  NC
        CALL esc_
        RET  C
        JR   prinfl
txout:  LD   A,(HL)
        INC  HL
        OR   A
        RET  Z
        CALL printf
        JR   txout
esc_:   CALL #BB09
        RET  NC
        CP   #FC
        CCF
        RET  NZ
        CALL #BB06
        XOR  #FC
        RET  NZ
        LD   (druckf),A
        SCF
        RET
searz:  LD   HL,(pranf)
        LD   A,D
        OR   E
        RET  Z
        LD   BC,0
curl1:  PUSH BC
        LD   B,0
        LD   C,(HL)
        ADD  HL,BC
        POP  BC
        INC  BC
        LD   A,C
        CP   E
        JR   NZ,curl1
        LD   A,B
        CP   D
        JR   NZ,curl1
        RET
linout: LD   A,13
        LD   C,0
        LD   HL,ciibuf
linlo:  CALL pinf
linou2: LD   A,(curxp)
        XOR  79
        JR   Z,linlk1
        LD   A,(HL)
        OR   A
        RET  Z
        INC  HL
        INC  C
        JR   linlo
linlk1: LD   (HL),A
        RET
yes_no: CALL txout
        LD   HL,ja_nee
        CALL txout
        CALL #BB81
        CALL #BB18
        CALL #BB84
        PUSH AF
        CALL lf
        POP  AF
        CP   #FC
        JP   Z,bctoed
        CP   106
        RET  Z
        LD   A,0
        RET
;------------------ JUMPER
keyrec: LD   E,A
        LD   D,0
keyrl:  LD   A,(IX)
        INC  IX
        CP   #FF
        SCF
        RET  Z
        CP   E
        JR   Z,keyen1
        INC  IX
        INC  IX
        INC  D
        JR   keyrl
keyen1: LD   A,(copyf)
        OR   A
        LD   A,D
        JR   Z,key3
        CP   9
        JR   C,key3
        CP   13
        CCF
        RET  NC
key3:   CP   13
        JR   C,keyen2
        CALL entert
        CCF
        RET  NC
        CALL #BB6C
keyen2: LD   E,(IX)
        LD   D,(IX+1)
        PUSH DE
        RET
;--TABELLE
keytab: DEFB 240
        DEFW curup
        DEFB 241
        DEFW curdo
        DEFB 242
        DEFW curle
        DEFB 243
        DEFW curre
        DEFB 251
        DEFW c're
        DEFB 250
        DEFW c'le
        DEFB 11
        DEFW ctrl.k
        DEFB 224
        DEFW copy
        DEFB #FC
        DEFW esc
        DEFB 3
        DEFW clin
        DEFB 16
        DEFW coclr
        DEFB 127
        DEFW codel
        DEFB 13
        DEFW enter
        DEFB 14
        DEFW new
        DEFB 17
        DEFW basic
        DEFB 1
        DEFW assem
        DEFB 19
        DEFW save
        DEFB 12
        DEFW load
        DEFB 30
        DEFW go
        DEFB 6
        DEFW c'lab
        DEFB 248
        DEFW c'up
        DEFB 249
        DEFW c'down
        DEFB #FF
;MATHTAB
mathta: DEFW plus
        DEFW minus
        DEFW mul
        DEFW divide
        DEFW band
        DEFW bor
        DEFW bxor
;--SCROLL
scu_d:  PUSH BC
        PUSH HL
        LD   HL,(curyp)
        XOR  A
        LD   H,A
        LD   B,E
        LD   DE,#4F18
        CALL #BC50
        POP  HL
        POP  BC
        RET
titel_: DEFM "PEGASUS Assembler/Editor"
        DEFB 10,13
        DEFM "Version 1.1 Copyright "
        DEFB 164
        DEFM " 1987,88 by Mike Hesser"
        DEFB 10,10,13,0
astxt:  DEFM "PEGASUS Assembler v1.1"
        DEFB 10,10,13,0
errtab: DEFM "Syntax error"
        DEFB 0
        DEFM "Operand missing"
        DEFB 0
        DEFM "Distance too high"
        DEFB 0
        DEFM "Overflow"
        DEFB 0
        DEFM "Unknown Label"
        DEFB 0
        DEFM "Memory full"
        DEFB 0
        DEFM "Out of Memory"
        DEFB 0
;
bdtxt:  DEFM "Bildschirmausgabe"
        DEFB 0
drtxt:  DEFM "Drucker"
        DEFB 0
cstxt:  DEFM "MC direkt speichern"
        DEFB 0
ja_nee: DEFM " (j/n)? "
        DEFB 0
datxt:  DEFB 13,10
        DEFM "Dateiname:"
        DEFB 0
lotab:  DEFM "Wirklich loeschen"
        DEFB 0
auftxt: DEFM "Aufzeichnung"
        DEFB 0
labn_:  DEFM "Labelname:"
        DEFB 0
db_:    DEFB 13,10
        DEFM " A SZ-H-PNC  SP   HL   DE   BC   IX   IY"
        DEFB 13,10,0
inf_:   DEFM "Anfang: "
        DEFB 0
        DEFM "    Ende: "
        DEFB 0
        DEFM "    Start: "
        DEFB 0
mazei:  DEFW 0
akzei   DEFW 0
pranf:  DEFW 0
pranf:  DEFW 0
prend:  DEFW 0
prakt:  DEFW 0
pren2:  DEFW 0
wflag:  DEFB 0
akadr:  DEFW 0
aszei:  DEFW 0
bildf:  DEFB 0
druckf: DEFB 0
;-------------- GLOBAL SYSTEMVARIABLEN
og:     DEFW 0
pc:     DEFW 0
et:     DEFW 0
labad:  DEFW 0
labado: DEFW 0
freeme: DEFW 0
pflag:  DEFB 0
pcadd:  DEFB 0
cassf:  DEFB 0
copyf:  DEFB 0
copz1:  DEFW 0
copz2:  DEFW 0
copz3:  DEFW 0
copz4:  DEFW 0
;
;ASSEMBLER
;
ass:    LD   A,(HL)
        INC  (HL)
        CP   2
        CCF
        RET  NC
        LD   B,A
        AND  %11111
        LD   C,A
        LD   A,B
        AND  %11100000
        CP   32
        JP   Z,befoa		; Befehl ohne Argument (z.B: RET, CCF)
        CP   64
        JP   Z,befoa1
        CP   192
        JP   Z,labeld
        CP   160
        JP   Z,pseud
        LD   B,(HL)
        CP   96
        JP   Z,bef1a
        CP   128
        SCF
        RET  NZ
        PUSH HL
l1:     CALL elemew
				JR   NC,we1
				LD   A,(HL)
				CP   10
				JR   NZ,l1
				INC  (HL)
				LD   D,H
				LD   E,L
				LD   A,C
				LD   C,(HL)
				POP  HL
				LD   IX,ag2t
				JP   tabrec
we1:    LD   A,2
        JP   err
befoa1: LD   HL,noard2
        CALL wred
        JR   boarec
befoa:  LD   HL,noar.d
boarec: LD   B,0
        ADD  HL,BC
        LD   A,(HL)
        JP   wrbuf
pseud:  LD   A,C
        CP   8
        RET  Z
        LD   IX,pstab
tabrec: ADD  A
        PUSH BC
        LD   C,A
        LD   B,0
        ADD  IX,BC
        LD   C,(IX)
        LD   B,(IX+1)
        PUSH BC
        POP  IX
        POP  BC
        JP   (IX)
bef1a:  LD   A,C
        CP   8
        JR   C,bef<9
        CP   16
        JP   C,bef<17
        SUB  16
        LD   IX,ag1t
        JP   tabrec
bef<9:  LD   A,B
        CP   30
        JR   C,bw1
        CP   #41
        JR   NC,bw1
        CP   38
        JR   NC,bw2
        SUB  30
        LD   B,A
        LD   A,C
        ADD  A
        ADD  A
        ADD  A
        ADD  128
        ADD  B
        JP   wrbuf
bw1:    LD   A,C
        ADD  A
        ADD  A
        ADD  A
        ADD  198
        CALL wrbuf
        CALL arg8b
        RET  C
        JP   wrbuf
;
bw2:    INC  HL
        CALL ixiyte
        RET  C
        LD   A,C
        ADD  A
        ADD  A
        ADD  A
        ADD  #86
i1b:    CALL wrbuf
        LD   A,B
i1:     CP   48
        JR   Z,w5
        CP   50
        JR   NZ,w6
w5:     XOR  A
        JP   wrbuf
w6:     CALL arg8b
        RET  C
        JP   wrbuf
bef<17: SUB  8
        LD   C,B
        LD   B,0
        JR   brskue
bbit:   LD   B,1
        JR   brs
bres:   LD   B,2
        JR   brs
bset:   LD   B,3
;
brs:    PUSH BC
        CALL arg8b
        POP  BC
        RET  C
        CP   8
        JR   NC,ov_
        EX   DE,HL
brskue: PUSH AF
        LD   A,C
        CALL reg8t
        JR   C,we3
        LD   A,#CB
        CALL wrbuf
        LD   A,C
        SUB  30
        LD   E,A
i2:     POP  AF
        ADD  A
        ADD  A
        ADD  A
        ADD  E
        LD   E,A
        LD   A,B
        LD   B,6
brslo1: ADD  A
        DJNZ brslo1
        ADD  E
        JP   wrbuf
ov_:    LD   A,4
        JP   err
we3:    CALL ixiyte
        JR   C,brse1
        LD   A,#CB
        CALL wrbuf
        LD   A,C
        INC  HL
        CALL i1
        JR   C,brse1
        LD   E,6
        JP   i2
brse1:  POP  BC
        RET
bret:   LD   A,B
        CALL cctest
        RET  C
        LD   C,192
bretu:  ADD  A
        ADD  A
        ADD  A
        ADD  C
        JP   wrbuf
bjr:    LD   A,#18
bjrkue: CALL wrbuf
        CALL disrec
        RET  C
        JP   wrbuf
bdjnz:  LD   A,16
        JR   bjrkue
bjrcc:  LD   A,B
        CALL cctest
        RET  C
        CP   4
        CCF
        RET  C
        ADD  A
        ADD  A
        ADD  A
        ADD  32
        CALL wrbuf
        LD   B,A
        EX   DE,HL
        CALL disrec
        RET  C
        EX   DE,HL
        JP   wrbuf
bcall:  LD   A,#CD
bcku:   CALL wrbuf
wordw:  CALL arg16b
        RET  C
wordw2: LD   A,E
        CALL wrbuf
        LD   A,D
        JP   wrbuf
bjp:    CALL arg16b
        JR   C,bjp.1
        LD   A,#C3
        CALL wrbuf
        JR   wordw2
bjp.1:  LD   A,B
        CP   36
        JR   Z,bjpk1
bjp.2:  CP   48
        JR   NZ,bjpk
        LD   A,#DD
        JR   bjpk2
bjpk:   CP   50
        SCF
        RET  NZ
        LD   A,#FD
bjpk2:  CALL wrbuf
bjpk1:  LD   A,#E9
        JP   wrbuf
bcallc: LD   C,196
bcai:   LD   A,B
        CALL cctest
        RET  C
        CALL bretu
        EX   DE,HL
        JP   wordw
bjpc:   LD   C,194
        JR   bcai
brst:   CALL arg8b
        RET  C
        CP   8
        JP   NC,ov_
        ADD  A
        ADD  A
        ADD  A
        ADD  #C7
        JP   wrbuf
bpush:  LD   C,#C5
        JR   bpushk
bpop:   LD   C,#C1
bpushk: LD   A,B
        CP   40
        RET  C
        CP   45
        JR   NC,bpixy
        CP   43
        SCF
        RET  Z
        CP   44
        JR   NZ,k1
        DEC  A
k1:     SUB  40
        ADD  A
        ADD  A
        ADD  A
        ADD  A
        ADD  C
        JP   wrbuf
bpixy:  LD   A,#20
        ADD  C
        LD   C,A
bpukue: LD   A,B
bpuku3: CP   45
        LD   A,#DD
        JR   Z,bpixk1
bpixk:  LD   A,#FD
bpixk1: CALL wrbuf
bpixk2: LD   A,C
        JP   wrbuf
binc:   LD   DE,#0304
        JR   bindeh
bdec:   LD   DE,#0B05
bindeh: LD   A,B
        CP   40
        JR   C,bind8b
        CP   47
        JR   NC,bindix
        CP   45
        JR   NC,bixy
        CP   44
        SCF
        RET  Z
        SUB  40
        ADD  A
kue15:  ADD  A
        ADD  A
        ADD  A
        ADD  D
        JP   wrbuf
bixy:   LD   A,#20
        ADD  D
        LD   C,A
        JR   bpukue
bind8b: CALL reg8t
        RET  C
        SUB  30
        LD   D,E
        JR   kue15
bindix: CALL ixiyte
        RET  C
        LD   A,#30
        ADD  E
        CALL wrbuf
        INC  HL
        LD   A,B
        JP   i1
bex:    LD   A,B
        CP   41
        JR   NZ,exkue1
        LD   A,C
        CP   42
        SCF
        RET  NZ
        LD   A,#EB
        JP   wrbuf
exkue1: CP   44
        JR   NZ,exkue2
        LD   A,C
        CP   51
        SCF
        RET  NZ
        LD   A,8
        JP   wrbuf
exkue2: CP   54
        SCF
        RET  NZ
        LD   A,C
        LD   B,C
        LD   C,#E3
bpuku2: CP   42
        JP   NZ,bpuku3
        LD   A,C
        JP   wrbuf
badd:   LD   L,0
        JR   addw.w
badc:   LD   L,1
        JR   addw.w
bsub:   LD   L,2
        JR   addw0
bsbc:   LD   L,3
addw.w: LD   A,B
        CP   37
        JR   NZ,addw1
addw0:  LD   B,C
        LD   C,L
        LD   H,D
        LD   L,E
        JP   bef<9
addw1:  LD   A,C
        CP   40
        RET  C
        CP   44
        CCF
        RET  C
        SUB  40
        LD   C,A
        LD   A,L
        OR   A
        JR   Z,addw2
        LD   A,B
        CP   42
        SCF
        RET  NZ
        CALL wred
        LD   A,C
        ADD  A
        ADD  A
        ADD  A
        ADD  A
        ADD  #4E
        LD   C,A
        LD   A,L
        ADD  A
        ADD  A
        LD   L,A
        LD   A,C
        SUB  L
        JP   wrbuf
addw2:  LD   A,C
        ADD  A
        ADD  A
        ADD  A
        ADD  A
        ADD  9
        LD   A,B
        JP   bpuku2
;LD-BEFEHLE
26.01.88
;
bld:    LD   A,B
        CALL reg16t
        JR   C,lku1
        LD   A,C
        CALL reg16t
        JP   NC,ld81
        JR   ld162
lku1:   CP   43
        JR   NZ,ld161
        EX   DE,HL
        CALL kltest
        JR   NZ,spuu1        
        CALL wred
        LD   A,#7B
        JP   bcku
spuu1:  LD   A,C
        CALL iitest
        JR   Z,spuu2
        LD   A,#31
        JP   bcku
spuu2:  LD   C,#F9
        JP   bpuku2
ld161:  EX   DE,HL
        CALL iitest
        JR   Z,ldk1
        SUB  40
        ADD  A
        ADD  A
        ADD  A
        ADD  A
        LD   C,A
        LD   A,B
        CALL kltest
        JR   NZ,ldk2
        CALL wred
        LD   A,C
        ADD  75
        JP   bcku
ldk2:   LD   A,C
        INC  A
        JP   bcku
ldk1:   CALL kltest
        LD   A,B
        LD   C,#2A
        JR   Z,ldk11
        LD   C,#21
ldk11:  CALL bpuku2
        JP   wordw
ld162:  CP   43
        JR   NZ,ld163
        CALL kltest
        SCF
        RET  NZ
        CALL wred
        LD   A,#73
        JP   bcku
ld163:  CALL iitest
        JR   Z,ldk22
        SUB  40
        ADD  A
        ADD  A
        ADD  A
        ADD  A     
        LD   B,A
        CALL kltest
        SCF
        RET  NZ
        CALL wred
        LD   A,B
        ADD  #43
        JP   bcku
ldk22:  CALL kltest
        SCF
        RET  NZ
        LD   A,C
        LD   C,#22
        JR   ldk11
ld81:   CALL reg8t                ; C->FALSE
        JR   C,ld.r__
        LD   A,B
        CALL reg8t
        JR   C,ld.r__
        SUB  30
        ADD  A
        ADD  A
        ADD  A
        ADD  C
        ADD  34
        CP   #76
        SCF
        RET  Z
        JP   wrbuf
ld.r__: LD   A,B
        CP   37
        LD   A,C
        JR   Z,ld.a__
        CP   37
        JR   NZ,ld.r_n
        LD   A,B
        CP   53
        JR   NZ,lds1
        LD   A,#12
        JP   wrbuf
lds1:   CP   52
        JR   NZ,lds2
        LD   A,2
        JP   wrbuf
lds2:   CP   39
        JR   NZ,lds3
        LD   C,#4F
        JR   ldk1
lds3:   CP   38
        JR   NZ,lds4
        LD   C,#47
ldk1:   CALL wred
        LD   A,C
        JP   wrbuf
lds4:   CALL xyte
        JP   NC,ld.y^
        LD   C,#32
        JR   lds4ku
ld.a__: CP   53
        JR   NZ,lds5
        LD   A,#1A
        JP   wrbuf
lds5:   CP   52
        JR   NZ,lds6
        LD   A,10
        JP   wrbuf
lds6:   CP   39
        JR   NZ,lds7
        LD   C,#5F
        JR   ldk2
lds7:   CP   38
        JR   NZ,lds8
        LD   C,#57
ldk2:   CALL wred
        LD   A,C
        JP   wrbuf
lds8:   CALL xyte
        JP   NC,ld.^y
        LD   H,D
        LD   L,E
        LD   C,#3A
lds4ku: CALL kltest
        JR   NZ,ld.rn
        LD   A,C
        CALL wrbuf
        JP   wordw
ld.r_n: CALL reg8t
        LD   A,B
        JR   NC,ld.r_1
        CALL reg8t
        JR   C,ld.x_n
ld.r_1: CALL xyte
        JR   NC,ld.y^
        LD   A,C
        CALL xyte
        JR   NC,ld.^y
ld.rn:  LD   A,B
        CALL reg8t
        RET  C
        SUB  30
ld.rn2: EX   DE,HL
        ADD  A
        ADD  A
        ADD  A
        ADD  6
ld.rn3: CALL wrbuf
        CALL arg8b
        RET  C
        JP   wrbuf
ld.x_n: CALL ixiyte
        RET  C
        INC  HL
        LD   A,#36
        CALL i1b
        RET  C
        EX   DE,HL
        CALL arg8b
        RET  C
        JP   wrbuf
ld.y^:  INC  HL
        CALL ixiyte
        RET  C
        LD   A,C
        ADD  #52
        JP   i1b
ld.^y   EX   DE,HL
        CALL ixiyte
        RET  C
        LD   A,B
        SUB  30
        ADD  A
        ADD  A
        ADD  A
        ADD  #46
        LD   B,(HL)
        INC  HL
        JP   i1b
bino:   LD   L,B
        LD   B,C
        LD   C,L
        LD   HL,#40DB
        EX   DE,HL
        JR   bi.o
bout:   LD   DE,#41D3
bi.o:   LD   A,C
        CALL reg8t
        RET  C
        CP   38
        CCF
        RET  C
        CP   36
        SCF
        RET  Z
        LD   A,B
        CP   55
        LD   A,C
        JR   NZ,bi.o2
bi.o1:  SUB  30
        ADD  A
        ADD  A
        ADD  A
        ADD  D
        LD   D,A
        CALL wred
        LD   A,D
        JP   wrbuf
bi.o2:  CP   37
        SCF
        RET  NZ
        CALL kltest
        SCF
        RET  NZ
        LD   A,E
        JR   ld.rn3
;
orig:   CALL arg16b
        RET  C
        LD   A,(cassf)
        OR   A
        JR   NZ,cassog
        PUSH DE
        LD   HL,(og)
        EX   DE,HL
        SBC  HL,DE
        POP  DE
        JR   C,mf_
        LD   HL,(labad)
        SBC  HL,DE
        JR   C,mf_
        LD   (freeme),HL
        PUSH DE
        POP  IY
cassog: LD   (og),DE
        LD   (pc),DE
        RET
mf_:    LD   A,7
        JP   err
defb:   CALL arg8b
        RET  C
        CALL wrbuf
        CALL kommt
        JR   Z,defb
        RET
defw:   CALL arg16b
        RET  C
        CALL wordw2
        CALL kommt
        JR   Z,defw
        RET
defs:   CALL arg8b
        RET  C
        LD   E,A
defsl1: LD   A,E
        OR   A
        RET  Z
        XOR  A
        CALL wrbuf
        DEC  E
        JR   defsl1
defm:   LD   A,(HL)
        INC  HL
        CP   9
        SCF
        RET  NZ
defmlo: LD   A,(HL)
        INC  HL
        CP   9
        JR   Z,defk_1
        OR   A
        RET  Z
        CALL wrbuf
        JR   defmlo
defk_1: CALL kommt
        JR   Z,defm
        RET
mf2_:   LD   A,6
        JP   err
ent:    CALL arg16b
        RET  C
        LD   (et),DE
        RET
brk:    LD   A,#F7
        JP   wrbuf
pend:   POP  HL
        AND  A
        RET
kommt:  LD   A,(HL)
        INC  HL
        XOR  10
        RET  Z
        DEC  HL
        RET
wred:   LD   A,#ED
wrbuf:  LD   I,A
        PUSH DE
        LD   A,(cassf)
        OR   A
        JR   Z,wbuf2
        LD   A,(pflag)
        OR   A
        JR   Z,wbuf1
        LD   A,I
        CALL #BC95
        AND  A
        JR   wbuf3
wbuf2:  LD   DE,(freeme)
        LD   A,D
        OR   E
        JR   Z,mf2_
        DEC  DE
        LD   (freeme),DE
wbuf3:  LD   A,I
        LD   (IY),A
        INC  IY
wbuf1:  LD   A,(pcadd)
        INC  A
        LD   (pcadd),A
        POP  DE
        RET
disrec: LD   A,(pflag)
        OR   A
        RET  Z
        CALL arg16b
        RET  C
        PUSH HL
        EX   DE,HL
        LD   DE,(pc)
        SBC  HL,DE
        DEC  HL
        DEC  HL
        LD   A,H
        CP   #FF
        JR   NZ,dis1
        LD   A,L
        CP   #80
        JR   C,diserr
        POP  HL
        RET
dis1:   OR   A
        JR   NZ,diserr
        LD   A,L
        CP   130
        CCF
        JR   C,diserr
        POP  HL
        RET
diserr: LD   A,3
        JP   err
arg8b:  PUSH DE
        CALL arg16b
        JR   C,arg8b1
        LD   A,D
        OR   A
        LD   A,E
        POP  DE
        RET  Z
        JP   ov_
arg8b1: POP  DE
        RET
arg16b: CALL arg161
        RET  C
arg162: LD   A,(HL)
        CP   14
        CCF
        RET  NC
        CP   21
        RET  NC
        INC  HL
        LD   I,A
        PUSH DE
        CALL arg161
        LD   B,H
        LD   C,L
        POP  HL
        RET  C
        LD   A,I
        SUB  14
        PUSH IX
        LD   IX,mathta
        CALL tabrec                       ;HL=1.WERT;DE=2.WERT
        POP  IX
        JR   NC,arg169
        LD   A,(pflag)
        OR   A
        JP   NZ,ov_
        LD   H,0
arg169: EX   DE,HL
        LD   H,B
        LD   L,C
        JR   arg162
arg161: LD   A,(HL)
        OR   A
        SCF
        RET  Z
        INC  HL
        LD   D,0
        CP   65
        JR   C,a161
        SUB  65
        LD   E,A
        RET
a161:   CP   8
        JR   Z,label
        JR   NC,sond
        CP   5
        JR   NC,a162
        LD   D,(HL)
        INC  HL
a162:   LD   E,(HL)
        INC  HL
        AND  A
        RET
sond:   CP   13
        JR   NZ,anf16
        LD   DE,(pc)
        AND  A
        RET
anf16:  CP   9
        SCF
        RET  NZ
        LD   D,(HL)
        INC  HL
        LD   A,(HL)
        INC  HL
        CP   10
        JR   NC,anf161
        LD   E,D
        LD   D,0
        AND  A
        RET
anf161: LD   E,A
        LD   A,(HL)
        INC  HL
        CP   10
        CCF
        RET  NC
        JP   ov_
label:  LD   A,(pflag)
        OR   A
        JR   NZ,labl5
        LD   DE,0
        CALL w1lo
        AND  A
        RET
labl5:  EX   DE,HL
        LD   HL,(labado)
labl0:  LD   C,(HL)
        DEC  HL
        LD   B,(HL)
        DEC  HL
        DEC  HL
        DEC  HL
        LD   A,B
        OR   C
        LD   A,5
        JP   Z,err        
        EX   DE,HL
        PUSH HL
labl1:  LD   A,(BC)
        CP   (HL)
        INC  BC
        INC  HL
        JR   NZ,lable0
        RLCA
        JR   NC,labl1
        JR   lable1
lable0: POP  HL
        EX   DE,HL
        JR   labl0
lable1: POP  BC
        EX   DE,HL
        INC  HL
        LD   B,(HL)
        INC  HL
        LD   C,(HL)
        EX   DE,HL
        LD   D,B
        LD   E,C
        AND  A
        RET
labeld: LD   D,H
        LD   E,L
        CALL w1lo
        LD   A,(pflag)
        OR   A
        JP   NZ,ass
        LD   IX,(labad)
        LD   (IX),E
        LD   (IX+#FF),D
        LD   A,(HL)
        CP   168
        JR   NZ,nldef
        INC  HL
        CALL arg16b
        RET  C
        JR   labmai
nldef:  LD   DE,(pc)
labmai: LD   (IX+#FE),E
        LD   (IX+#FD),D
        XOR  A
        LD   (IX+#FC),A
        LD   (IX##FB),A
        PUSH HL
        PUSH IX
        POP  HL
        AND  A
        LD   DE,4
        SBC  HL,DE
        LD   (labad),HL
        INC  DE
        INC  DE
        LD   HL,(freeme)
        SBC  HL,DE
        JP   C,mf_
        INC  HL
        INC  HL
        LD   (freeme),HL
        POP  HL
        JP   aa
plus:   AND  A
        ADD  HL,DE
        RET
minus:  AND  A
        SBC  HL,DE
        RET
mul:    PUSH BC
        LD   B,H
        LD   C,L
        AND  A
        LD   HL,0
        LD   A,16
mult1:  ADD  HL,HL
        RL   E
        RL   D
        JR   NC,notadd
        ADD  HL,BC
        JR   NC,notadd
        INC  DE
notadd: DEC  A
        JR   NZ,mult1
mul1:   POP  BC
        AND  A
        RET
divide: LD   A,E
        OR   D
        SCF
        RET  Z
        PUSH BC
        LD   B,H
        LD   C,L
        LD   HL,0
        LD   A,B
        LD   B,16
div1:   RL   C
        RLA
        RL   L
        RL   H
        PUSH HL
        SBC  HL,DE
        CCF
        JR   C,div2
        EX   (SP),HL
div2:   INC  SP
        INC  SP
        DJNZ div1
        EX   DE,HL
        RL   C
        LD   L,C
        RLA
        LD   H,A
        POP  BC
        AND  A
        RET
band:   LD   A,H
        AND  D
        LD   H,A
        LD   A,L
        AND  E
        JR   bxork
bor:    LD   A,H
        OR   D
        LD   H,A
        LD   A,L
        OR   E
        JR   bxork
bxor:   LD   A,H
        XOR  D
        LD   H,A
        LD   A,L
        XOR  E
bxork:  LD   L,A
        AND  A
        RET
;Test-Routinen
ixiyte: CP   47
        RET  C
        CP   51
        CCF
        RET  C
        PUSH HL
        PUSH BC
        LD   B,A
        CP   48
        JR   Z,ixiyk1
        CP   50
        JR   Z,ixiyk1
ixylo:  CALL elemew
        CCF
        JR   C,w3
        LD   A,(HL)
        CP   12
        JR   NZ,ixylo
        LD   A,B
ixiyk1: CP   49
        LD   A,#DD
        JR   C,w4
        LD   A,#FD
w4:     CALL wrbuf
        AND  A
w3:     POP  BC
        POP  HL
        RET
reg8t:  CP   30
        RET  C
        CP   38
        CCF
        RET
reg16t: CP   40
        CCF
        RET  NC
        CP   47
        RET
iitest: CP   42
        RET  Z
        CP   46
        RET  Z
        CP   45
        RET
kltest: LD   A,(HL)
        CP   11
        RET  NZ
        INC  HL
        RET
cctest: CP   31
        JR   NZ,cc1
        ADD  28
cc1:    CP   56
        RET  C
        CP   64
        CCF
        RET  C
        SUB  56
        RET
xyte:   CP   47
        RET  C
        CP   51
        CCF
        RET
elemew: LD   A,(HL)
        INC  HL
        CP   65    
        CCF
        RET  C
        CP   1
        RET  Z
        CP   8
        JR   NC,w1
        CP   5
        JR   NC,eleme1
        INC  HL
eleme1: INC  HL
        SCF
        RET
w1:     CP   9
        JR   NC,w2
w1lo:   LD   A,(HL)
        INC  HL
        OR   A
        RET  Z
        RLCA
        RET  C
        JR   w1lo
w2:     SCF
        RET  NZ
w2lo:   LD   A,(HL)
        INC  HL
        OR   A
        RET  Z
        CP   9
        SCF
        RET  Z
        JR   w2lo
pstab:  DEFW orig,defb,defw,defs,defm,brk,ent,pend
ag1t:   DEFW bret,brst,binc,bdec,bpop,bjp,bcall,bjr,bdjnz,bpush
ag2t:   DEFW bjpc,bjrcc,bld,bino,bex,bout,bcallc,bbit,bres,bset,badd
        DEFW badc,bsbc,bsub
;-ABW
;
abw:    CALL b.uebe
        INC  IY
        JR   Z,a_b.w1
        CALL st_>in
a_b.w1: LD   A,0
        CALL wrbuf2
        RET  C
        LD   BC,bbuff
        PUSH IY    
        POP  HL
        SBC  HL,BC
        LD   A,L
        LD   (bbuff),A
        LD   E,A
        RET
st_>in: CP   59
        JP   Z,remar2
        LD   (arg1bu),HL
        CALL arg.ho
        DEC  HL
        LD   A,(HL)
        INC  HL
        CP   58
        JR   NZ,stw@1
        CALL lab[]
        RET  C
        CALL fintst
        JR   Z,inilo
        LD   (arg1bu),HL
        CALL arg.ho    
stw@1:  LD   A,B
        LD   (arg1bf),A
        JP   psts
weit'3: CALL fintst
        JP   Z,noarg
        CALL arg.h2
        JP   NC,onearg
        CALL b.uebe
        CP   44
        JP   NZ,onearg
        INC  HL
        CALL fintst
        SCF
        RET  Z
        JP   twoarg
inilo:  LD   A,(HL)
        OR   A
        RET  Z
        CP   32
        JR   NZ,weit^5
        INC  HL
        JR   inilo
weit^5: CALL ztest
        JP   C,weit_4
        JP   weit_3
weit^7: LD   A,(HL)
        INC  HL
        CP   35
        JP   Z,hexz
        CP   37
        JP   Z,bin
        CP   34
        JP   Z,texti
        CP   59
        JP   Z,remark
        LD   DE,sond.z
        CALL b.test
        JR   NC,weit^1
        ADD  9
        CALL wrbuf2
        JR   inilo
weit^1: DEC  HL
        LD   (IY),8
        PUSH HL
        CALL arg.h1
        POP  HL
        LD   A,B
        CP   7
        JR   C,wei^10
        LD   B,6
wei^10: CALL lablo
        CALL arg.h1
        JR   inilo
weit_3: PUSH HL
        PUSH HL
        CALL arg.ho
        POP  HL
        CP   1
        JR   NZ,weit'2
        INC  B
weit'2: LD   DE,kl_tok
        CALL instr
        JR   NC,weit^6
        ADD  30
        CALL wrbuf2
        POP  DE
        JP   inilo
weit^6: POP  HL
        JR   weit^7
weit_4: LD   DE,#020A
        JR   zahlo
hexz:   LD   DE,#0310
        JR   zahlo
bin:    LD   DE,#0402
zahlo:  PUSH DE
        PUSH HL
        CALL arg.h1
        POP  HL
        POP  DE
        LD   C,E
        PUSH DE
        CALL zahla
        POP  BC
        RET  C
        LD   A,D
        OR   A
        LD   A,B
        JR   NZ,kue#7
        CP   2
        JR   NZ,zah'3
        LD   A,E
        CP   191
        LD   A,B
        JR   NC,zah'3
        LD   A,E
        ADD  65
        LD   E,A
        JR   zah'2
zah'3:  ADD  3
        CALL wrbuf2
        JR   zah'2
zah'1:  LD   A,B
kue#7:  CALL wrbuf2
        LD   (IY),D
        INC  IY
zah'2:  LD   (IY),E
        INC  IY
        JP   inilo
texti:  LD   A,9
textil: CALL wrbuf2
        LD   A,(HL)
        INC  (HL)
        OR   A
        RET  Z
        CP   34
        JR   NZ,textil
end#9:  LD   A,9
        CALL wrbuf2
        JP   inilo
b.uebe: LD   A,(HL)
        INC  HL
        CP   32
        JR   Z,b.uebe
        DEC  HL
        OR   A
        RET
lab[]:  LD   HL,(arg1bu)
        LD   (IY),192
        DEC  B
        SCF
        RET  Z
        LD   A,B
        CP   7
        JR   C,lablo1
        LD   B,6
lablo1: CALL lablo
lablo5: LD   A,(HL)
        INC  HL
        CP   58
        JR   NZ,lablo5
        RET
lablo:  INC  IY
        LD   A,(HL)
        CALL gr'klb
        LD   (IY),A
        INC  HL
        DJNZ lablo
        OR   #80
        JP   wrbuf2
kl'grb: CP   #61
        RET  C
        CP   #7B
        RET  NC
        SUB  #20
        RET
gr'klb: CP   #41
        RET  C
        CP   #5B
        RET  NC
        ADD  #20
        RET
;
remark: DEC  HL
remar2: LD   A,1
remo:   CALL wrbuf2
        INC  HL
        LD   A,(HL)
        OR   A
        RET  Z
        JR   remlo
pstst:  LD   DE,pseudo
        LD   C,B
        PUSH HL
        LD   HL,(arg1bu)
        CALL instr
        JR   NC,end#3
        LD   A,160
        OR   C
        CALL wrbuf2
        POP  DE
        JP   inilo
end#3:  POP  HL
        LD   B,C
        JP   weit'3
;
noarg:  LD   DE,ag0
        LD   A,32
        JR   kue#4
onearg: LD   DE,ag1
        LD   A,96
        JR   kue#4
twoarg: LD   DE,ag2
        LD   A,128
kue#4:  LD   I,A
        LD   HL,(arg1bu)
        LD   A,(arg1bf)
        LD   B,A
        CALL instr
        CCF
        RET  C
        CP   14
        JR   C,kue'1
        LD   A,I
        CP   32
        JR   NZ,kue'2
        LD   A,C
        SUB  14
        OR   64
        JR   kue'3
kue'1:  LD   A,I
kue'2:  OR   C
kue'3:  CALL wrbuf2
        JP   inilo
;--INSTR C->TRUE
instr:  LD   C,0
p@0:    PUSH BC
        PUSH DE
        PUSH HL
p@1:    LD   A,(DE)
        OR   A
        JR   Z,ret@2
        CP   (HL)
        JR   NZ,p@2
p@4:    CP   32
        JR   Z,ret@1
        INC  HL
        INC  DE
        DJNZ p@1
        LD   A,(DE)
        CP   32
        JR   NZ,p@2
ret@1:  LD   A,C
        SCF
ret@2:  POP  BC
        POP  DE
        POP  BC
        RET
p@2:    POP  HL
        POP  DE
        POP  BC
        INC  C
spacew: LD   A,(DE)
        INC  DE
        OR   A
        RET  Z
        CP   32
        JR   Z,p@0
        JR   spacew
;
spac:   LD   A,32
wrbuf2: LD   (IY),A
        INC  IY
        RET
;
arg.h2: LD   DE,arg.z2
        JR   argho2
arg.g1: LD   DE,arg.z1
        JR   argho2
arg.ho: LD   B,0
argl#1: LD   A,(HL)
        OR   A
        RET  Z
        CP   59
        RET  Z
        CALL kl'grb
        LD   (HL),A
        CALL b.test
        RET  C
        INC  HL
        INC  B
        JR   argl#1
b.test: PUSH DE
        PUSH BC
        LD   C,1
        LD   B,A
bte#1:  LD   A,(DE)
        OR   A
        JR   Z,end#2
        CP   B
        JR   Z,end#1
        INC  DE
        INC  C
        JR   bte#1
end#1:  SCF
end#2:  LD   A,C
        POP  BC
        POP  DE
        RET
;
zahla:  LD   DE,0
        LD   (zwbuf1),DE
zahl.a: PUSH BC
        CALL wash
        JR   NC,tende
        CP   C
        JR   NC,tende
        LD   B,C
        LD   C,A
        CALL zausre
        JR   C,tende
        POP  BC
        DJNZ zahl.a
        LD   DE,(zwbuf1)
        RET
tende:  POP  BC
        SCF
        RET
;
zausre: PUSH HL
        DEC  B
        LD   Hl,(zwbuf1)
        LD   D,H
        LD   E,L
zaulo1: ADD  HL,DE
        DJNZ zaulo1
        ADD  HL,BC
        LD   (zwbuf1),HL
        POP  HL
        RET
wash:   LD   A,(HL)
        CALL kl'grb
        INC  HL
        SUB  48
        CP   10
        RET  C
        CP   17
        CCF
        RET  NC
        CP   23
        RET  NC
        SUB  7
        SCF
        RET
;
ztest:  CP   58
        RET  NC
        CP   48
        CCF
        RET
fintst: CALL b.uebe
        RET  Z
        CP   59
        RET
;
sondts: DEFM "&%"
arg.z1: DEFM ")"
arg.z:  DEFM "+"
        DEFM "$-*/&?! "
arg.z2: DEFB ",",59,34,0
zwbuf1: DEFW 0
arg1bu: DEFW 0
arg1bf: DEFB 0
;
;BAW
;
baw:    EX   DE,HL
        LD   HL,ciibuf
        LD   B,80
crloo:  LD   (HL),32
        INC  HL
        DJNZ crloo
        LD   (HL),B
        EX   DE,HL
        INC  HL
        CALL main
        LD   (IY),0
        RET
main:   LD   IY,ciibuf
ma1:    LD   A,(HL)
        INC  HL
        OR   A
        RET  Z
        CP   1
        JR   Z,rem3
        LD   C,A
        AND  %11111
        LD   B,A
        LD   A,C
        AND  %11100000
        LD   DE,ag0
        CP   32
        JR   Z,beflis
        LD   DE,ag0'
        CP   64
        JR   Z,beflis
        LD   DE,ag1    
        CP   96
        JR   Z,beflis
        LD   DE,ag2
        CP   128
        JR   Z,beflis
        CP   192
        JR   Z,g4'
        CP   160
        RET  NZ
        LD   DE,pseudo
beflis: LD   IY,ciibef
        LD   C,0
        CALL zsu1
        JR   main1
g4':    LD   IY,ciibuf
        CALL lbloo
        LD   A,58
        CALL wrbuf2
        JR   ma1
lbloo:  LD   A,(HL)
        INC  HL
        BIT  7,A
        JR   NZ,lbend
        CALL wrbuf2
        JR   lbloo
lbend:  RES  7,A
        JP   wrbuf2
rem2:   LD   DE,ciirem
        PUSH HL
        PUSH IY
        POP  HL
        CALL hl=de_
        JR   C,rem2k1
        EX   DE,HL
        INC  DE
rem2k1: PUSH DE
        POP  IY
        POP  HL
rem3:   LD   A,59
        CALL wrbuf2
rem1lo: LD   A,(HL)
        INC  HL
        OR   A
        RET  Z
        CALL wrbuf2
        JR   rem1lo
main1:  LD   IY,ciikon
main2:  LD   A,(HL)
        INC  HL
        OR   A
        RET  Z
        CP   1
        JR   Z,rem2
        CP   8
        JR   C,zahlen
        JP   Z,labels
        CP   21
        JP   C,sondz
        CP   65
        JR   C,kl'1
        SUB  65
        LD   E,A
        LD   D,0
        JR   dez
kl'1:   LD   DE,kl_tok
        LD   C,30
        LD   B,A
        CALL zsu1
        JR   main2
zahlen: CP   5
        LD   D,0
        JR   NC,zahl'2
        ADD  3
zahl'1: LD   D,(HL)
        INC  HL
zahl'2: LD   E,(HL)
        INC  HL
        CP   6
        JR   Z,hex
        CP   7
        JP   Z,binb
dez:    PUSH HL
        XOR  A
        LD   (hbool),A
        EX   DE,HL
        LD   DE,10000
        CALL divrou
        LD   DE,1000
        CALL divrou
        LD   DE,100
        CALL divrou
        LD   DE,10
        CALL divrou
        LD   A,L
        CALL speich
        POP  HL
        JR   main2
divrou: CALL divide
        LD   A,L
        OR   A
        JR   NZ,speich
        LD   A,(hbool)
        OR   A
        JR   Z,spee
        LD   A,L
speich: ADD  48
        LD   (hbool),A
        CALL wrbuf2
spee:   EX   DE,HL
        RET
hex:    CALL hex'1
        JP   main2
hex'1:  LD   A,35
        CALL wrbuf2
        LD   A,D
        OR   A
        JR   Z,hex4
hex':   CALL hex8
hex4:   LD   A,E
        JP   hex8
hex8:   LD   C,A
        RRA
        RRA
        RRA
        RRA
        CALL outp
        LD   A,C
outp:   AND  %1111
        CP   10
        JR   C,deci
        ADD  7
deci:   ADD  48
        JP   wrbuf2
binb:   CALL binb'1
        JP   main2
binb'1: LD   A,37
        CALL wrbuf2
        XOR  A
binb':  LD   (hbool),A
        LD   A,D
        OR   A
        JR   Z,bink
        CALL bin8
bink:   LD   A,E
        JP   bin8
bin8:   LD   B,7
bin8l:  BIT  7,A
        LD   C,A
        CALL boutp
        LD   A,C
        RLA
        DJNZ bin8l
        BIT  7,A
        JR   Z,binex2
boutp:  LD   A,49
        JR   NZ,binex1
        LD   A,(hbool)
        OR   A
        RET  Z
binex2: LD   A,48
        JR   binex
binex1: LD   (hbool),A
binex:  JP   wrbuf2
labels: CALL lbloo
        JP   main2
sondz:  CP   9
        JP   Z,txta
sond1:  EX   DE,HL
        LD   HL,sonz_
        SUB  9
        LD   B,0
        LD   C,A
        ADD  HL,BC
        LD   A,(HL)
        CALL wrbuf2
        EX   DE,HL
        JP   main2
txta:   LD   A,34
txtal:  CALL wrbuf2
txtal': LD   A,(HL)
        INC  HL
        OR   A
        RET  Z
        CP   9
        JR   Z,sond1
        JR   txtal
zsu1:   LD   A,B
        CP   C
        JR   Z,zsuen
        CALL weire
        INC  C
        JR   zsu1
zsuen:  LD   A,(DE)
        CP   32
        RET  Z
        CALL wrbuf2
        JR   zsuen
weire:  LD   A,(DE)
        INC  (DE)
        CP   32
        RET  Z
        JR   weire        
sonz_:  DEFB 34
sond.z: DEFM ",()$+-*/&?!"
        DEFB 0
hbool:  DEFB 0
kl_tok: DEFM "B C D E H L (HL) A I R BC DE HL SP AF IX IY "                
        DEFM "(IX+ (IX) (IY+ (IY) AF' (BC) (DE) (SP) (C) "
        DEFM "NZ Z NC C PO PE P M "
        DEFB 0
pseudo: DEFM "ORG DEFB DEFW DEFS DEFM BRK ENT END EQU "
        DEFB 0
ag0:    DEFM "RET NOP RLA RRA DAA CPL CCF SCF EXX HALT DI RLCA EI RRCA "
ag0':   DEFM "NEG RRD RLD LDI LDD INI IND CPU CPD IM0 IM1 IM2 RETN RETI "
        DEFM "OUTI OUTD LDIR LDDR CPIR CPDR INIR INDR OTIR OTDR "
        DEFB 0
ag1:    DEFM "ADD ADC SUB SBC AND XOR OR CP RLC RRC RL RR SLA SRA SLL "
        DEFM "SRL RET RST INC DEC POP JP CALL JR DJNZ PUSH "
        DEFB 0
ag2:    DEFM "JP JR LD IN EX OUT CALL BIT RES SET ADD ADC SBC "        
        DEFB 0        
noar.d: DEFB #C9,#00,#17,#1F,#27,#2F,#3F,#37,#D9,#76,#F3,#07,#FB,#0F       
noard2: DEFB #44,#67,#6F,#A0,#A8,#A2,#AA,#A1,#A9,#46,#56,#5E
        DEFB #45,#4D,#A3,#AB,#B0,#B8,#B1,#B9,#B2,#BA,#B3,#BB
bbuff:  DEFS 81     
ciibuf: DEFS 8     
ciibef: DEFS 5     
ciikon: DEFS 25        
ciirem: DEFS 47                
