require 'date'

def read_csv(filepath:)
  # filepath: output csv file name and location 

  # Process file and transform into array of hashes
  result = []
  keys = []

  File.open(filepath, "r") do |file|
    file.each_line.with_index do |row, row_index|
      # Remove newline characters
      row = row.gsub(/\r\n/, '')

      if(row_index == 0)
        # Special case to grab the column names from the CSV
        keys = row.split(",")
      else
        # Create a hash to be dynamically populated with key/values
        row_hash = {}

        # Grab values from csv data
        row.split(',').map.with_index do |column, column_index|
          # Remove wrapping quotes
          row_hash[keys[column_index]] = column
        end

        # Append hash to result
        result.push(row_hash)
      end
    end
  end

  # Return final result
  result
end

def write_csv(records: [], filepath: "Output.csv")
  # records: array of hashes to write as csv
  # filepath: output csv file name and location 

  # Only attempt to write to file if we have records
  return if records.empty?

  # Get column headers, assuming all records contain all keys
  column_names = records[0].keys

  # Comma separate the values
  csv = records.map { |item| item.values.join(',') }

  # Open file in write mode and append contents
  File.open(filepath, 'w') do |file|
    file.print column_names.join(',')
    file.puts
    csv.each do |record|
      file.print record
      file.puts
    end
  end
end

def group_by(records: [], columns: "")
  # records: Array of Hashes, each hash representing a csv row
  # columns: Comma separated string of fields to group by
  #          e.g. Network,Product,Month
  result = {};

  records.each do |record|
    # Create unique key for this record based on grouping column values
    key = columns
      .split(',')
      .map { |column| record[column] }
      .join(",")

    # Create an array to track records in this group, if necessary
    result[key] = [] if result[key].nil?
    result[key].push(record)
  end

  # Return the groups only, not the grouping keys
  # Each group is an array of hashes that share the same key
  result.values
end

# ======================================
# CSV group by columns
# Example usage: 
#
# $ ruby aggregate.rb Loans.csv Network,Product,Month
#
# ======================================

arg_filepath = ARGV[0]
arg_groupby_columns = ARGV[1]

parsed_records = read_csv(filepath:arg_filepath)
  .map do |record|
    # Parse date and amount
    parsedDate = Date.strptime(record["Date"], "'%d-%b-%Y'")
    record["Month"] = parsedDate.strftime('%B')
    record["Amount"] = record["Amount"].to_f
    record
  end

grouped_records = group_by(records:parsed_records, columns:arg_groupby_columns)
  .map do |group|
    # Collapse each group as desired
    result = group.reduce do |memo, current|
      memo["Amount"] += current["Amount"]
      memo
    end

    # These keys only need to be set once
    result["Count"] = group.length
    result.delete("MSISDN")
    result.delete("Date")
    result
  end

write_csv(records: grouped_records)

