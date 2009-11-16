# Copyrights 2009 by Mark Overmeer.
#  For other contributors see ChangeLog.
# See the manual pages for details on the licensing terms.
# Pod stripped from pm file by OODoc 1.06.
use warnings;
use strict;

package Net::FTPSSL::Robust;
use vars '$VERSION';
$VERSION = '0.03';

use base 'Net::FTP::Robust', 'Exporter';

our @EXPORT =
  qw/SECURITY_TLS
     SECURITY_SSL/;

use Log::Report 'net-ftpssl-robust', syntax => 'SHORT';

use Net::FTPSSL;
# Gladly, ::FTPSSL has some level of interface compatibility with Net::FTP

use constant
 { SECURITY_TLS => 'TLS'
 , SECURITY_SSL => 'SSL'
 };


sub init($)
{   my ($self, $args) = @_;

    if(my $sec = delete $args->{Security})
    {   $args->{useSSL} =
            $sec eq SECURITY_TLS ? 0
          : $sec eq SECURITY_SSL ? 1
          : error "unknown security protocol {proto}", proto => $sec;
    }

    $self->SUPER::init($args);
    $self;
}


sub _connect($)
{   my ($self, $opts) = @_;
    my $host = $opts->{Host}
        or error "no host provided to connect to";

    my $ftp = Net::FTPSSL->new($host, %$opts);
    my $err = defined $ftp ? undef : $Net::FTPSSL::ERRSTR;
    ($ftp, $err);
}

sub _modif_time($$)
{   my ($self, $ftp, $fn) = @_;
    $ftp->_mdtm($fn);
}

# not implemented/not possible?
sub _can_restart($$$) { 0 }


1;
