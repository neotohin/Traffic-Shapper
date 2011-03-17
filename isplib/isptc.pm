#!/usr/bin/perl

package isptc;
use isplib::message;
use isp::dbutil;

# Configure Following variables as per need
# @TODO Will move all this in sqlite settings

our $MAX_UP_LINK    = '10240kbit';
our $MAX_DOWN_LINK  = '10240kbit';
our $ISP_NIC        = 'eth0';
our $LOCAL_NIC      = 'eth1';
our $LOCAL_IP_SERIES = '192.168.0';
our $BW_UNIT        = 'kbit';
our $BW_OTHERS      = '1';
our $SCRIPT_LOCATION = '/home/neotohin/tc_script.sh';

sub get_local_ip_series
{
    return $LOCAL_IP_SERIES;
}

sub execute_traffic_shapping {

    message->sys_msg("Setting Total Uplink....   \n");
    isptc->set_up_down_link( $ISP_NIC,     $MAX_UP_LINK );

    message->sys_msg("Setting Total Downlink.... \n");
    isptc->set_up_down_link( $LOCAL_NIC,   $MAX_DOWN_LINK );

    message->sys_msg("Setting UP-LINK.... \n");
    isptc->set_up_link( $REAL_IP, $ISP_NIC, $MAX_UP_LINK, $MAX_DOWN_LINK );

    $current_flow = 3;
    
    
    isptc->execute_tc("\n# Setting Client's Information ");
    
    $clients = dbutil->get_all_client();
    
    foreach my $client ( @$clients ) {

        # defination $clients_{ip} = [name, mac, min_b/w, max_b/w ];

        $ip     = $client->{ip};
        $cname  = $client->{clientname};
        $mac    = $client->{mac};
        $min_bw = $client->{lower_limit};
        $mx_bw  = $client->{upper_limit};
        
        message->sys_msg(
            sprintf( "Traffic Shapping for : %s.%s Client Name %s MIN B/W %s%s and MAX B/W %s%s ",
                        $LOCAL_IP_SERIES, $ip, $cname, $min_bw, $BW_UNIT, $mx_bw, $BW_UNIT)
        );


        isptc->set_user_downlink( $LOCAL_NIC, $current_flow, $LOCAL_IP_SERIES, $ip, $min_bw, $mx_bw );
        $current_flow++;
    }


    ###### SPECIAL CLOSE for those users who are not listed on this ip 
    isptc->execute_tc("\n# Executing Settings for Non listed ips. ");
    isptc->set_user_downlink( $LOCAL_NIC, $current_flow, $LOCAL_IP_SERIES, '0/24', $BW_OTHERS, $BW_OTHERS);

}

sub set_user_downlink{
    local( $class_name, $local_nic, $flowid, $series, $ip, $min_bw, $max_bw ) = @_;
        
    $command = "tc class add dev $local_nic parent 1:1 classid 1:$flowid htb rate ". $min_bw ."kbit ceil ". $max_bw ."kbit";
    isptc->execute_tc($command);
    $command = "tc qdisc add dev $local_nic parent 1:$flowid handle $flowid: sfq ";
    isptc->execute_tc($command);
    $command = "tc filter add dev $local_nic parent 1:0 protocol ip prio 1 u32 match ip dst $series.$ip flowid 1:$flowid";
    isptc->execute_tc($command);
    
    isptc->execute_tc('');
}

sub set_up_link {
    
    local($class_name, $real_ip, $isp_nic, $mx_up, $mx_down) = @_;
    isptc->execute_tc("\n # Setting Uplink \n");
    
    $command = "tc class add dev $isp_nic parent 1:1 classid 1:2 htb rate $mx_down ceil $mx_up";
    isptc->execute_tc($command);
    $command = "tc qdisc add dev $isp_nic parent 1:2 handle 20: sfq";
    isptc->execute_tc($command);
    $command = "tc filter add dev $isp_nic parent 1:0 protocol ip prio 1 u32 match ip src $real_ip flowid 1:2";
    isptc->execute_tc($command);
}

sub set_up_down_link{
    
    local($class_name, $nic, $limit) = @_;
    isptc->execute_tc("\n # Setting Updown Link \n");
    
    $command = "tc qdisc del dev $nic root";
    isptc->execute_tc($command);
    $command = "tc qdisc add dev $nic root handle 1:0 htb r2q 2";
    isptc->execute_tc($command);
    $command = "tc class add dev $nic parent 1:0 classid 1:1 htb rate $limit"; 
    isptc->execute_tc($command);
};


sub execute_tc{
    local($class_name, $cmd) = @_;

    $file= $SCRIPT_LOCATION;
    
    open (DB,">>$file") || die "Can't Open mailadd: $!\n";

    print DB $cmd . "\n";    

    close DB;    

}

1;


