# Distribution test

This code empirically tests an algorithm I wrote to solve the following
problem:

    Write a linear-time algorith which generates n random values x_1, x_2, ...
    x_n in [0, 1] with the same distribution that would have arisen if we'd
    generated each value independently and uniformly in [0, 1] and then sorted
    them into x_1 ≤ x_2 ≤ ... ≤ x_n.

This is my paraphrasing of problem 29 from section 3.4.1 of The Art of Computer
Programming, vol 2, 3rd edition, by Donald Knuth.

Run the code like so:

    lua distn_test.lua
