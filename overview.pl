#!/usr/bin/perl
use strict;
use CGI;
use DBI;
use jsonEncode;
my $cgi = new CGI;
print $cgi->header;

# Returns the header page now
my $html1 = <<"HTMLPAGE1";
<!--DOCTYPE HTML>
<html>
<head>
<meta charset="utf-8">
<title>CSE 466 Project</title>
<link rel='stylesheet' href='css/bootstrap.min.css'>
<link rel='stylesheet' href='css/bootstrap-theme.min.css'>
<script src='js/jquery-3.1.1.slim.js'></script>
<script src='js/bootstrap.min.js'></script>
</head>
<body>
</body>
</html-->

<div class="modal fade bd-example-modal-lg" id="overviewModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h2 class="modal-title" id="myModalLabel">Overview of Gene and Transcript Data</h2>
      </div>
      <div class="modal-body">
        <p><strong>Here, an overview of gene and transcript data stored in our local database is shown.</strong></p>
        <p>In our database, 15,167 shared genes were detected between a cat and a tiger.</p>
HTMLPAGE1

print $html1;

my ($user, $password, $host, $driver) = ('kimk3', 'bio466', 'localhost', 'mysql'); # define id, pw, driver, host

# initiate DBI
my $dsn = "DBI:$driver:database=kimk3;host=$host";
my $dbh = DBI->connect($dsn, $user, $password);

my $cat_query = "SELECT `GENE_BIOTYPE`, COUNT(*) FROM (SELECT `GENE_BIOTYPE` FROM `Gene_Cat` UNION ALL SELECT `TYPE` FROM `Transcript_Cat`) `CAT` WHERE `GENE_BIOTYPE` != '' GROUP BY `GENE_BIOTYPE`"; # cqt overview query
my $tig_query = "SELECT `GENE_BIOTYPE`, COUNT(*) FROM (SELECT `GENE_BIOTYPE` FROM `Gene_Tiger` UNION ALL SELECT `TYPE` FROM `Transcript_Tiger`) `Tiger` WHERE `GENE_BIOTYPE` != '' GROUP BY `GENE_BIOTYPE`"; # tiger overview query
my $catref = $dbh->selectall_arrayref($cat_query) or die($dbh->errstr); # call select query or die
my $tigref = $dbh->selectall_arrayref($tig_query) or die($dbh->errstr); # same

# start printing the table
print '<h4>Cat (<i>Felis catus</i>) Overview</h4>';
print '<table class="table table-striped">';
print '<tr><th>GFF_NCBI</th><th>Number</th></tr>';

# dereference the result, and construct the data into the table
my @cat = @{$catref};
my $catsum = 0;
foreach my $catrow (@cat) {
  print '<tr>';
  my @catlist = @{$catrow}; # catlist contains the value
  foreach my $val (@catlist) {
    print "<td>$val</td>";
  }
  $catsum += $catlist[1];
  print '</tr>';
}
print "<tr><th>TOTAL</th><td>$catsum</td></tr>";

#dereference the result, and construct the data into the table
my $tigsum = 0; 
print '</table>';
print '<h4>Tiger (<i>Panthera tigris</i>) Overview</h4>';
print '<table class="table table-striped">';
print '<tr><th>GFF_NCBI</th><th>Number</th></tr>';
my @tig = @{$tigref};
foreach my $tigrow (@tig) {
  print '<tr>';
  my @tiglist = @{$tigrow};
  foreach my $val (@tiglist) {
    print "<td>$val</td>"; # tiglist contains the value
  }
  $tigsum += $tiglist[1];
  print '</tr>';
}
print "<tr><th>TOTAL</th><td>$tigsum</td></tr>";

# print footer
my $html2 = <<"HTMLPAGE2";
        </table>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-success" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>
HTMLPAGE2


print "$html2\n".$cgi->end_html();
