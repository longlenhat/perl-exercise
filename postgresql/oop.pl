require Animal;
require Koala;

my $o_animal = {
    "legs" => 4,
    "colour" => "brown",
};

print ref $o_animal; # ref shows type of class
print "\n";
bless $o_animal, "Animal"; # is now object of class "Animal"
print ref $o_animal;
print "\n";

$o_animal->eat("insects","curry");

my $o_animal2 = Animal->new("legs" => 18, "colour" => "violet", "poops" => yes);
print "new animal legs: ", $o_animal2->{"legs"}, ", ";
print "new animal colour: ", $o_animal2->{"colour"}, "\n";

my $o_koala = Koala->new();
print "object '$o_koala' creation time: ", $o_koala->get_datetime(), "\n";
print "koala legs: ", $o_koala->{"legs"}, ", ";
print "koala colour: ", $o_koala->{"colour"}, "\n";
$o_koala->{"legs"} = 2;
$o_koala->{"colour"} = "black and white";
$o_koala->set_attribute("poops", "yes");
print "koala legs: ", $o_koala->get_attribute("legs"), ", ";
print "koala colour: ", $o_koala->get_attribute("colour"), "\n";
$o_koala->eat("insects","curry","eucalyptus");