#!/usr/bin/perl
use strict;
use DBI;

my $filename = shift;
open(PARSEDFILE, "<$filename") or die("Cannot read the file!");

my ($user, $password, $host, $driver) = ('kimk3', 'bio466', 'localhost', 'mysql');

my $dsn = "DBI:$driver:database=kimk3;host=$host";
my $dbh = DBI->connect($dsn, $user, $password);

while (<PARSEDFILE>) {
  my %hashed = decode($_);
  #my $sql = "INSERT INTO DUMMYDATA_GFF (FEATURE, START, END, ATTRIBS) VALUES ('A', 1111, 22222, 'ATTRIBS')";
  #my $sqlexec =$dbh->prepare($sql);
  #$sqlexec->execute();
  #print "$sql\n";
  #foreach my $key (keys %hashed) {
  #  print("($key)($hashed{$key})");
  #}
  #print("\n");
  my $strand = 0;
  if ($hashed{'strand'} eq '+') {
    $strand = 1;
  }
  my $sql = "INSERT INTO ";
  if ($hashed{'type'} eq 'gene') {
    $sql .= "Gene_Tiger (ID, START, END, NAME, GENE_BIOTYPE, STRAND) VALUES ('$hashed{'ID'}', $hashed{'start'}, $hashed{'end'}, '$hashed{'Name'}', '$hashed{'gene_biotype'}', $strand)";
    #my $sqlexec = $dbh->prepare($sql);
    #$sqlexec->execute();
    #print("$sql\n");
  } else {
    if ($hashed{'Parent'} ne '') {
      $sql .= "Transcript_Tiger (ID, START, END, TYPE, PARENT, NAME, STRAND) VALUES ('$hashed{'ID'}', $hashed{'start'}, $hashed{'end'}, '$hashed{'type'}', '$hashed{'Parent'}', '$hashed{'Name'}', $strand)";
    } else {
      $sql .= "Transcript_Tiger (ID, START, END, TYPE, PARENT, NAME, STRAND) VALUES ('$hashed{'ID'}', $hashed{'start'}, $hashed{'end'}, '$hashed{'type'}', '0', '$hashed{'name'}', $strand)";
    }
    my $sqlexec = $dbh->prepare($sql);
    $sqlexec->execute();
    print("$sql\n");
  }
}

close PARSEDFILE;

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
