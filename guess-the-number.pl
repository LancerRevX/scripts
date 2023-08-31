use v5.22;

sub rand_between {
    my ($from , $to) = @_;
    return int rand($to - $from + 1) + $from;
}

my ($rand_min, $rand_max) = (3, 13);

say "Guess The Number game v1.0.0 by Nikita Kirenkov";
say "You are going to try to guess a random number";
say "Guess right, you win.";
say "Guess wrong, you lose, and a new random is created for another try.";
say "Press ENTER should you wish to start.";
<STDIN>;

while (my $random_number = rand_between $rand_min, $rand_max) {
    say "Enter your guess between $rand_min and $rand_max inclusively: ";
    my $user_input = <STDIN>;
    unless ($user_input == $random_number) {
        say "Sadly, you lose. A new random number shall be generated and you shall try again.";
        next;
    }

    say "Congratulations! You win! The random number was $random_number";
    last;
};


