###############################################################################
## OCSINVENTORY-NG
## Copyleft Guillaume PROTET 2010
## Web : http://www.ocsinventory-ng.org
##
## This code is open source and may be copied and modified as long as the source
## code is always made freely available.
## Please refer to the General Public Licence http://www.gnu.org/ or Licence.txt
################################################################################
package Ocsinventory::Agent::Modules::Unixusersv2;

sub new {

    my $name="unixusersv2"; # Name of the module
    my $unixSystem=`uname -s`
    my (undef,$context) = @_;
    my $self = {};

    #Create a special logger for the module
    $self->{logger} = new Ocsinventory::Logger ({
        config => $context->{config}
    });
    $self->{logger}->{header}="[$name]";
    $self->{context}=$context;
    $self->{structure}= {
        name => $name,
        start_handler => undef,    #or undef if don't use this hook
        prolog_writer => undef,    #or undef if don't use this hook
        prolog_reader => undef,    #or undef if don't use this hook
        inventory_handler => $unixSystem."_inventory_handler",    #or undef if don't use this hook
        end_handler => undef       #or undef if don't use this hook
    };
    bless $self;
}

######### Hook methods ############

sub Linux_inventory_handler {

    my $self = shift;
    my $logger = $self->{logger};
    my $common = $self->{context}->{common};

    # test if who command is available and /etc/passwd, /etc/group are readable :)
    sub check {

        my $params = shift;
        my $common = $params->{common};

        $common->can_run("who"); 
        $common->can_read("/etc/passwd");
        $common->can_read("/etc/group");
        $common->can_read("/etc/shadow");

    }

    foreach my $user (_getLocalUsers()) 
    {
        foreach my $passwordinfo (_getLocalPasswords()) 
        {
            if($passwordinfo->{LOGIN} == $user->{LOGIN})
            {
                my login = $user->{LOGIN}
                my $LASTSEEN = system("last -1 $login --time-format full | awk '{print \$5, \$4, \$7, \$6}' | sed 1q")
                my $hasSUDO = system("sudo -lU $login  | grep 'is not allowed to run sudo'") == 0 
                if( $hasSUDO == 0 ) {
                    my $SUDOER = "FALSE"
                    } else {
                    my $SUDOER = "TRUE"
                    }

                push @{$common->{xmltags}->{LOCAL_USERS}},
                {
                    USERLOGIN            => [$user->{LOGIN}],
                    USERID               => [$user->{ID}],
                    PASSWORD_PROTECTED   => [$passwordinfo->{PROTECTED}],
                    PASSWORD_LASTCHANGE  => [$passwordinfo->{LASTCHANGE}],
                    PASSWORD_POLICY      => ["NotImplementedYet"],
                    LASTSEEN             => [$LASTSEEN],
                    HAS_SUDO_RIGHTS      => [$SUDOER]
                };
            }
        }
    }

}

1;

sub _getLocalUsers{

     open(my $fh, '<:encoding(UTF-8)', "/etc/passwd") or warn;
     my @userinfo=<$fh>;
     close($fh);

     foreach my $line (@userinfo){
         next if $line =~ /^#/;
         next if $line =~ /^[+-]/; # old format for external inclusion
         chomp $line;
         my ($login, undef, $uid, $gid, $gecos, $home, $shell) = split(/:/, $line);

         push @users,
         {
             LOGIN => $login,
             ID    => $uid,
             gid   => $gid,
             NAME  => $gecos,
             HOME  => $home,
             SHELL => $shell
         };
     }

     return @users;

}


sub _getLocalPasswords{

     open(my $fh, '<:encoding(UTF-8)', "/etc/shadow") or warn;
     my @passwordinfo=<$fh>;
     close($fh);

     foreach my $line (@passwordinfo){
         next if $line =~ /^#/;
         next if $line =~ /^[+-]/; # old format for external inclusion
         chomp $line;
         my ($login, $passwordprotected, $lastchanged, $minperiodchange, $maxperiodchange, $warnuserforchange, $deactivationdate, $expirationdate) = split(/:/, $line);

         push @passwords,
         {
             LOGIN      => $login,
             PROTECTED  => $passwordprotected,
             LASTCHANGE => $lastchanged
         };
     }

     return @passwords;

}