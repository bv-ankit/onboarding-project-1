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

def convert_string_to_int_array(input_string)
  input_strs = input_string.split(",")
  input_strs.each { |str| abort "Invalid Input" unless str.to_i.to_s == str }
  input_array = input_strs.map { |str| str.to_i if str.to_i }
  input_array
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
  bst = BinarySearchTree.new
  puts "Do you want to initialize by importing values from a file ? \n" \
       "Example: './output/output.txt' (Leave blank to not import)"
  input_array = file_to_int_array
  count = 0
  input_array.each { |value|
    bst.insert_node(value)
    count += 1
  }
  puts "\n Initialization Complete! \n"
  puts "Added #{count} nodes."
  puts "\n\n"
  bst
end

def take_single_input
  puts "Enter a value:"
  new_input = STDIN.gets.chomp
  if new_input.to_i.to_s == new_input
    new_input
  else
    puts "Invalid Input!"
    new_input = take_single_input
  end
  new_input
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
  input
end

def display_operations(curr_node)
  puts "Choose an input option: (Eg: 1) \n"

  curr_node["childs"].each do |key, option|
    puts "#{option["id"]}. #{option["messages"]["MSG"]}"
  end
end

def quit_operation(bst)
  puts "Do you want to save the end state of the tree?"
  puts "Leave blank for NO or enter 'Y' or 'y' for YES."
  input = STDIN.gets.chomp
  if input == "y" || input == "Y"
    puts "End state of BST saved in ./output/output.txt"
    begin
      output_file = File.new("./output/output.txt", "wb")
      elements = bst.preorder_traversal
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

def perform_operation(curr_node, input_option)
  option_selector = ""
  curr_node["childs"].each { |option|
    option_selector = option.perform if option.id == input_option
    break
  }

  case option_selector
  when "INSERT_MULTIPLE"
    begin
      new_input = take_multiple_inputs
    rescue => e
      puts e
    ensure
      new_input.each { |curr_value| bst.insert_node(curr_value) if curr_value }
    end
  when "LARGEST"
    puts bst.find_largest_node.value
  when "SMALLEST"
    puts bst.find_smallest_node.value
  when "INORDER"
    p "Output: #{bst.inorder_traversal}"
  when "PREORDER"
    p "Output: #{bst.preorder_traversal}"
  when "POSTORDER"
    p "Output: #{bst.postorder_traversal}"
  when "SEARCH"
    puts "Enter a value to search:"
    new_input = take_single_input
    puts "Search found at: #{bst.search_by_value(new_input)}"
  when "REMOVE"
    puts "Enter a value to remove:"
    new_input = take_single_input
    puts " Removed #{bst.remove_by_value(new_input)} element."
  when "ROOT_TO_LEAF"
    bst.print_root_to_leaf_paths
  when "LEVELORDER"
    p "Output: #{bst.levelorder_traversal}"
  else
    puts "Invalid Input"
  end
  puts "\n\n"
end

operations = {
  "id" => "",
  "childs" => {
    "PRINT" => {
      "id" => 1,
      "messages" => {
        "ERROR" => "",
        "MSG" => "Print elements",
        "OUTPUT" => "",
      },
      "CHILDS" => {
        "LARGEST" => {},
        "SMALLEST" => {},
        "TRAVERSAL" => {},
        "ROOT_TO_LEAF" => {},
      },
    },
    "MODIFY" => {
      "id" => 2,
      "childs" => {
        "INSERT" => {},
        "REMOVE" => {},
      },
      "messages" => {
        "ERROR" => "",
        "MSG" => "Modify elements",
        "OUTPUT" => "",
      },
    },
    "SEARCH" => {
      "id" => 3,
      "childs" => {
        "SEARCH_BY_VALUE" => {},
      },
      "messages" => {
        "ERROR" => "",
        "MSG" => "Search elements",
        "OUTPUT" => "",
      },
    },
  },
  "messages" => {
    "MSG" => "",
    "ERROR" => "",
    "OUTPUT" => "",
  },
}

def main(operations)
  bst = initialization
  curr_node = operations
  input_option = 1
  while input_option
    display_operations(curr_node)
    input_option = STDIN.gets.chomp
    puts "Input provided: #{input_option}"
    if input_option == "quit"
      quit_operation(bst)
      break
    end
    perform_operation(curr_node, input_option)
  end
end

main(operations)

# 1.Print
#   1.Print largest element
#   2.Print smallest element
#   3.Print Traversal
#     1.Print Inorder Traversal
#     2.Print Preorder Traversal
#     3.Print Postorder Traversal
#     4.Print Level Order Traversal
#   4.Print all Root to Leaf paths
# 2.Modify
#   1.Insert Operation
#     1.Add single element
#     2.Add multiple comma seperated elements
#     3.Add elements from a file
#   2.Remove Operation
#     Remove an element by value
# 3.Search
#   Search an element by value
# 4.Quit

# def add_operation(map, id, message, output_message, error_message)
#   child_operations = {}
#   map[id] = [message, output_message, error_message, child_operations]
# end

# def create_operations_tree(operations)
# end

# class Operation
#   attr_accessor :id, :childs[], :perform, :messages[]
#   def perform_operation()
#   end

#   def add_operation()
#   end

#   def display_options()
#   end
# end
