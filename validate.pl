%% :-Protocol_list = [arp,aarp,atalk,ipx,mpls,netbui,pppoe,rarp,sna,xns].
%% :-Adapter_list = [any,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p].

validate(Adapter, Port, Ip):-
    Adapter == 'Ethernet' -> (
        member(Port, [arp,aarp,atalk,ipx,mpls,netbui,pppoe,rarp,sna,xns]),
        check_ip(Ip)
    );(
        member(Adapter, [any,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p]),
        between(0, 65535, Port),
        check_ip(Ip)).

check_ip(Ip):-true.
