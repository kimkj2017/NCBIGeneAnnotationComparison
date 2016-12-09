#!/usr/bin/perl -w
use strict;
use jsonEncode;
use CGI;
use DBI;
my $cgi=new CGI;
  
print $cgi->header();
print $cgi->start_html(-title=>'Form Processing',
                       -author=>'Kwangju Kim and Martin Heidelman');

my $gid=$cgi->param("gid");
my $gname=$cgi->param("gname");
#print ("[GeneID]=($gid)<br>");
#print ("[GeneName]=($gname)<br>");
my $headerhtml = <<"HEADERHTML";
<!DOCTYPE html>
<html lang="en">
<head>
<title>Campbest Form 1 Project</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<style>
/* Set height of the grid so .sidenav can be 100% (adjust as needed) */
.row.content {height: 550px}

/* Set gray background color and 100% height */
.sidenav {
background-color: #f1f1f1;
height: 100%;
}

/* On small screens, set height to 'auto' for the grid */
\@media screen and (max-width: 767px) {
.row.content {height: auto;}
}
</style>
</head>
<body>
<div class='container'>
<h2>Query Result</h2>
<p>The page shows the query result based on your form submission:</p>
<ul>
<li>Gene ID: [$gid]</li>
<li>Gene Name: [$gname]</li>
</ul>
HEADERHTML

print $headerhtml;

my $sql_cat = "SELECT * FROM `Gene_Cat` WHERE ";
my $sql_tig = "SELECT * FROM `Gene_Tiger` WHERE ";
my $trans_cat = "SELECT * FROM `Transcript_Cat` WHERE `PARENT` IN (SELECT `ID` FROM `Gene_Cat` WHERE ";
my $trans_tig = "SELECT * FROM `Transcript_Tiger` WHERE `PARENT` IN (SELECT `ID` FROM `Gene_Tiger` WHERE ";
my $namequery = "`NAME` = '$gname'";
my $idquery = "`GENE_ID` = '$gid'";
if ($gid ne '' and $gname ne '') {
  $sql_cat .= "$idquery OR $namequery";
  $sql_tig .= "$idquery OR $namequery";
  $trans_cat .= "$idquery OR $namequery)";
  $trans_tig .= "$idquery OR $namequery)";
}
elsif ($gid ne '' and $gname eq '') {
  $sql_cat .= $idquery;
  $sql_tig .= $idquery;
  $trans_cat .= "$idquery)";
  $trans_tig .= "$idquery)";
}
elsif ($gid eq '' and $gname ne '') {
  $sql_cat .= $namequery;
  $sql_tig .= $namequery;
  $trans_cat .= "$namequery)";
  $trans_tig .= "$namequery)";
}
else {
  print "<div class=\"alert alert-danger\"><strong>Query not found.</strong> You must submit the valid form.</div></body></html>";
  exit;
}

my ($user, $password, $host, $driver) = ('kimk3','bio466','localhost','mysql');
my $dsn = "DBI:$driver:database=kimk3;host=$host";
my $dbh = DBI->connect($dsn, $user, $password);
my $catref = $dbh->selectall_arrayref($sql_cat) or die $dbh->errstr;
my $tigref = $dbh->selectall_arrayref($sql_tig) or die $dbh->errstr;
my @catrows = @{$catref};
my @tigrows = @{$tigref};
if ($#catrows == -1 and $#tigrows == -1) {
  print "<div class=\"alert alert-danger\"><strong>Query not found.</strong> Check your form data and try submitting again. Make sure you are submitting valid NCBI format ID and Name.</div></body></html>";
  exit;
}
print '<p>There are '.($#catrows + 1).' row(s) for the cat and '.($#tigrows + 1).' row(s) for the tiger.</p>';
print '<table class=\'table table-striped\'>';
print '<tr><th>Species</th><th>PK</th><th>Start Offset</th><th>End Offset</th><th>Gene ID</th><th>Gene Name</th><th>Biotype</th><th>Strand</th>';
my $idx_tmp = 0; # idx checker to find the strand
foreach my $catrow (@catrows) {
  print '<tr><th>Cat</th>';
  my @catlist = @{$catrow};
  foreach my $val (@catlist) {
    if ($idx_tmp == $#catlist) {
      if ($val == '0') {
        print '<td>-</td>';
      } else {
        print '<td>+</td>';
      }
    } else {
      print '<td>'.$val.'</td>';
    }
    $idx_tmp += 1;
  }
  print '</tr>';
  $idx_tmp = 0;
}
foreach my $tigrow (@tigrows) {
  print '<tr><th>Tiger</th>';
  my @tiglist = @{$tigrow};
  foreach my $val (@tiglist) {
    print '<td>';
    if ($idx_tmp == $#tiglist) {
      if ($val == '0') {
        print '-';
      } else {
        print '+';
      }
    } else {
      print $val;
    }
    print '</td>';
    $idx_tmp += 1;
  }
  print '</tr>';
  $idx_tmp = 0;
}
print '</table>';
print '<h3>The following are the transcripts existing in the database associated with the queried gene.</h3>';
print '<div class=\'col-md-6\'>';
print '<h4>Cat</h4>';
print '<table class=\'table table-striped\'>';
print '<tr><th>ID</th><th>Start</th><th>End</th><th>Type</th><th>Name</th><th>Strand</th></tr>';
my $tcatref = $dbh->selectall_arrayref($trans_cat) or die $dbh->errstr;
my $ttigref = $dbh->selectall_arrayref($trans_tig) or die $dbh->errstr;
my @tcat = @{$tcatref};
my @ttig = @{$ttigref};
foreach my $tcatrow (@tcat) {
  print '<tr>';
  my @tcatlist = @{$tcatrow};
  foreach my $val (@tcatlist) {
    if ($idx_tmp != 4) {
      print '<td>';
      if ($idx_tmp == $#tcatlist) {
        if ($val == '0') {
          print '-';
        } else {
          print '+';
        }
      } else {
        print $val;
      }
      print '</td>';
    }
    $idx_tmp += 1;
  }
  print '</tr>';
  $idx_tmp = 0;
}
print '</table></div>';
print '<div class=\'col-md-6\'>';
print '<h4>Tiger</h4>';
print '<table class=\'table table-striped\'>';
print '<tr><th>ID</th><th>Start</th><th>End</th><th>Type</th><th>Name</th><th>Strand</th></tr>';
foreach my $ttigrow (@ttig) {
  print '<tr>';
  my @ttiglist = @{$ttigrow};
  foreach my $val (@ttiglist) {
    if ($idx_tmp != 4) {
      print '<td>';
      if ($idx_tmp == $#ttiglist) {
        if ($val == '0') {
          print '-';
        } else {
          print '+';
        }
      } else {
        print $val;
      }
      print '</td>';
    }
    $idx_tmp += 1;
  }
  print '</tr>';
  $idx_tmp = 0;
}

print '</table></div>';
print '<button class=\'btn btn-block btn-warning\' onclick=\'history.back();\'>Go back to the form to submit another query</button>';
print '</div></body>';

print $cgi->end_html."\n";  
