#!./perl

#
# test out connecting to an arserver
#

use ARS;
require './t/config';

print "1..2\n";

# make non-oo connect

# test 1 -> login

my($ctrl) = ars_Login($SERVER, $USERNAME, $PASSWORD);
if(!defined($ctrl)) {
  print "not ok\n";
} else {
  print "ok\n";
  ars_Logoff($ctrl);
}

# make an OO connection. note that we disable exception
# catching so we can detect the errors manually.

# test 3 -> constructor

my $c = new ARS(-server => $SERVER, -username => $USERNAME,
		-password => $PASSWORD,
		-catch => { ARS::AR_RETURN_ERROR => undef,
			    ARS::AR_RETURN_WARNING => undef,
			    ARS::AR_RETURN_FATAL => undef
			  });
if($c->hasErrors() || $c->hasFatals() || $c->hasWarnings) {
  print "not ok\n";
} else {
  print "ok\n";
}

# exitting will cause $c to destruct, calling ars_Logoff() in the
# process.

exit 0;
