#!/usr/bin/ruby
require_relative "./classes/bst.rb"

def get_file_location
  puts "Enter file location: (Relative)"
  file_location = STDIN.gets.chomp
  file_location
end

def read_from_file(file_location)
  input_string = ""
  begin
    input_file = File.new(file_location, "rb")
    input_file.each_byte { |ch| input_string << ch }
  rescue => e
    puts "ERROR: READ_FROM_FILE: #{e.to_s}"
  ensure
    input_file.close if input_file
  end
  input_string
end

def convert_string_to_int_array(string)
  string = string.split(",")
  string.each { |str| abort "Invalid Input" unless str.to_i.to_s == str }
  array = string.map { |str| str.to_i if str.to_i }
  array
end

def file_to_int_array
  file_location = get_file_location
  return [] if file_location == ""
  input_string = read_from_file(file_location)
  return [] if input_string == ""
  input_array = convert_string_to_int_array(input_string)
  input_array
end

def initialization
  puts "Welcome to Binary Search Tree Utility \n\n"
  @bst = BinarySearchTree.new
  puts "Do you want to initialize by importing values from a file ? \n" \
       "Example: './output/output.txt' (Leave blank to not import)"
  input_array = file_to_int_array
  count = 0
  input_array.each { |value|
    @bst.insert_node(value)
    count += 1
  }
  puts "\nInitialization Complete! \n"
  puts "Added #{count} nodes."
  puts "\n\n"
  @bst
end

def take_single_input
  puts "Enter a value:"
  new_input = STDIN.gets.chomp
  if new_input.to_i.to_s == new_input
    new_input
  else
    raise "ERROR: Invalid Input!"
  end
  new_input.to_i
end

def take_multiple_inputs
  puts "Enter comma seperated numbers:"
  input = STDIN.gets.chomp
  input = input.split(",")
  is_valid_input = true
  input.each { |str|
    unless str.to_i.to_s == str
      is_valid_input = false
      break
    end
  }
  raise "ERROR: Invalid Input" unless is_valid_input
  input.map { |value| value.to_i }
  input
end

def display_categories
  puts "Select a category of opearion: (Eg: 1) \n"
  OPERATIONS.each { |key, option| puts "#{key}. #{option[:msg]}" }
  puts "\nEnter 'quit' to exit.\n"
end

def display_operations(category)
  puts "Select an operation to perform: (Eg: 1) \n"
  OPERATIONS[category].each { |key, value|
    puts "#{key}. #{value}" unless key == :msg
  } if OPERATIONS[category]
  puts "\nEnter 'home' to go back to main menu."
  puts "Enter 'quit' to exit.\n"
end

def quit_operation
  puts "Do you want to save the end state of the tree?"
  puts "Leave blank for NO or enter 'Y' or 'y' for YES."
  input = STDIN.gets.chomp
  if input == "y" || input == "Y"
    puts "End state of BST saved in ./output/output.txt"
    begin
      output_file = File.new("./output/output.txt", "wb")
      elements = @bst.preorder_traversal
      output_string = ""
      elements.each { |element|
        output_string << element.to_s
        output_string << ","
      }
      output_string = output_string.delete_suffix(",")
      output_string.each_char { |char| output_file << char }
    rescue => e
      puts "ERROR: WRITE_TO_FILE: #{e.to_s}"
    ensure
      output_file.close if output_file
    end
  end
  puts "Exiting..."
end

def handle_print_operation(operation)
  case operation
  when Operation::LARGEST_ELEMENT
    puts "Output: #{@bst.find_largest_node.value}"
  when Operation::SMALLEST_ELEMENT
    puts "Output: #{@bst.find_smallest_node.value}"
  when Operation::INORDER
    puts "Output: #{@bst.inorder_traversal}"
  when Operation::PREORDER
    puts "Output: #{@bst.preorder_traversal}"
  when Operation::POSTORDER
    puts "Output: #{@bst.postorder_traversal}"
  when Operation::ROOT_TO_LEAF
    puts "Output:"
    @bst.print_root_to_leaf_paths
  when Operation::LEVELORDER
    puts "Output: #{@bst.levelorder_traversal}"
  else
    puts "Invalid operation"
  end
end

