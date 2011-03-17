#!/usr/bin/perl 
##################################################
# File Name: bandwidthcontrol.pl
# Startfile :D
# Version 1.0
# 4th May, 2010
# BY: Mohammad Amzad Hossain
# Blog: tohin.wordpress.com
# Email : amjad.hossain@gamil.com
# Comment: Alows multi-servers to run on same PC.
###################################################

use isp::dbutil;
use isplib::message;
use isplib::func;
use isplib::isptc;
 

#dbutil->insert_client( 8, 'tohin', '00:', 233, 333);

    message->show_message('STARTUP');

    my $user_input = '0';
    
    while( true ) 
    {
        message->show_message('INIT_CMD');
        
        $user_input  = func->promptUser( );
    
        if( $user_input == '1' ) 
        {
            # Creating Shell File :) 
            message->sys_msg("Going to Execute");
            isptc->execute_traffic_shapping();
            
        }    
        elsif( $user_input == '2' )
        {
            # Going to Create New Client
            func->create_new_client();
        }
        elsif( $user_input == '3' )
        {
            # Updating Client Information
            func->update_client_info();
        }
        elsif( $user_input == '4')
        {
            # show settings for IP 
            func->show_ip_info( );
        }    
        elsif( $user_input == '5')
        {
            # show all available IP
            func->show_all_ip_list();
        }
        elsif( $user_input == '6')
        {
            # Deleting Client's Info
            func->delete_client_info();
        }  
        elsif( $user_input == 'q')
        {
            &sys_msg("BYE BYE");
            last;
        }
        else
        {
            &sys_msg("Wrong Input. Try Again!");
        }
    
    }


