# hash Checker
 FILE HASH CHECKER|HASH GENERATOR;
These are tool for verifying the identity of programs on multiple hosts.
In first you must make a fingerprint from ideal host.
Correct this fingerprint to fit your needs and check next hosts with it.
You will get a report about all chused files.
Usage:
-Input|input|INPUT|i|I <file with stored list>
-Output|output|OUTPUT|o|O <report file>
-Generate|G|g generate report for "current dir" only mode
-verbose printing additional information
-Hash|hash|h|H <hash type MD5|SHA> if not present MD5 will be used
 \t used as the field divider in all in\out files
 
 You can run it in 2 modes:
 1) Generate master file -G -O filetosave.hash <-H SHA|MD5>
 2) Check files identity on next hosts -I filewithhashes.hash -O reportfile.log <-H SHA|MD5 if you set this in G mode>
 
