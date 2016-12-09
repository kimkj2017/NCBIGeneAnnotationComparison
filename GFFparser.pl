use strict;
use jsonEncode;
use DBI;

my $fname = shift;

open(GENFILE, "<$fname") or die("Cannot read GFF file");
open(PARSEDFILE, ">$fname.parsed") or die("Error while writing the file");
my $newfname = $fname.'.new';

while(<GENFILE>) {
  chomp($_);
  my @linedata = split('\t', $_);
  if ($linedata[2] eq 'gene' || index($linedata[2], 'RNA') != -1) {
  	my %keyval = ();
    #print($linedata[2].'=('.$linedata[3].'-'.$linedata[4].')');
    $keyval{'type'} = $linedata[2];
    $keyval{'start'} = $linedata[3];
    $keyval{'end'} = $linedata[4];
    $keyval{'strand'} = $linedata[6];
    my @infodata = split(';', $linedata[$#linedata]);
    foreach my $infodatum (@infodata) {
      my ($key, $value) = split('=', $infodatum);
      if (index("ID Name gene_biotype Parent", $key) != -1) {
        #print "($key=>$value)";
        $keyval{$key} = $value;
      }
    }
    my $jsonObj = jsonEncode->new();
    my $jsonNote = $jsonObj->run(\%keyval);
    print PARSEDFILE "$jsonNote\n";
  }
}

close(GENFILE);
close(PARSEDFILE);
