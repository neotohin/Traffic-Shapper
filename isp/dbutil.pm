#!/usr/bin/perl 

package dbutil;
use isplib::message;

use DBI;

our $client_table = 'isp_client';
my $dbargs = {
			AutoCommit => 1,
            PrintError => 1			
		};

our $dbh = DBI->connect("dbi:SQLite:dbname=isp/myisp.db","","",$dbargs);

sub show_loaded_drivers
{
	@driver_names = DBI->available_drivers();
	print "driver_names (apparently installed, available):\n";
	foreach my $dn (@driver_names)
	{
    	print "$dn\n";
	}
	
}

#	Inserting New Client to This ISP :)
#
sub insert_client
{
	local( $class_name, $ip, $clientname, $mac, $lower_limit, $upper_limit)= @_;

	$dbh->do(
		sprintf( "insert into %s (ip, clientname, mac, lower_limit, upper_limit) VALUES ( %d, '%s', '%s', %d, %d )",
			$client_table, $ip, $clientname, $mac, $lower_limit, $upper_limit 
		)
	);
	
	message->sys_msg("New Client Creation Successful.");

}

#	Updating Client's Information
#
sub update_client
{
	local( $class_name, $ip, $clientname, $mac, $lower_limit, $upper_limit)= @_;

	$dbh->do(
		sprintf( "update %s  set clientname = '%s' , mac = '%s', lower_limit = %d, upper_limit = %d where ip = %d",
			$client_table, $clientname, $mac, $lower_limit, $upper_limit, $ip
		)
	);
	
	message->sys_msg("Client's Information Update Done Successful.");

}

## Delete Specific Ip from isp client
sub delete_client
{
	local( $class_name, $ip) = @_;
	$delete_count = $dbh->do(
		sprintf( "delete from %s where ip = %d", $client_table, $ip)
	);
	print ' Total : ' . $delete_count . " Client's  Removed . \n";
}

## Check Existance of IP
sub ip_exists
{
	local( $class_name, $ip)  = @_;
	
	$all = $dbh->selectall_arrayref("select * from $client_table where ip = $ip",{ Slice => {} });
	
	return $all;
}

## Select all client
sub get_all_client
{
	
	$all = $dbh->selectall_arrayref("select * from $client_table order by ip",{ Slice => {} });
	
	return $all;
}

1;