def handle_modify_operation(operation)
  case operation
  when Operation::INSERT_SINGLE
    begin
      user_input = take_single_input
      puts "Node inserted #{@bst.insert_node(user_input)}"
    rescue => e
      puts e
    ensure
    end
  when Operation::INSERT_FROM_FILE
    input_array = file_to_int_array
    count = 0
    input_array.each { |value|
      @bst.insert_node(value)
      count += 1
    }
    puts "#{count} values inserted."
  when Operation::INSERT_MULTIPLE
    begin
      input = take_multiple_inputs
    rescue => e
      puts e
    end
    count = 0
    input.each { |curr_value| 
      @bst.insert_node(curr_value.to_i) if curr_value 
      count += 1
    }
    puts "#{count} values inserted."
  when Operation::REMOVE_ELEMENT
    puts "Enter a value to remove:"
    input = take_single_input
    puts " Removed #{@bst.remove_by_value(input)} element."
  else
    puts "Invalid Operation"
  end
end

def handle_search_operation(operation)
  if operation == Operation::SEARCH_ELEMENT
    puts "Enter a value to search:"
    input = take_single_input
    puts "Search found at: #{@bst.search_by_value(input)}"
  end
end

def perform_operation(operation, category)
  case category
  when OperationCategory::PRINT
    handle_print_operation(operation)
  when OperationCategory::MODIFY
    handle_modify_operation(operation)
  when OperationCategory::SEARCH
    handle_search_operation(operation)
  else
    puts "Invalid Operation"
  end
  puts "\n\n"
end

# Sample Operations Hash
# OPERATIONS = {
#   :msg => "",
#   1 => {
#     1 => {"msg" => ""},
#     2 => {"msg" => ""}
#   }
#   2 = > {}
# }
OPERATIONS = {}

def add_category(type, msg)
  OPERATIONS[type] = { :msg => msg }
  type
end

def add_operation(type, msg, category)
  OPERATIONS[category][type] = msg
  type
end

module Commands
  QUIT = "quit"
  HOME = "home"
end

module OperationCategory
  PRINT = add_category(1, "Print")
  MODIFY = add_category(2, "Modify")
  SEARCH = add_category(3, "Search")
end

module Operation
  SMALLEST_ELEMENT = add_operation(1, "Smallest Element", OperationCategory::PRINT)
  LARGEST_ELEMENT = add_operation(2, "Largest Element", OperationCategory::PRINT)
  PREORDER = add_operation(3, "Preorder Traversal", OperationCategory::PRINT)
  INORDER = add_operation(4, "Inorder Traversal", OperationCategory::PRINT)
  POSTORDER = add_operation(5, "Postorder Traversal", OperationCategory::PRINT)
  LEVELORDER = add_operation(6, "Levelorder Traversal", OperationCategory::PRINT)
  ROOT_TO_LEAF = add_operation(7, "Print all root to leaf paths", OperationCategory::PRINT)
  INSERT_SINGLE = add_operation(1, "Insert an element", OperationCategory::MODIFY)
  INSERT_MULTIPLE = add_operation(2, "Insert multiple comma seperated elements", OperationCategory::MODIFY)
  INSERT_FROM_FILE = add_operation(3, "Insert multiple from file", OperationCategory::MODIFY)
  REMOVE_ELEMENT = add_operation(4, "Remove an element", OperationCategory::MODIFY)
  SEARCH_ELEMENT = add_operation(1, "Search an element", OperationCategory::SEARCH)
end

def main()
  @bst = initialization

  input = ""
  category = nil

  while true
    category ? display_operations(category) : display_categories

    input = STDIN.gets.chomp

    if input == Commands::QUIT
      puts "Selected option: QUIT"
      quit_operation
      break
    end

    if category
      if input == Commands::HOME
        puts "Selected option: HOME"
        category = nil
      else
        operation = input.to_i
        if OPERATIONS[category].include?(operation)
          puts "Selected operation: #{OPERATIONS[category][operation]}"
          perform_operation(operation, category)
        else
          puts "Invalid operation"
        end
      end
    else
      input = input.to_i
      if OPERATIONS.include?(input)
        category = input
        puts "Selected Category: #{OPERATIONS[category][:msg]}"
      else
        puts "Invalid category"
      end
    end
    puts "\n"
  end
end

main()
