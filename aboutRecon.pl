#!/usr/bin/perl
use CGI::Carp qw(fatalsToBrowser);
require("MYSQL_Setup.pm");

	$IS_TEST = 1;
	
	# Lucian Chenard was here
	
	use CGI;
	my $query	= new CGI;
	$action						= $query->param('a');
	$SESSION_ID 			= $query->param('sid');
	$DIV_ID	    			= $query->param('div');

	require("validateSession.pm");
	&validateSession;	
			
	if    ($action eq "showForm")		{	&showForm;	}
	
	print "Content-type: text/html\n\n";
	print $AJAX_Data;
	exit;
	
###################################################################################################################	
###################################################################################################################
#
#	AUTHENTICATE
#
###################################################################################################################
###################################################################################################################

sub showForm
{	
		&connect_OASIS_SQL;
		$statement = $dbh->prepare( "
	    SELECT COUNT(*)
	    FROM guilds");
		$statement->execute;
		$totalGuilds = $statement->fetchrow_arrayref->[0];
		$statement->finish();
		
		$statement = $dbh->prepare( "
	    SELECT COUNT(*)
	    FROM players");
		$statement->execute;
		$totalPlayers = $statement->fetchrow_arrayref->[0];
		$statement->finish();
		
		$statement = $dbh->prepare( "
	    SELECT COUNT(distinct guildsSEQ)
	    FROM players;");
		$statement->execute;
		$totalReconGuilds = $statement->fetchrow_arrayref->[0];		
		$statement->finish();
				
		&close_OASIS_SQL;
		
	$AJAX_Data =<<EOL;
		<table width="100%" class="auto-style3">
			<tr>
				<td width="25%" class="a_top"><img src="http://www.ivc-players.com/images/reconBanner.jpg" height="200px"></td>
				<td width="75%" class="a_top">
					<b>Mission: Kingdom Age Recon</b><br />
					<br />
					The Kingdom Age recon data is posted to our database by our world wide members.  Players from dozens of guilds
					are working together to provide the most upto date and accurate data possible.<br />
					<br />
					KA Recon has two types of Recon Specialists:<br />
					<br />
					<b>Read Only</b>: You are a primary recon specialist for your guild and to not have a global recon mandate.
					This access provides you the ability to view recon data without contributing.<br />
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<br />
					<b>Read/Write</b>: You are a primary recon specialist for your guild and you want to have the ability to view
					and update recon data in our system.<br />
					<br />
					<b>Total Guilds on file</b>: $totalReconGuilds of $totalGuilds guilds have current data as of the last Epic Battle.<br />
					<b>Total Players on file</b>: $totalPlayers<br />
					<br />
					Do you want to be a recon agent for us?  Please email ivcplayers\@gmail.com with a screen capture of your
					users profile and a description requesting access and provide your Player ID number in the subject line.<br />
					<br />
					Read only access: \$25.00 / month, \$50.00 / 3 months, \$100.00 / year.<br />
					Read/Write access: \$25.00 / month for the 1st month.  Earn \$0.05 cents per new / updated entry credit for all recon work.<br />
				</td>
			</tr>
		</table>
EOL
}
