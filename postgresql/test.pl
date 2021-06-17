# use strict;
# use warnings;

# use lib "~/perl5/modules/";
# require Demo::StringUtils;

# print Demo::StringUtils::zombify("i want brains\n");
use Digest::MD5 qw(md5_hex);

$digest = md5_hex("testing","this","stuff");

print $digest,"\n";