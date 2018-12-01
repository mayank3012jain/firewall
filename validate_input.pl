validate(Adapter, Port, Ip):-
    Adapter == 'ethernet' -> (
        member(Port, [arp,aarp,atalk,ipx,mpls,netbui,pppoe,rarp,sna,xns]),
        check_ip(Ip)
    );(
        member(Adapter, [a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p]),
        validate_port(Port),
        %number(Port),
        %between(0, 65535, Port),
        check_ip(Ip)).

check_ip(Ip):-
    split_string(Ip,".","",Ip_list),
    [N1,N2,N3,N4|[]] = Ip_list,
    atom_number(N1,Int_N1 ),
    atom_number(N2,Int_N2 ),
    atom_number(N3,Int_N3 ),
    atom_number(N4,Int_N4 ),
    between(0,255,Int_N1),
    between(0,255,Int_N2),
    between(0,255,Int_N3),
    between(0,255,Int_N4).

validate_port(Port):-
    split_string(Port,'/','',List),
    [Condition,Port_num|[]] = List,
    member(Condition,["tcp","udp","icmp"]),
    atom_number(Port_num,Num),
    between(0,65535,Num).