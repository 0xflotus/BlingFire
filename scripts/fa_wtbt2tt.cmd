@perl -Sx %0 %*
@goto :eof
#!perl


sub usage {

print <<EOM;

Usage: fa_wtbt2tt [OPTIONS] < wtbt.txt > tt.map.txt

Builds a Tb --> { Tw } multi-map.

  --tagset=<input-file> - reads input tagset from the <input-file>,
    tagset.txt is used by default

  --reverse - builds a Tw --> { Tb } multi-map.

EOM

}


$tagset = "tagset.txt" ;
$reverse = "";


while (0 < 1 + $#ARGV) {

    if("--help" eq $ARGV [0]) {

        usage ();
        exit (0);

    } elsif ($ARGV [0] =~ /^--tagset=(.+)/) {

        $tagset = $1;

    } elsif ("--reverse" eq $ARGV [0]) {

        $reverse = $1;

    } elsif ($ARGV [0] =~ /^-.*/) {

        print STDERR "ERROR: Unknown parameter $$ARGV[0], see fa_wtbt2tt --help";
        exit (1);

    } else {

        last;
    }
    shift @ARGV;
}

#
# read in the tagset
#

open TAGSET, "< $tagset" ;

while (<TAGSET>) {

    s/[\r\n]+$//;
    @f = split(/ /);

    if(2 == 1 + $#f) {
        $tag{$f[0]} = $f[1] ;
    }
}

close TAGSET ;

#
# process the WTBT file
#

while(<>) { 

    s/[\r\n]+$//;
    s/^\xEF\xBB\xBF//;
    @f = split(/[\t]/);

    if("" eq $reverse) {
        $t{$f[3] . "\t" . $f[1]} = 1 ;
    } else {
        $t{$f[1] . "\t" . $f[3]} = 1 ;
    }
}


#
# convert pairs into the multi-map format
#

foreach $b (sort keys %t) { 

    @f = split(/[\t]/, $b);

    if (!(defined $tag{$f[0]})) {
        print STDERR "ERROR: Tag \"$f[0]\" is not defined\n";
        exit 1;
    }
    if (!(defined $tag{$f[1]})) {
        print STDERR "ERROR: Tag \"$f[1]\" is not defined\n";
        exit 1;
    }

    $count{$tag{$f[0]}}++ ;
    $tags{$tag{$f[0]}} .= (" " . $tag{$f[1]}) ;
}

#
# print the map
#

foreach $b (sort { $a <=> $b } keys %tags) {
    print $b . " -> " . $count{$b} . " " .
      join (' ', sort { $a <=> $b } (split (' ', $tags{$b}))) . "\n" ;
}

