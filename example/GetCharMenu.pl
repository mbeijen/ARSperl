#!/usr/local/bin/perl
#
# $Header: /cvsroot/arsperl/ARSperl/example/GetCharMenu.pl,v 1.4 1998/09/16 14:38:31 jcmurphy Exp $
#
# NAME
#   GetCharMenu.pl
#
# USAGE
#   GetCharMenu.pl [server] [username] [password] [menuname]
#
# DESCRIPTION
#   Retrieve and print information about the named menu.
#
# AUTHOR
#   Jeff Murphy
#   jcmurphy@acsu.buffalo.edu
#
# $Log: GetCharMenu.pl,v $
# Revision 1.4  1998/09/16 14:38:31  jcmurphy
# updated changeDiary code
#
# Revision 1.3  1998/02/25 19:21:32  jcmurphy
# updated to printout query if query style menu
#
# Revision 1.2  1997/11/10 23:36:52  jcmurphy
# added refreshCode to the output
#
# Revision 1.1  1996/11/21 20:13:51  jcmurphy
# Initial revision
#
#

use ARS;
require 'ars_QualDecode.pl';

# SUBROUTINE
#   printl
#
# DESCRIPTION
#   prints the string after printing X number of tabs

sub printl {
    my $t = shift;
    my @s = @_;

    if(defined($t)) {
	for( ; $t > 0 ; $t--) {
	    print "\t";
	}
	print @s;
    }
}

($server, $username, $password, $name) = @ARGV;
if(!defined($name)) {
    print "Usage: $0 [server] [username] [password] [menuname]\n";
    exit 0;
}

$ctrl = ars_Login($server, $username, $password);
($finfo = ars_GetCharMenu($ctrl, $name)) ||
    die "error in GetCharMenu: $ars_errstr";

print "** Menu Info:\n";
print "Name        : \"".$finfo->{"name"}."\"\n";
print "helpText    : ".$finfo->{"helpText"}."\n";
print "timestamp   : ".localtime($finfo->{"timestamp"})."\n";
print "owner       : ".$finfo->{"owner"}."\n";
print "lastChanged : ".$finfo->{"lastChanged"}."\n";
print "changeDiary : ".$finfo->{"changeDiary"}."\n";

foreach (@{$finfo->{"changeDiary"}}) {
    print "\tTIME: ".localtime($_->{"timestamp"})."\n";
    print "\tUSER: $_->{"user"}\n";
    print "\tWHAT: $_->{"value"}\n";
}

print "refreshCode : ".$finfo->{"refreshCode"}."\n";
print "menuType    : ".
    ("None", "List", "Query", "File", "SQL")[$finfo->{"menuType"}]." ($finfo->{menuType})\n";

if($finfo->{menuType} == 2) {
    print "menuQuery definitions:\n";
    print "\tschema      : ".$finfo->{menuQuery}{schema}."\n";
    print "\tserver      : ".$finfo->{menuQuery}{server}."\n";
    print "\tlabelField  : ".$finfo->{menuQuery}{labelField}."\n";
    print "\tvalueField  : ".$finfo->{menuQuery}{valueField}."\n";
    print "\tsortOnLabel : ".$finfo->{menuQuery}{sortOnLabel}."\n";
    print "\tquery       : ".$finfo->{menuQuery}{qualifier}."\n";
    $dq = ars_perl_qualifier($finfo->{menuQuery}{qualifier});
    $qualtext = ars_Decode_QualHash($ctrl, 
				    $finfo->{menuQuery}{schema}, 
				    $dq);
    print "\t$qualtext\n";

}

elsif($finfo->{menuType} == 3) {
    print "menuFile definitions:\n";
    print "\tfileLocation  : ".("", "Server", "Client")[$finfo->{menuFile}{fileLocation}]."\n";
    print "\tfilename      : ".$finfo->{menuFile}{filename}."\n";
}

elsif($finfo->{menuType} == 4) {
    print "menuSQL definitions:\n";
    print "\tserver      : ".$finfo->{menuSQL}{server}."\n";
    print "\tsqlCommand  : ".$finfo->{menuSQL}{sqlCommand}."\n";
    print "\tlabelIndex  : ".$finfo->{menuSQL}{labelIndex}."\n";
    print "\tvalueIndex  : ".$finfo->{menuSQL}{valueIndex}."\n";
}

ars_Logoff($ctrl);

exit 0;

