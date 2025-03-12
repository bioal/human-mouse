#!/usr/bin/perl -w
use strict;
use File::Basename;
use Getopt::Std;
my $PROGRAM = basename $0;
my $USAGE=
"Usage: $PROGRAM hg38ToMm10.over.chain &
";

my %OPT;
getopts('', \%OPT);

if (@ARGV != 1) {
    print STDERR $USAGE;
    exit 1;
}
my ($CHAIN_FILE) = @ARGV;

my $PREFIX = "";
if ($CHAIN_FILE =~ /^(\S+).over.chain$/) {
    $PREFIX = $1;
} else {
    print STDERR $USAGE;
    exit 1;
}

my %HASH = ();
dbmopen(%HASH, "$PREFIX.dbm", 0644) || die;
open(OUT, ">$PREFIX") || die "$!";

my $KEY = "";
my $VALUE = "";
open(FILE, $CHAIN_FILE) || die "$!";
while (<FILE>) {
    if (/^chain/) {
        chomp;
        $KEY = $_;
        $VALUE = "";
        print OUT "$_\n";
    } elsif (/^$/) {
        $HASH{$KEY} = $VALUE;
    } else {
        $VALUE .= $_;
    }
}
close(FILE);

dbmclose(%HASH);
close(OUT);
