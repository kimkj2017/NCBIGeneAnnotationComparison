#!/usr/bin/perl
# KWANGJU KIM and MARTIN HEIDELMAN
# BIO/CSE 466
# Final project

package GFFparser;
use strict;
use DBI;

sub new { # make a new class
    my $class = shift;
    my $self = bless {}, $class;
    my %args=@_;
    if ($args{'-file_type'} ne 'GFF') {
        die('This can only parse GFF file.'); # we don't have to write GTF parser
    }
    if ($args{'-file_src'} ne 'NCBI') {
        die('This can only parse NCBI style.'); # we only handle NCBI formatted files
    }
    $self->{'-file_name'} = $args{'-file_name'}; # store file name
    open(GENFILE, "<$self->{'-file_name'}") or die('Could not read the file!'); # read data
    while(<GENFILE>) { # start reading
        chomp($_); # remove \n
        # starts parsing...
        my @linedata = split('\t', $_);
        if ($linedata[2] eq 'gene' || index($linedata[2], 'RNA') != -1) {
            my %keyval = ();
            $keyval{'type'} = $linedata[2]; # get type attrib
            $keyval{'start'} = $linedata[3]; # get start offset
            $keyval{'end'} = $linedata[4]; # get end offset
            $keyval{'strand'} = $linedata[6]; # strand, either pos or nev
            my @infodata = split(';', $linedata[$#linedata]); # get the attribs
            foreach my $infodatum (@infodata) { # iterate thru attribs
                my ($key, $value) = split('=', $infodatum); # split using =
                if (index("ID Name gene_biotype Parent", $key) != -1) {
                    $keyval{$key} = $value; # get ID, Name, gene_biotype or Parent, because these are the only thing we need
                } elsif (index("Dbxref", $key) != -1) {
                    $keyval{'gene_id'} = substr($value, 7) if $keyval{'type'} eq 'gene'; # get gene id only if the type is gene
                }
            }
            $self->{$keyval{'ID'}} = \%keyval; # pk will be just iD
        }
    }
    close(GENFILE); # close file so that other people can re use the file
    return $self; # return object
}

sub toString { # this method is just printing the object attribs
    my $self = shift;
    foreach my $key (keys %{$self}) {
        if ($key ne '-file_name') {
            my %lis = %{$self->{$key}};
            foreach my $k (keys %lis) {
                print $k.'=>'.$lis{$k};
            }
        }
        # print $key.' => '.%{$self->{$key}}."\n";
    }
}

sub writeFile { # write JSON style parsed file. Will generate --.gff.parsed file
    my $self = shift;
    my $newfile = $self->{'-file_name'}; # gets filename
    open(PARSEDFILE, ">$newfile.parsed") or die('Could not open the file!'); # opens the file to write
    foreach my $param (keys %{$self}) { # iterate thru keys
        if ($param ne '-file_name') { # except file name
            my %list = %{$self->{$param}}; # get the row
            my $strNote = '{';
            foreach my $key (keys %list) {
                $strNote .= "\"$key\":\"$list{$key}\","; # generate a JSON string
            }
            $strNote = substr($strNote,0,-1);
            print PARSEDFILE $strNote.'}'."\n"; # write JSON
        }
    }
    close(PARSEDFILE);
}

=begin
DANGER! THIS SUBROUTINE WILL ACTUALLY WRITE A DATA INTO THE TABLE.
DO NOT CALL IT UNLESS YOU KNOW THE CONSEQUENCE.

THIS METHOD ASSUMES THAT YOU HAVE 'Gene_XXX', 'Transcript_XXX' TABLES IN THE DATABASE, WHERE XXX IS A NAME OF SPECIES (CAT/TIGER)
  OTHERWISE, PLEASE MAKE A TABLE IN ADVANCE IN THE DATABASE.
THIS METHOD ASSUMES THAT YOUR DB NAME IS AS SAME AS YOUR USERNAME.
THIS METHOD ASSUMES THAT YOUR DB SOFTWARE IS mysql.
=cut
sub sendToDatabase{
    my $self = shift; # gets object
    my $user = shift; # gets username
    my $password = shift; # get password
    my $host = shift; # get hostname
    my $species = shift; # get species name

    # construct the connection
    my $dsn = "DBI:mysql:database=$user;host=$host";
    my $dbh = DBI->connect($dsn, $user, $password);

    foreach my $param (keys %{$self}) {
        if ($param ne '-file_name') {
            my %hashed = %{$self->{$param}};
            my $strand = 0;
            if ($hashed{'strand'} eq '+') {
                $strand = 1;
            }
            my $sql = "INSERT INTO ";
            if ($hashed{'type'} eq 'gene') {
                if ($species eq 'cat') {
                    $sql .= 'Gene_Cat'; # inserting cat gene...
                } elsif ($species eq 'tiger') {
                    $sql .= 'Gene_Tiger'; # inserting tiger gene
                } else {
                    die('Unknown species'); # otherwise throw error
                }
                # insert the entries based on the key
                $sql .= " (ID, START, END, GENE_ID, NAME, GENE_BIOTYPE, STRAND) VALUES ";
                $sql .= " ('$hashed{'ID'}', $hashed{'start'}, $hashed{'end'}, $hashed{'gene_id'}, '$hashed{'Name'}', '$hashed{'gene_biotype'}', $strand)";
                my $sqlexec = $dbh->prepare($sql);
                $sqlexec->execute(); # execute!
                print("$sql\n"); # if success, it will print the SQL statement
            } else {
                if ($species eq 'cat') {
                    $sql .= 'Transcript_Cat'; # inserting cat transcripts...
                } elsif ($species eq 'tiger') {
                    $sql .= 'Transcript_Tiger'; # inserting tiger transcripts...
                } else {
                    die('Unknown species'); # otherwise throw error
                }
                if ($hashed{'Parent'} ne '') { # if parent does not exist
                    $sql .= " (ID, START, END, TYPE, PARENT, NAME, STRAND) VALUES ('$hashed{'ID'}', $hashed{'start'}, $hashed{'end'}, '$hashed{'type'}', '$hashed{'Parent'}', '$hashed{'Name'}', $strand)";
                } else {
                    $sql .= " (ID, START, END, TYPE, PARENT, NAME, STRAND) VALUES ('$hashed{'ID'}', $hashed{'start'}, $hashed{'end'}, '$hashed{'type'}', '0', '$hashed{'name'}', $strand)";
                }
                my $sqlexec = $dbh->prepare($sql);
                $sqlexec->execute(); # execute!
                print("$sql\n"); # if success, it will print the SQL statement
            }
        }
    }    
}

1;