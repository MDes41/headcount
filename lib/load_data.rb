require 'pry'
require 'csv'

class LoadData

  def load_data(hash_of_file_paths)
    hash_of_file_paths.map do |file_category, files|
      [file_category, load_each_file(files)]
    end.to_h
  end

  def load_each_file(files)
    files.map do |type, filename|
      [type, load_csv_data(filename)]
    end.to_h
  end

  def load_csv_data(filename)
    csv = CSV.open(filename, headers: true, header_converters: :symbol)
    csv.to_a.map { |row| row.to_h }
  end

end
