##################################################
# File Name: commonfunc.pl
# Common Functionality for Scripts
# Version 1.0
# 4th May, 2010
# BY: Mohammad Amzad Hossain
# Blog: tohin.wordpress.com
# Email : amjad.hossain@gamil.com
# Comment: Alows multi-servers to run on same PC.
###################################################



#######################################################################
#======================================================================
# AuthorNote: This one is taken from uniserver move_server script ;)
#
# Function: Prompt user and get user input, returns value input by user.
#           Or if return pressed returns a default if used e.g usage
# $name = &promptUser("Enter your name ");
# $serverName = &promptUser("Enter your server name ", "localhost");
#.......................................................................
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
#========================================= End promptUser ============

## Script for executing command :( 

sub execute {
    local($commandstr)  = @_;
    use IPC::Open3;
    #my $pid=open3(\*IN,\*OUT,\*ERR,'/bin/bash');
    my $pid=open3(\*IN,\*OUT,0,'/bin/bash');
    # set \*ERR to 0 to send STDERR to STDOUT


    print IN  $commandstr . "\n";
    my $result = <OUT>;
    print <ERR>; 
    return $result;
}

###################################################################
#==================================================================
# Function: Search and insert after a match
# Call using: update_files(@myarray) @myarray ordered as follows:
# full file path, search str 1,replace str 1, search str 2,replace str 2..
#...................................................................
 
sub insert_into_files {

my @search_info = @_;                # from flattened array @_ create new array 
@search_info=reverse(@search_info);  # re-order to give file path first
my $file = pop(@search_info);        # get first element of array. File to search


open(INFILE,$file) or (print "Could not open $file for reading: $!\n" and return);
my @text=<INFILE>;                   # we have file handle, load file to array for searching
close(INFILE);                       # close file

my @newarray = ();

my $found = 0;                       # Set if string found in array loaded
while (@search_info !=0){            # loop through replacement array until all data used

 $str1 = pop(@search_info);          # search for
 $str2 = pop(@search_info);          # replace with string

 foreach $line (@text){              # loop through array
     push(@newarray, $line);
  if($line=~/$str1/){                # check we have found a match
    push(@newarray, $str2);
    $found = 1;
  }
   
 }#end foreach
}#end while

 if($found){                         # A match was found hence write to file
  open(OUTFILE,">$file") or (print "Unable to open $file for writing:" and return);
    foreach $save(@newarray){            # loop through array set each line to variable $save
     print OUTFILE $save;            # write each line contained in variable $save
    }
  close(OUTFILE);                    # finished close file
 }
}#end sub
#========================================= End sub update_files ====

1;
