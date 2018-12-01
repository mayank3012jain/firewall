:-[filter_packet].
:-[validate_input].

filter(Adapter,Port,Ip,Output):-
    validate(Adapter,Port,Ip) -> 
    packet(Adapter,Port,Ip,Output);
    write('Invalid input').