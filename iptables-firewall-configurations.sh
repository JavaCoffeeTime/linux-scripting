#!/bin/bash

echo -e "*** Welcome ***"

checkstatus()
{
opt_checkstatus=1
while [ $opt_checkstatus != 7 ]
do
clear
echo -e "\n\t*** Note: Save your iptables before Stop/Restart the iptables services ***\n"
echo -e "1. Save the iptables\n
2. Status of iptables\n
3. Start iptables services\n
4. Stop iptables services\n
5. Restart iptable services\n
6. Flush iptables (**Use carefully it will remove all the rules from iptables**)\n
7. Go back to main menu"
read opt_checkstatus
case $opt_checkstatus in
1) echo -e "*******************************************************\n" 
/etc/init.d/iptables save 
echo -e "\n*****************************************************\n"
echo -e "Press enter key to continue..."
read temp;;
2) echo -e "*******************************************************\n"
/etc/init.d/iptables status 
echo -e "*******************************************************"
echo -e "Press enter key to continue..."
read temp;;
3) echo -e "*******************************************************\n"  
/etc/init.d/iptables start 
echo -e "*******************************************************\n"
echo -e "Press enter key to continue..."
read temp;;
4) echo -e "*******************************************************\n"
/etc/init.d/iptables stop
echo -e "*******************************************************\n"
echo -e "Press enter key to continue..."
read temp;;
5) echo -e "*******************************************************\n"
/etc/init.d/iptables restart 
echo -e "*******************************************************\n"
echo -e "Press enter key to continue..."
read temp;;
6) iptables -F 
echo -e "*******************************************************"
echo -e "All the rules from the iptables are flushed!!!"
echo -e "*******************************************************\n"
echo -e "Press enter key to continue..."
read temp;;
7) main;;
*) echo -e "Wrong option selected!!!"
esac
done
}
buildfirewall()
{
echo -e "Using which chain of filter table?\n
1. INPUT
2. OUTPUT
3. FORWARD"
read opt_ch
case $opt_ch in
1) chain="INPUT" ;;
2) chain="OUTPUT" ;;
3) chain="FORWARD" ;;
*) echo -e "Wrong option selected!!!"
esac
echo -e "
1. Firewall using single source IP\n
2. Firewall using source subnet\n
3. Firewall using for all source networks\n"
read opt_ip
case $opt_ip in
1) echo -e "\nPlease enter the IP address of the source"
read ip_source ;;
2) echo -e "\nPlease enter the source subnet (e.g 192.168.10.0/24)"
read ip_source ;;
3) ip_source="0/0" ;;
*) echo -e "Wrong Option Selected"
esac
echo -e "
1. Firewall using single destination IP\n
2. Firewall using destination subnet\n
3. Firewall using for all destination networks\n"
read opt_ip
case $opt_ip in
1) echo -e "\nPlease enter the IP address of the destination"
read ip_dest ;;
2) echo -e "\nPlease enter the destination subnet (e.g 192.168.10.0/24)"
read ip_dest ;;
3) ip_dest="0/0" ;;
*) echo -e "Wrong option selected"
esac
echo -e "
1. Block all traffic of TCP
2. Block specific TCP service
3. Block specific port
4. Using no protocol"
read proto_ch
case $proto_ch in
1) proto=TCP ;;
2) echo -e "Enter the TCP service name: (CAPITAL LETTERS!!!)"
read proto ;;
3) echo -e "Enter the port name: (CAPITAL LETTERS!!!)" 
read proto ;;
4) proto="NULL" ;;
*) echo -e "Wrong option selected!!!"
esac
echo -e "What to do with rule?
1. Accept the packet
2. Reject the packet
3. Drop the packet
4. Create log"
read rule_ch
case $rule_ch in 
1) rule="ACCEPT" ;;
2) rule="REJECT" ;;
3) rule="DROP" ;;
4) rule="LOG" ;;
esac
echo -e "\n\tPress tnter key to generate the complete rule!!!"
read temp
echo -e "The generated rule is \n"
if [ $proto == "NULL" ]; then
echo -e "\niptables -A $chain -s $ip_source -d $ip_dest -j $rule\n"
gen=1
else
echo -e "\niptables -A $chain -s $ip_source -d $ip_dest -p $proto -j $rule\n"
gen=2
fi 
echo -e "\n\tDo you want to enter the above rule to the IPTABLES? Yes=1 , No=2"
read yesno
if [ $yesno == 1 ] && [ $gen == 1 ]; then
iptables -A $chain -s $ip_source -d $ip_dest -j $rule
else if [ $yesno == 1 ] && [ $gen == 2 ]; then
iptables -A $chain -s $ip_source -d $ip_dest -p $proto -j $rule         
else if [ $yesno == 2 ]; then
main
fi
fi
fi
}
main()
{
ROOT_UID=0
if [ $UID == $ROOT_UID ];
then
clear
opt_main=1
while [ $opt_main != 4 ]
do
echo -e "/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\n" 
echo -e "\t*** Main menu ***\n
1. Check iptables package\n
2. Iptables services\n
3. Build your firewall with iptables\n
4. Exit"
read opt_main
case $opt_main in
1) echo -e "******************************"
rpm -q iptables 
echo -e "******************************" ;;
2) checkstatus ;;
3) buildfirewall ;;
4) exit 0 ;;
*) echo -e "Wrong option selected!!!"
esac
done
else
echo -e "You must be the ROOT to perfom this task!!!"
fi
}
main
exit 0
