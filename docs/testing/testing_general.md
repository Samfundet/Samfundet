# Testing in general

The testing framework we're using for samfundet.no is [RSpec](http://rspec.info). A general introduction can be found [here](https://www.rubyguides.com/2018/07/rspec-tutorial/), but take a look at the `spec` folder for more examples on how to test with `RSpec`.

## Running tests

First, a little introduction on how to run your tests. To run all tests, run

```bash
rspec
```

from the root of the project. If you only want to test a single file, you need to specify the path of the file to be tested, like so:

```bash
rspec spec/models/mymodel_spec.rb
```

## Code coverage

A very useful file to check out is `coverage/index.html`, which will list the coverage for all files in the project. Monitor your coverage with this fill. Remember that 100% coverage is not a goal, but generally try to test most of the code, so around 75% is a good goal. Try to trigger edge cases in your tests.