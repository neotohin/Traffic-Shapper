#!/usr/bin/perl


package func;
use isp::dbutil;
use isplib::message;
use isplib::isptc;

# This shows ip related Information

sub show_ip_info{
    
    $ip = func->promptUser( 'Insert IP Number', '23' );
    
    $all = dbutil->ip_exists( $ip );
    $count = 0+@$all;
    
    if( $count == 0 )
    {
        message->sys_msg("IP does not Exist! \n");
    }
    else {
        print "Information: \n" ;
        func->single_ip_info( $all ); 
    }
    
}

# Show Result Info For client
sub single_ip_info
{
    local( $class_name, $all )  = @_;
    
    foreach my $temp ( @$all ) 
    {
        print  "\t Client Name:  \t" . $temp->{clientname} . "\n"
        . "\t Client's Mac: \t" . $temp->{mac} . "\n"
        . "\t Lower Limit: \t"  . $temp->{lower_limit} . 'Kbit' . "\n"
        . "\t Upper Limit: \t"  . $temp->{upper_limit} . 'Kbit' . "\n";
        
        last;
    }
    
}


# Creating New Client

sub create_new_client
{
    print 'Insert New IP >> ';
    while( $ip  = <> )
    {
        chomp $ip;
        $ip = int $ip;
        # Invalid IP Take input again
        # TODO : Invalid not working
        if( $ip > 255 && $ip < 0 )
        {
            print "Invalid IP \n";
            next;
        }
        
        $all = dbutil->ip_exists( $ip );
        $count = 0+@$all;
        
        if( $count > 0 )    {
            message->sys_msg('IP Already Assigned');
            func->single_ip_info( $all );
            last; 
        } 
        
        
        # Valid IP Next Operation 
        
        print "Client's Name: ";
        $name = <>;
        chomp $name;
        
        print "Client's MAC: ";
        $mac = <>;
        chomp $mac;
        
        print "Bandwidth Lower Limit: ";
        $lower_limit = <>;
        chomp $lower_limit;
        
        print "Bandwidth Upper Limit: ";
        $upper_limit = <>;
        chomp $upper_limit;
        
        dbutil->insert_client( $ip, $name, $mac, $lower_limit, $upper_limit );
        
        last;
    }
}

# Update Client Info

sub update_client_info
{
    print 'Insert IP to Update>> ';
    while( $ip  = <> )
    {
        chomp $ip;
        $ip = int $ip;
        # Invalid IP Take input again
        # TODO : Invalid not working
        if( $ip > 255 && $ip < 0 )
        {
            print "Invalid IP \n";
            next;
        }
        
        $all = dbutil->ip_exists( $ip );
        $count = 0+@$all;
        
        if( $count == 0 )    {
            message->sys_msg('IP Not Found');          
            last; 
        }
        
        $new_name = func->promptUser('Client Name: ', @$all[0]->{clientname} );
        $new_mac = func->promptUser('Client Mac: ', @$all[0]->{mac} );
        $new_lower_limit = func->promptUser('Bandwidth Lower Limit: ', @$all[0]->{lower_limit} );
        $new_upper_limit = func->promptUser('Bandwidth Upper Limit: ', @$all[0]->{upper_limit} );
        
        dbutil->update_client( $ip, $new_name, $new_mac, $new_lower_limit, $new_upper_limit);
        
                
        last;
    }
}

# Deleting Client's Info

sub delete_client_info
{
    print 'Insert IP to Delete>> ';
    while( $ip  = <> )
    {
        chomp $ip;
        $ip = int $ip;
        # Invalid IP Take input again
        # TODO : Invalid not working
        if( $ip > 255 && $ip < 0 )
        {
            print "Invalid IP \n";
            next;
        }
        
        $all = dbutil->ip_exists( $ip );
        $count = 0+@$all;
        
        if( $count == 0 )    {
            message->sys_msg('IP Not Found');          
            last; 
        }
        
        print "Deleted Client Information. \n";
        func->single_ip_info( $all );
        
        dbutil->delete_client( $ip );
        
                
        last;
    }
}

# Displaying All IP LIST
sub show_all_ip_list {


    $all = dbutil->get_all_client();
    
    print "\n";
    
format top =
IP:            CLIENTNAME:              MAC                       LowerLimit(kbit)   UpperLimit(kbit)
============   =======================  ========================  ================   ===============
.

write;

format STDOUT =
@>>>>>>>>>>>   @<<<<<<<<<<<<<<<<<<<<<< @<<<<<<<<<<<<<<<<<<<<<<<<  @>>>>>>>>>>>>>>>   @>>>>>>>>>>>>>>
$complete_ip   $cname                  $mac                       $min_bw            $mx_bw
------------   ----------------------- -------------------------  ----------------   ---------------
.
    

    foreach my $temp (@$all) {    
    
        
        # defination $clients_{ip} = [name, mac, min_b/w, max_b/w ];
        $ip     = $temp->{ip};
        $cname  = $temp->{clientname};
        $mac    = $temp->{mac};
        $min_bw = $temp->{lower_limit};
        $mx_bw  = $temp->{upper_limit};
        
        $complete_ip = isptc->get_local_ip_series() . '.' . $ip;
        write;
        
   
        
    }
    print "\nTotal Client : " . ( 0+@$all ). "\n\n";
}


#######################################################################
#======================================================================
# AuthorNote: This one is taken from uniserver move_server script ;)
#
# Function: Prompt user and get user input, returns value input by user.
#           Or if return pressed returns a default if used e.g usage
#======================================================================
sub promptUser {
  local($class_name, $promptStr,$defaultVal) = @_;         # make input arguments
                                                # local variables
  if ($defaultVal) {                             # If a default set
     print $promptStr, "[", $defaultVal, "] : "; # Print prompt and defaul
  } else {                                    # No default set
     print $promptStr, ": ";                  # Print prompt only
  } 

  $| = 1;                             # force a flush after our print
  $_ = <STDIN>;                       # get the input from STDIN 

  chomp;                              # remove newline character

  if ("$defaultVal") {                # check default is set 
     return $_ ? $_ : $defaultVal;    # return $_ if it has a value
  } else {                            # not set                          
     return $_;                       # just return entered value
  }
}

1;
