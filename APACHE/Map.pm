###############################################################################
## OCSINVENTORY-NG
## Copyleft Guillaume PROTET 2013
## Web : http://www.ocsinventory-ng.org
##
## This code is open source and may be copied and modified as long as the source
## code is always made freely available.
## Please refer to the General Public Licence http://www.gnu.org/ or Licence.txt
################################################################################
 
package Apache::Ocsinventory::Plugins::Unixusersv2::Map;
 
use strict;
 
use Apache::Ocsinventory::Map;

#Plugin Unix/Linux USERS
$DATA_MAP{unixusersv2} = {
    mask => 0,
    multi => 1,
    auto => 1,
    delOnReplace => 1,
    sortBy => 'USERLOGIN',
    writeDiff => 0,
    cache => 0,
    fields => {
         USERID => {},
         USERLOGIN => {},
         PASSWORD_PROTECTED => {},
         PASSWORD_LASTCHANGE => {},
         PASSWORD_POLICY => {},
         LASTSEEN => {},
         HAS_SUDO_RIGHTS => {}
    }
 
};
1;
