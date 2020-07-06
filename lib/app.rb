#!/usr/bin/ruby
require_relative "./classes/bst.rb"

def get_file_location
  puts "Enter file location: (Relative)"
  file_location = STDIN.gets.chomp
  file_location
end

def read_from_file(file_location)
  begin
    input_file = File.new(file_location, "r")
    input_string = ""
    input_file.each_byte { |ch| input_string << ch }
  rescue => e
    puts e.to_s
    return ""
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
  file_location = get_file_location()
  return [] if file_location == ""
  input_string = read_from_file(file_location)
  return [] if input_string == ""
  input_array = convert_string_to_int_array(input_string)
  input_array
end

def initialization()
  puts "Welcome to Binary Search Tree Utility \n\n"
  bst = BinarySearchTree.new()
  puts "Do you want to initialize by importing values from a file ? \n" \
       "Example: './output/output.txt' (Leave blank to not import)"
  input_array = file_to_int_array
  input_array.each { |value| bst.insert_node(value) }
  puts "\n Initialization Complete! \n"
  puts "Initial state of tree is: (Preorder)"
  p bst.preorder_traversal()
  puts "\n\n"
end

def take_single_input()
end

def take_multiple_inputs()
end

# def add_operation(map, id, message, output_message, error_message)
#   child_operations = {}
#   map[id] = [message, output_message, error_message, child_operations]
# end

# def create_operations_tree(operations)
# end

def display_operations(curr_node)
  puts "Choose an input option: (Eg: 1) \n"

  curr_node['childs'].each{ | options|
    puts "#{options.id}. #{option['messages']['MSG']}"
  }
end

def quit_operation()
end

operations = {
  "id" => "",
  "childs"=>{
    "PRINT" => {
      "id" => 1,
      "messsages" => {
        "ERROR" => "",
        "MSG" => "",
        "OUTPUT" => "",
      },
      "perform" => nil,
      "CHILDS" => {
        "LARGEST" => {},
        "SMALLEST" => {},
        "TRAVERSAL" => {},
        "ROOT_TO_LEAF" => {},
      },
    },
    "MODIFY" => {
      "INSERT" => {},
      "REMOVE" => {},
    },
    "SEARCH" => {
      "SEARCH_BY_VALUE" => {},
    },
    "QUIT" => {},
    "ROOT" => {}
  },
  "perform" => "",
  "messages" => {
    "MSG" => "",
    "ERROR" => "",
    "OUTPUT" => ""
  }
}

# class Operation
#   attr_accessor :id, :childs[], :perform, :messages[]
#   def perform_operation()
#   end
  
#   def add_operation()
#   end

#   def display_options()
#   end
# end


def perform_operation(curr_node, input_option)
  option_selector = ''
  curr_node["childs"].each { |option|
    option_selector = option.perform if option.id == input_option
    break
  }

  case option_selector
  when "QUIT"
    puts "End state of BST(Inorder Traversal) saved in output.txt"
    begin
      output_file = File.new("output.txt", "w")
      output_file.puts(p bst.inorder_traversal)
    rescue
      puts "Error in writing file"
    ensure
      output_file.close if output_file
    end

    puts "Exiting..."
    break
  when "INSERT_MULTIPLE"
    puts "Enter comma seperated numbers to add to the tree:"
    new_input = STDIN.gets.chomp
    new_input = new_input.split(",")
    new_input.each { |str| abort "Invalid Input" unless str.to_i.to_s == str }
    new_input = new_input.map { |curr_value| curr_value.to_i }
    new_input.each { |curr_value|
      if curr_value
        bst.insert_node(curr_value)
      end
    }
  when "LARGEST"
    puts bst.find_largest_node().value
  when "SMALLEST"
    puts bst.find_smallest_node().value
  when "INORDER"
    p bst.inorder_traversal()
  when "PREORDER"
    p bst.preorder_traversal()
  when "POSTORDER"
    p bst.postorder_traversal()
  when "SEARCH"
    puts "Enter a value to find:"
    new_input = STDIN.gets.chomp
    new_input = new_input.split(",")
    if new_input[0].to_i
      puts "Search found at: #{bst.search_by_value(new_input[0].to_i)}"
    else
      puts "Invalid Input"
    end
  when "REMOVE"
    puts "Enter a value to remove:"
    new_input = STDIN.gets.chomp
    new_input = new_input.split(",")
    if new_input[0].to_i
      puts " Removed #{bst.remove_by_value(new_input[0].to_i)} element."
    else
      puts "Invalid Input"
    end
  when "ROOT_TO_LEAF"
    bst.print_root_to_leaf_paths()
  when "LEVELORDER"
    p bst.levelorder_traversal()
  else
    puts "Invalid Input"
  end
end

def main()
  initialization()

  create_operations_tree(operations)
	curr_node
  while input_option
    display_operations(curr_node)
    input_option = STDIN.gets.chomp
    puts "Input provided: #{input_option}"
    perform_operation(curr_node, input_option)
  end
end

main()

  # 1.Print
    # 1.Print largest element
    # 2.Print smallest element
    # 3.Print Traversal
      # 1.Print Inorder Traversal
      # 2.Print Preorder Traversal
      # 3.Print Postorder Traversal
      # 4.Print Level Order Traversal
    # 4.Print all Root to Leaf paths
  # 2.Modify
    # 1.Insert Operation
      # 1.Add single element
      # 2.Add multiple comma seperated elements
      # 3.Add elements from a file
    # 2.Remove Operation
      # Remove an element by value
  # 3.Search
      # Search an element by value
  # 4.Quit