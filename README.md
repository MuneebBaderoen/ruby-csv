## CSV group by columns

Written and tested using: Ruby 2.3.1

### Example usage: 
```
$ ruby aggregate.rb Loans.csv Network,Product,Month
```

3 functions are provided with the usage of those 3 functions towards the bottom of the script to achieve the desired result. 

- read_csv
- write_csv
- group_by

### Design Choices:
- Language: Ruby
	- Avoiding languages that require compilation
  - Alternatives for me were nodejs and python. Nodejs is more than capable, but does not include the power of the builtins and standard libraries of python and ruby.
  - Right now, Im just more familiar with Ruby than Python, special place in my heart for them both.
  - No plugins, no libraries
 - No classes? preposterous.
 	- I am a firm believer that making classes when only functions are required makes code harder to reason about. The constructs of Object-Orientation are useful for expressing modularity, but increase mental processing required to understand the interaction and dependencies between classes and instances thereof. Its about weighing up those alternatives and streamlining for understanding.
 	- Stateful objects also force particular order of execution and reproducing a state requires the same sequence of actions. Pure functions have the benefit of reliably returning the same result for the same parameters.
 - Performance and Scaling
 	- Loading all file contents into memory is smoother but falls apart for larger datasets (larger than available memory). Some chunking or equivalent to map reduce would suit this problem well. This implementation is small scale map-reduce.
 	- Using pure functions also simplifies concurrent implementations. Without shared state, no semaphores or locking mechanisms are required.

### Assumptions:
- Any csv file to be analyzed is a valid csv file
- The number of fields in each row match the number of column headers
- Date is the only date field
- Amount is the only numeric field
- The output csv does not need to be sorted in any way
- Command line arguments only allow for custom filepath and colmun names to group by. 
	- Any additional parsing is not catered for (apart from parsing dates and amounts)
	- Any additional logic to reduce a group of records to a single output record is not catered for (apart from summing amounts)





