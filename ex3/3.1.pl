$x = 4;

sub increment {
    $x++;
}

print "before: ", $x, "\n";
increment();
increment();
increment();
print "after: ", $x, "\n";
