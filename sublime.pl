populate_rule_list(Adapter_number_packet, Port_number_packet, Reject_list, Drop_list):-
    %The name of the text file in which rules are to be stored is 'rules_set.txt'
    load_file('rules_set.txt', Stream),
    read_file(Stream, Adapter_number_packet, Port_number_packet, Reject_list, Drop_list),
    format('~w is reject. ~n~w is drop.', [Reject_list, Drop_list]).


read_file(Stream, Adapter_number_packet, Port_number_packet, Reject_list, Drop_list):-
    read(Stream, Predicate),
    ((Predicate == 'adapter') ->(
        read(Stream, Adapter_number_rule),
        (Adapter_number_rule == Adapter_number_packet ->
            read_port(Stream, Port_number_packet, Reject_list, Drop_list);
            read_file(Stream, Adapter_number_packet, Port_number_packet, Reject_list, Drop_list)
        )
        );
        read_file(Stream, Adapter_number_packet, Port_number_packet, Reject_list, Drop_list)
    ).


read_port(Stream, Port_number_packet, Reject_list, Drop_list):-
    read(Stream, Port_number_rule),
    (
        Port_number_rule \= 'end_of_adapter' ->
        (
            read(Stream, Reject_list_temp),
            read(Stream, Drop_list_temp),
            (
                Port_number_packet == Port_number_rule ->
                (
                    Reject_list = Reject_list_temp  ,
                    Drop_list = Drop_list_temp);
                (
                    read_port(Stream, Port_number_packet, Reject_list, Drop_list))
            )
        );
        (
            Reject_list = [],
           Drop_list = ['drop_all']
        )
    ).

load_file(File, Stream):-
    open(File, read, Stream).
