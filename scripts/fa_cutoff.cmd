@perl -Sx %0 %*
@goto :eof
#!perl


sub usage {

print <<EOM;

Usage: fa_cutoff [OPTIONS]

This program reads lines of data each of which ends with a tab delimited
counts and removes lines which counts are outside the specified range, 
the range is inclusive.

  --min=N - lower range bound, 0 is used by default

  --max=M - upper range bound, everything is less than M by default

EOM

}


#
# *** Process command line parameters ***
#

$min = 0 ;
$max = -1 ;

while (0 < 1 + $#ARGV) {

    if("--help" eq $ARGV [0]) {

        usage ();
        exit (0);

    } elsif ($ARGV [0] =~ /^--min=(.*)/) {

        $min = 0 + $1;

    } elsif ($ARGV [0] =~ /^--max=(.*)/) {

        $max = 0 + $1;

    } elsif ($ARGV [0] =~ /^-.*/) {

        print STDERR "ERROR: Unknown parameter $$ARGV[0], see fa_cutoff --help";
        exit (1);

    } else {

        last;
    }
    shift @ARGV;
}


#
# Process the input
#

while(<>) {

  s/[\r\n]+//g;

  # data\tcount\n
  m/\t([0-9]+)$/;

  # check that the count is in the range
  if ((0 + $1 >= $min) && (-1 == $max || 0 + $1 <= $max)) {
    print "$_\n";
  }
}

