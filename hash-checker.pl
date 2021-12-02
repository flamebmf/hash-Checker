#perl2exe_info FileDescription =hash file checker
#perl2exe_info FileVersion=1.2
#perl2exe_info InternalName=md5_check
#perl2exe_info LegalCopyright=Akulich Dmitry akulich.d@gmail.com
#perl2exe_info ProductName=hash file checker
#perl2exe_info ProductVersion=1
use Digest::MD5;
use Digest::SHA;
use Getopt::Long;
use Cwd qw(cwd);
use strict;
use Win32::Console::ANSI;
use Term::ANSIColor;
my $file_nname;
my @FILE_list;
my $fh;
my $mdhaash;
my $tmp;
my $currentdir=cwd;
my $inputfile;
my $outputfile;
my %input_data;
my $generate="";
my $hashtype="";
my $md5;
my $verbose='';
$Term::ANSIColor::AUTORESET = 1;

if (!@ARGV) {
&help_out;
exit;
};
GetOptions ('Input|input|INPUT|i|I=s' => \$inputfile, #string
			'Output|output|OUTPUT|o|O=s' => \$outputfile,
			'Generate|G|g' => \$generate,
			'verbose' =>  \$verbose,
			'Hash|hash|h|H=s' => \$hashtype,
			) or die("Error in command line arguments\n");

if ($verbose){
print color 'bold red';
print "--verbose is on!\n";
};
#init hash
if ($verbose){ print "hash type is $hashtype\n";};
if ($hashtype eq "SHA") {
$md5 = Digest::SHA->new(256);
if ($verbose) { print "SHA enabled\n";};
} else {
if ($verbose) { print "MD5 enabled\n"; };
$md5 = Digest::MD5->new;
};

if ($verbose) { 
	print "input file - ";
	if ($inputfile) { print $inputfile;}else{print "none";};
	print " otput file - ";
	if ($outputfile) { print $outputfile;}else{print "none";};
	print"\n"; 
	};
	
if ($generate and $outputfile) {
open(FOUT,'>', $outputfile) or die $!;
print color 'bold red';
print "\tGenerating hash report for current dir - $currentdir\n";
print "\tOutput file is $outputfile\n";
print color 'reset';
&scan_files;
close(FOUT);
exit;
};
if ($outputfile) {
if ($verbose) { print "Opening file for output $outputfile\n";};
open(FOUT,'>', $outputfile) or die $!;

};
if ($inputfile) {
if ($verbose) { print "loading data from input file $inputfile\n";};
&load_data;
foreach $tmp ( keys %input_data) {
	my $md_1=$input_data{$tmp};
	my $md_2=scan_file($tmp);
	if ($verbose) { print "md1=$md_1\nmd2=$md_2\n\n"; };
	if ($md_1 eq $md_2) {
		#if ($outputfile) {
		#print FOUT "$tmp\tOK\n";
		#}; remove useless information from report
		if ($verbose) { 
		 print "$tmp \t";
		 print color 'bold green';
		 print "OK \n";
		 print color 'reset';
		};
	} else {
		if ($outputfile) {
		print FOUT "$tmp\tNOT OK\n";
		};
		if ($verbose) { 
		 print "$tmp\t";
		 print color 'bold red';
		 print "NOT OK\n";
		 print color 'reset';
		};
	};
};
};

if ($outputfile) {
if ($verbose) { print "End, closing files\n"; };
close(FOUT);
};


sub scan_files{
	@FILE_list=`dir /s/n/b /A-D`;
	foreach $file_nname(@FILE_list) {
	chomp($file_nname);
		$tmp=scan_file ($file_nname);
			if ($tmp) {
				if ($verbose) { print "$file_nname\t$tmp\n"; };
				print FOUT "$file_nname\t$tmp\n";
			} else {
				next;
			};
	};
};
sub scan_file {
	my($file)=@_;
	chomp($file);
	$file=~s/\\/\//g;
	if (! open (my $fh,"$file")) {
		#warn "Can't open '$file'";
		
		return 0;
	}else {
		binmode ($fh);
		my $mdhaash=$md5->addfile($fh)->hexdigest;
		close ($fh);
		return $mdhaash;
	};
};
sub load_data {
	my $input_f;
	if (! open (F_F,'<',"$inputfile")){
		return 0;
	} else {
		foreach $input_f( <F_F> ) {
			my($name_f,$md5_f) = split /\t/,$input_f;
			chomp($name_f);
			chomp($md5_f);
			$input_data{$name_f}= $md5_f;
			if ($verbose) { print "Found md5 $input_data{$name_f}\n"};
			};
	};
};
sub help_out {
print color 'bold red';
print "\tFILE HASH CHECKER|HASH GENERATOR\n";
print color 'bold green';
print "\t\tCopyrights\n\t\tAkulich Dmitry\n\t\t2021\n";
print "\t Usage:\n \t-Input|input|INPUT|i|I <file with stored list:fullfilename\\thash>\n\t-Output|output|OUTPUT|o|O <report file>\n\t-Generate|G|g generate report for current dir only mode\n\t-verbose printing additional information\n\t-Hash|hash|h|H <hash type MD5|SHA> if not present MD5 will be used \n";
print "\t\\t used as the field divider in all files\n";
print color 'reset';
}; 