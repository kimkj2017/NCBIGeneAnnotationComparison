# NCBIGeneAnnotationComparison

Miami University

BIO/CSE 466

Kwangju Kim

Martin Heidelmen

## Intro

The main purpose of this website is to provide a gene comparison between cats (felis catus) and tigers (panthera tigris). Please provide either Gene ID, Gene Name, or both on the form in the main page if you wish to perform comparison.

We have used GFF files of cat and tiger, following NCBI format. You may download those files for reference.

* Felis catus: `GCF_000181335.2_Felis_catus_8.0_genomic.gff`
* Panthera tigris: `GCF_000464555.1_PanTig1.0_genomic.gff`

## Files included

The package includes the following files.

* `index.php`: The main page which will be shown.
* `overview.pl`: Perl CGI code which produces web interfaces that show summary differences between two annotations.
* `process.pl`: Perl CGI which accepts the query data, communicates with the database, and returns the query result.
* `css`: Bootstrap CSS stylesheet files are contained.
* `js`: Bootstrap JavaScript and jQuery library files are contained.
* `GFFparser.pm`: Perl Class script which parses the given GFF files.
* `GFFparser.pl`: Perl script which imports `GFFparser.pm` so that the users can work with that file.
* `dbtest.pl`: Perl script which dumps all the data inside the target database.

## Using Parser

You must have Perl iterpreter installed in your machine. Follow these instructions.

1. Prepare the NCBI formatted GFF files mentioned above (at the Intro paragraph).

2. You can use `GFFparser.pm` in your own Perl code to run the parser. Here are the functions you may look at.

* `GFFparser->new`: Constructor. Requires `-file_name`, `-file_src`, and `-file_type`. This version only accepts NCBI src and GFF types.
* `toString()`: Prints the stringified data for test purpose; if the data is parsed correctly.
* `writeFile()`: Write a `--.gff.parsed` file. It follows JSON notation.
* `sendToDatabase($username, $password, $host, $species)`: WARNING, THIS METHOD IS DANGEROUS. MAY CHANGE YOUR DB DATA. It sends the parsed data into the database.

## Instructions

The website is deployed in the either one of the following link.

* [Kwangju Kim](http://bio466-f15.csi.miamioh.edu/~kimk3)
* [Martin Heidelmen](http://bio466-f15.csi.miamioh.edu/~heidelmr)

You may also deploy on your own server with the HTML files. Please follow these instructions.

1. Place the source codes into the `/var/www/html` folder (needs `sudo` priviliges), or `/home/YourID/public_html` folder if you want to run the code.

2. If you have placed the source files in `/var/www/html`, you may simply type `http://YourDomain/`. If you have placed in `/home/YourId/public_html`, you must type `http://YourDomain/~YourID`. You do not have to explicitly write `index.php` or such. The package does not include `index.html`.

3. If your server doesn't have PHP installed, this package will not work accurately. We strongly encourage you, in this case applies to you, to refer to the following link to see the instructions.

[http://stackoverflow.com/questions/15157648/cannot-run-a-simple-php-file-on-the-server](http://stackoverflow.com/questions/15157648/cannot-run-a-simple-php-file-on-the-server)

You may also contact [CECHelp](mailto:cechelp@miamioh.edu) to discuss the difficulties.

## Questions

If you have any questions regarding this software, please do not hesitate to ask.
