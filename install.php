<?php
function extension_install_unixusersv2()
{
    $object = new ExtensionCommon;
    $object -> sqlQuery("CREATE TABLE IF NOT EXISTS `unixusersv2` (
     `ID` INT(11) NOT NULL AUTO_INCREMENT,
     `HARDWARE_ID` INT(11) NOT NULL,
     `USERID` INT(11) DEFAULT NULL,
     `USERLOGIN` VARCHAR(255) DEFAULT NULL,
     `PASSWORD_PROTECTED` VARCHAR(255) DEFAULT NULL,
     `PASSWORD_LASTCHANGE` VARCHAR(255) DEFAULT NULL,
     `PASSWORD_POLICY` VARCHAR(255) DEFAULT NULL,
     `LASTSEEN` VARCHAR(255) DEFAULT NULL,
     `HAS_SUDO_RIGHTS` VARCHAR(255) DEFAULT NULL,
     PRIMARY KEY  (`ID`,`HARDWARE_ID`)
     ) ENGINE=InnoDB ;");
}

function extension_delete_unixusersv2()
{
    $object = new ExtensionCommon;
    $object -> sqlQuery("DROP TABLE `unixusersv2`;");
}

function extension_upgrade_unixusersv2()
{

}
?>
