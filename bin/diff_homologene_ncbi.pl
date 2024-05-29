#!/usr/bin/perl -w
use strict;
use File::Basename;
use Getopt::Std;
my $PROGRAM = basename $0;
my $USAGE=
"Usage: $PROGRAM HOMOLOGENE NCBI_ORTHOLOGS
";

my %OPT;
getopts('', \%OPT);

if (@ARGV != 2) {
    print STDERR $USAGE;
    exit 1;
}
my ($HOMOLOGENE, $NCBI) = @ARGV;

my %HASH;
my $count_ncbi = 0;
open(NCBI, "$NCBI") || die "$!";
while (<NCBI>) {
    chomp;
    my @f = split(/\t/, $_, -1);
    if (@f != 2) {
        die "NCBI:$.: $_\n";
    }
    $HASH{$_} = 1;
    $count_ncbi++;
}
close(NCBI);

my $preserved = 0;
my $not_preserved = 0;
my %PRESERVED;
my %NOT_PRESERVED;
open(HOMOLOGENE, "$HOMOLOGENE") || die "$!";
while (<HOMOLOGENE>) {
    chomp;
    my @f = split(/\t/, $_, -1);
    if ($HASH{$_}) {
        $preserved++;
        $PRESERVED{$_} = 1;
    } else {
        # print "$_\n";
        $not_preserved++;
        $NOT_PRESERVED{$_} = 1;
    }
}
close(HOMOLOGENE);

my %NEW;
for my $key (keys %HASH) {
    if (!$PRESERVED{$key}) {
        print "NCBI: $key\n";
    }
}

print "preserved: $preserved\n";
print "not_preserved: $not_preserved\n";
print "new:", $count_ncbi - $preserved, "\n";

################################################################################
### Function ###################################################################
################################################################################

sub match {
    my ($homologene, $ncbi) = @_;
    my @homologene = split(/\t/, $homologene, -1);
    if (@homologene != 2) {
        die "HOMOLOGENE:$.: $homologene\n";
    }
    my ($homologene_human, $homologene_mouse) = @homologene;
    my @homologene_human = split(/,/, $homologene_human, -1);
    my @homologene_mouse = split(/,/, $homologene_mouse, -1);
    my %homologene_human;
    my %homologene_mouse;
    foreach my $gene (@homologene_human) {
        $homologene_human{$gene} = 1;
    }
    foreach my $gene (@homologene_mouse) {
        $homologene_mouse{$gene} = 1;
    }

    my @ncbi = split(/\t/, $ncbi, -1);
    if (@ncbi != 2) {
        die "NCBI:$.: $ncbi\n";
    }
    my ($ncbi_human, $ncbi_mouse) = @ncbi;
    if ($homologene_human{$ncbi_human} && $homologene_mouse{$ncbi_mouse}) {
        return 1;
    } else {
        return 0;
    }
}
