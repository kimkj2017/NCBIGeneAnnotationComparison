#!/usr/bin/perl
use strict;
use CGI;
use DBI;
use jsonEncode;
my $cgi = new CGI;
print $cgi->header;
#print $cgi->start_html('');
#print "Content-Type:text/html\n\n";

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
        <h4>Cat Overview</h4>
        <table class="table table-striped">
          <tr>
            <th>GFF_NCBI</th>
            <th>Number</th>
          </tr>
HTMLPAGE1

my ($user, $password, $host, $driver) = ('kimk3', 'bio466', 'localhost', 'mysql');

my $dsn = "DBI:$driver:database=kimk3;host=$host";
my $dbh = DBI->connect($dsn, $user, $password);

my $sql1 = "SELECT * FROM `Gene_Type_Count_Cat`";
my $sql2 = "SELECT * FROM `Gene_Type_Count_Tiger`";
my $sql3 = "SELECT * FROM `Transcript_Type_Count_Cat`";
my $sql4 = "SELECT * FROM `Transcript_Type_Count_Tiger`";
my $cat_rowrf1 = $dbh->selectall_arrayref($sql1) or die $dbh->errstr;
my $cat_rowrf2 = $dbh->selectall_arrayref($sql2) or die $dbh->errstr;
#my $tig_rowrf1 = $dbh->selectall_arrayref($seq3) or die $dbh->errstr;
#my $tig_rowrf2 = $dby->selectall_arrayref($seq4) or die $dbh->errstr;
my @cat_row1 = @{$cat_rowrf1};
my @cat_row2 = @{$cat_rowrf2};
#my @tig_row1 = @{$tig_rowrf1};
#my @tig_row2 = @{$tig_rowrf2};
#my $idx = 0;
=begin
while (1) {
  if ($idx > $#cat_row1 and $idx > $#cat_row2) { # and $idx > $#tig_row1 and $idx > $#tig_row2) {
    last;
  }
  print '<tr><td>';
  if ($idx <= $#cat_row1) {
    print $cat_row1[$idx];
  }
  print '</td><td>';
  if ($idx <= $#cat_row2) {
    print $cat_row1
  }
  print '</tr>';
  
  $idx++;
}
=cut
for (my $i = 0; $i <= $#cat_row1; $i+=2) {
  $html1.='<tr>';
  my @cat_indiv_row = @{$cat_row1[$i]};
  foreach my $val (@cat_indiv_row) {
    $html1.='<td>'.$val.'</td>';
  }
  $html1.='</tr>';
}

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


print "$html1.$html2\n".$cgi->end_html();
