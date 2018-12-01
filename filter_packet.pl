:-[input].

ipv4_filter(Packet_ip,Reject_list,Drop_list,Status) :- 
    member(Packet_ip,Reject_list)->Status = 'rejected';
    ([Elem|_] = Drop_list, Elem == 'drop_all')-> Status = 'dropped';
    member(Packet_ip,Drop_list)->Status ='dropped';
    Status = 'accepted'.
    %write(Status) 

%tcp_udp_filter(Packet_port,)


check_ranged(Elem):-
    name(Elem,ElemList),
    % 45 is ascii of '-'
    member(45,ElemList).


packet(Adapter_num,Port,Ip,Output):-
    populate_rule_list(Adapter_num,Port,Reject_list,Drop_list),
    ((traverse_rule_list(Reject_list,Ip,Status),Status=='matched')-> write('rejected'),Output = 'rejected';
    ([Elem|_] = Drop_list, Elem == 'drop_all')-> write('dropped'),Output = 'dropped';
    (traverse_rule_list(Drop_list,Ip,Status),Status=='matched')->write('dropped'),Output = 'dropped';
    write('accepted'),Output = 'accepted'),
    %write(Status),
    nl.

traverse_rule_list([],Ip,Status).
traverse_rule_list([Elem|Text_list],Ip,Status):-
    (check_ranged(Elem)->
        in_range(Elem,Ip)->Status='matched';
        Elem == Ip->Status='matched';true),
    %Status\='matched',
    traverse_rule_list(Text_list,Ip,Status).

in_range(Elem,Ip):-
    split_string(Elem, '-', '', [Lb,Ub|[]]),
    split_string(Lb,'.','',Lower_bound),
    split_string(Ub,'.','',Upper_bound),
    split_string(Ip,'.','',Ip_list),
    ip_to_int(Lower_bound,Lb_int),
    ip_to_int(Upper_bound,Ub_int),
    ip_to_int(Ip_list,Ip_int),
    between(Lb_int,Ub_int,Ip_int).

ip_to_int([N1,N2,N3,N4|[]],Num):-
    atom_number(N1,Int_N1 ),
    atom_number(N2,Int_N2 ),
    atom_number(N3,Int_N3 ),
    atom_number(N4,Int_N4 ),
    Num is (Int_N1*16777216 + Int_N2*65536 + Int_N3*256 +Int_N4).

