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

my $sql_cat = "SELECT * FROM `Gene_Cat` WHERE `NAME` = '$gname'";
my $sql_tig = "SELECT * FROM `Gene_Tiger` WHERE `NAME` = '$gname'";

my ($user, $password, $host, $driver) = ('kimk3','bio466','localhost','mysql');
my $dsn = "DBI:$driver:database=kimk3;host=$host";
my $dbh = DBI->connect($dsn, $user, $password);
my $catref = $dbh->selectall_arrayref($sql_cat) or die $dbh->errstr;
my $tigref = $dbh->selectall_arrayref($sql_tig) or die $dbh->errstr;
my @catrows = @{$catref};
my @tigrows = @{$tigref};
print '<table class=\'table table-striped\'>';
print '<tr><th>Species</th><th>ID</th><th>Start Offset</th><th>End Offset</th><th>Gene Name</th><th>Biotype</th><th>Strand</th>';
foreach my $catrow (@catrows) {
  print '<tr><th>Cat</th>';
  my @catlist = @{$catrow};
  foreach my $val (@catlist) {
    print '<td>'.$val.'</td>';
  }
  print '</tr>';
}
foreach my $tigrow (@tigrows) {
  print '<tr><th>Tiger</th>';
  my @tiglist = @{$tigrow};
  foreach my $val (@tiglist) {
    print '<td>'.$val.'</td>';
  }
}
print '</table>';
print '<div class=\'well\'>';
print '<button class=\'btn btn-block btn-warning\' onclick=\'history.back();\'>Go back to the form to submit another query</button>';
print '</div></div></body>';

print $cgi->end_html."\n";  
