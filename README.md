## Packet filtering firewall implemented in prolog language. ##

************************************
Executing the program
************************************
1. Load main.pl .
2. Call the predicate filter/4 with the packet header as the arguments to get whether the packet is accepted, rejected or dropped silently.
   Give input in the following format:
    2.1 If ethernet clause is applicable:
            filter('ethernet',+Protocol,+Ip_address,-Output).
        Here +Protocol is the input argument which must be one of the following- [arp,aarp,atalk,ipx,mpls,netbui,pppoe,rarp,sna,xns]
        +Ip_address is input argument containing an IPv4 address of format n.n.n.n where n is an integer value in range 0-255.
        -Output is the output variable which shows whether the packet is accepted rejected or dropped.

        Example:-   filter('ethernet', arp, 172.17.100.1, Output).

    2.2 If ethernet clause is not applicable:
            filter(+Adapter_name,+Port_condition_number,+Ip_address,-Output).
        +Adapter_name is the name of the adapter through which the packet has come. It must a lower case letter in range a-p.
        +Port_condition_number specifies the tcp/udp/icmp protocol and port number in the format protocol/port_number. Port number is an integer in range 0-65535.
            Example:-   tcp/10 , icmp/65535, udp/80
        +Ip_address is input argument containing an IPv4 address of format n.n.n.n where n is an integer value in range 0-255.
        -Output is the output variable which shows whether the packet is accepted rejected or dropped.

        Example:- filter(a, tcp/10, 172.17.100.1, Output).

*************************************
Structure of the firewall
*************************************
                                 Firewall
                                   |
                    ----------------------------------
                    |                                |
                adapter                          ethernet
                    |                                |
        -------------------------                protocols
        |           |           |                    |
       tcp        udp           icmp             IPv4 address
        |           |           |
    IPv4 addr   IPv4 addr   IPv4 addr

We have assumed the firewall to be of Packet Filtering type(all packets are either routed through the firewall or have it as their destination).
We have considered that the firewall has adapter clause and ethernet clause.
The adapter clause has port numbers for tcp udp and icmp conditions. Each port can block different set of IP addresses.
The ethernet clause has several valid protocols with each protocol having unique ip addresses that are blocked.

**************************************
Writing the rules set
**************************************
The rules set need to be written in the file rules_set.txt(The file name cannot be changed).
Each rule starts with the term 'new_rule.', followed by the adapter name or 'ethernet'.
For adapters the next 3 lines contain 'protocol/port_number', the list of rejected Ip addresses and list of dropped Ip address.
For ethernet, the next 3 lines contain 'protocol', the list of rejected Ip addresses and list of dropped Ip address.
These three lines can be repeated any number of times for different ports. Each line has to be terminated with a '.'.
The rule is terminated with 'end_of_rule.'.

List of Ip addresses need to be enclosed within []. The list can be empty or have individual Ip addresses or ranges separated by ','. A range of Ip addresses, from lower to higher needs to be separated by a '-'. Each Ip address or range has to be enclosed within single quotes('').

For adapter clause 'any' can be provided instead of an adapter's name. The any condition is checked if the input adapter name does not match any other adapter.
If a packet does not match any rule, it is dropped by default.

