package jsonEncode;

sub new {
  my $class = shift;
  my $self = {};
  bless $self, $class;
  return $self;
}

sub run {
  my $self = shift;
  my $hashRef = shift;
  my %list = %$hashRef;
  my $strNote = '{';
  foreach my $key (keys %list) {
    $strNote .= "\"$key\":\"$list{$key}\",";
  }
  $strNote = substr($strNote,0,-1);
  return $strNote.'}';
}

1;
