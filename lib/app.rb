#!/usr/bin/ruby
require_relative "./classes/bst.rb"

# Start
puts "Welcome to Binary Search Tree Utility"
if ARGV.size < 1
  abort "Please provide input file relative address with comma seperated values: \ 
    (Example: './input.txt')"
end

begin
  input_file = File.new(ARGV[0], "r")
  raise "Unable to open file!" if !input_file
  input_string = ""
  input_file.each_byte { |ch| input_string << ch }
rescue => e
  abort e.to_s
ensure
  input_file.close if input_file
end

input_strs = input_string.split(",")
input_strs.each { |str| abort "Invalid Input" unless str.to_i.to_s == str }
input_numbers = input_strs.map { |str| str.to_i if str.to_i }
bst = BinarySearchTree.new()
input_numbers.each { |value| bst.insert_node(value) }

while true
  puts "Choose an input option: (Eg: 1) \n
       1. Add multiple comma seperated elements \n
       2. Print largest element \n
       3. Print smallest element \n
       4. Print Inorder Traversal \n
       5. Print Preorder Traversal \n
       6. Print Postorder Traversal \n
       7. Search an element by value (First occurance) \n
       8. Remove an element by value (First occurance) \n
       9. Print all Root to Leaf paths \n
       10. Print Level Order Traversal \n
       Enter 'quit' To exit"

  input_option = STDIN.gets.chomp
  puts "Input provided: #{input_option}"
  puts "Output:"
  case input_option
  when "quit"
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
  when "1"
    puts "Enter comma seperated numbers to add to the tree:"
    new_input = STDIN.gets.chomp
    new_input = new_input.split(",")
    new_input.each { |str| abort "Invalid Input" unless str.to_i.to_s == str }
    new_input = new_input.map { |curr_value| curr_value.to_i }
    new_input.each {
      |curr_value|
      if curr_value
        bst.insert_node(curr_value)
      end
    }
  when "2"
    puts bst.find_largest_node().value
  when "3"
    puts bst.find_smallest_node().value
  when "4"
    p bst.inorder_traversal()
  when "5"
    p bst.preorder_traversal()
  when "6"
    p bst.postorder_traversal()
  when "7"
    puts "Enter a value to find:"
    new_input = STDIN.gets.chomp
    new_input = new_input.split(",")
    if new_input[0].to_i
      puts "Search found at: #{bst.search_by_value(new_input[0].to_i)}"
    else
      puts "Invalid Input"
    end
  when "8"
    puts "Enter a value to remove:"
    new_input = STDIN.gets.chomp
    new_input = new_input.split(",")
    if new_input[0].to_i
      puts " Removed #{bst.remove_by_value(new_input[0].to_i)} element."
    else
      puts "Invalid Input"
    end
  when "9"
    bst.print_root_to_leaf_paths()
  when "10"
    p bst.levelorder_traversal()
  else
    puts "Invalid Input"
  end
  puts "\n\n\n"
end
