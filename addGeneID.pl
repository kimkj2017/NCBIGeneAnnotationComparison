#!/usr/bin/perl
use strict;
use DBI;

my $jsonfile = shift;
open (PARSEDFILE, "<$jsonfile") or die();

my ($user, $password, $host, $driver) = ('kimk3', 'bio466', 'localhost', 'mysql');

my $dsn = "DBI:$driver:database=kimk3;host=$host";
my $dbh = DBI->connect($dsn, $user, $password);

while (<PARSEDFILE>) {
  my %hash = decode($_);
  my $id = $hash{'ID'};
  if (substr($id, 0, 4) eq 'gene') {
    my $geneid = $hash{'gene_id'};
    my $sql = "UPDATE `Gene_Tiger` SET `GENE_ID` = '$geneid' WHERE `ID` = '$id'";
    my $sqlexec = $dbh->prepare($sql);
    $sqlexec->execute();
    print("$sql\n");
  }
}

sub decode {
  my $json = shift;
  my $rawdata = substr($json, 1, -2);
  my @rawlist = split(',',$rawdata);
  my %decoded = ();
  foreach my $rawindiv (@rawlist) {
    #print("$raw\n");
    my @tmplist = split('"',$rawindiv);
    #print ($tmplist[1]."=>".$tmplist[3]."\n");
    $decoded{$tmplist[1]} = $tmplist[3];
  }
  return %decoded;
}
