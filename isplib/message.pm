#!/usr/bin/perl 

package message;

sub sys_msg{
    my($class_name, $displaystr) = @_;
    print "#### SYSTEM MESSAGE :  " . $displaystr . "\n",
}



our @MESSAGE_ = (
    {
        STARTUP =>
        
            " \n ##############################################################################\n" .
            " #                                                                            #\n" .
            " # Bandwidth Traffic Management for ISP                                       #\n" .
            " #                                                                            #\n" .
            " #----------------------------------------------------------------------------#\n" .
            " #\tAuthor: Mohammad Amzad Hossain            \t\t\t                                  #\n" .
            " #\tBlog:   tohin.wordpress.com                \t\t\t                                 #\n" .
            " #\tEmail:  amjad.hossain@gmail.com             \t\t\t                                #\n" .
            " # \t\t\t                                                     #\n" .
            " #----------------------------------------------------------------------------#\n",
        
        INIT_CMD =>
        
            "Choose Operation \n" .
            "[1] Run B/W Control on clientlist.pl \n" .
            "[2] Add New Client \n" .
            "[3] Edit Old Client \n" .
            "[4] Check Settings for IP \n" .
            "[5] Show All Assigned IP \n" .
            "[6] Delete IP \n" .
            "[q] Quit \n" .
            "\nPress Your Choice ",
        
    }
);

# Show Message from Defined String Set
sub show_message
{
    local($class, $msg_name) = @_;
    print @MESSAGE_[0]->{$msg_name};
}


1;
