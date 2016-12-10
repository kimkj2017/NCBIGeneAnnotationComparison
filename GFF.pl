use strict;
use GFFparser;
use DBI;

my $fname = shift;
my $gff = GFFparser->new('-file_name'=>$fname, '-file_type'=>'GFF', '-file_src'=>'NCBI');
$gff->toString();
$gff->writeFile();

=begin
DO NOT CALL THIS! THIS WILL MANIPULATE THE ACTUAL TABLE DATA.

print 'Tell me the species you want to put into the database. [cat/tiger] ';
my $spec = <>;
chomp($spec);
$gff->sendToDatabase('kimk3', 'bio466', 'localhost', $spec);
=cut

# open(GENFILE, "<$fname") or die("Cannot read GFF file");
# open(PARSEDFILE, ">$fname.parsed") or die("Error while writing the file");
# my $newfname = $fname.'.new';

# while(<GENFILE>) {
#   chomp($_);
#   my @linedata = split('\t', $_);
#   if ($linedata[2] eq 'gene' || index($linedata[2], 'RNA') != -1) {
#     my %keyval = ();
#     #print($linedata[2].'=('.$linedata[3].'-'.$linedata[4].')');
#     $keyval{'type'} = $linedata[2];
#     $keyval{'start'} = $linedata[3];
#     $keyval{'end'} = $linedata[4];
#     $keyval{'strand'} = $linedata[6];
#     my @infodata = split(';', $linedata[$#linedata]);
#     foreach my $infodatum (@infodata) {
#       my ($key, $value) = split('=', $infodatum);
#       if (index("ID Name gene_biotype Parent", $key) != -1) {
#         #print "($key=>$value)";
#         $keyval{$key} = $value;
#       } elsif (index("Dbxref", $key) != -1) {
#         $keyval{'gene_id'} = substr($value, 7);
#       }
#     }
#     my $jsonObj = jsonEncode->new();
#     my $jsonNote = $jsonObj->run(\%keyval);
#     print PARSEDFILE "$jsonNote\n";
#   }
# }

# close(GENFILE);
# close(PARSEDFILE);
