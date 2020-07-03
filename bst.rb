#!/usr/bin/ruby

class Node
  attr_accessor :value, :left_node, :right_node

  def initialize(input_value, input_left_node: nil, input_right_node: nil)
    @value = input_value
    @left_node = input_left_node
    @right_node = input_right_node
  end
end

class BinarySearchTree
  def initialize
    @root = Node.new(nil)
  end

  def insert_node(value)
    if @root.value
      insert_node_rec(@root, value)
    else
      @root = Node.new(value)
    end
  end

  def preorder_traversal
    preorder_rec(@root)
  end

  def inorder_traversal
    inorder_rec(@root)
  end

  def postorder_traversal
    postorder_rec(@root)
  end

  def find_largest_node
    find_largest_node_rec(@root)
  end

  def find_smallest_node
    min(@root)
  end

  def levelorder_traversal
    queue = []
    traversal = []
    queue.unshift(@root)
    while queue.size > 0
      curr_element = queue.pop
      traversal.unshift(curr_element.value)
      queue.unshift(curr_element.left_node) if curr_element.left_node
      queue.unshift(curr_element.right_node) if curr_element.right_node
    end
    traversal
  end

  def search_by_value(value, node = @root)
    return nil if node.nil?

    if value == node.value
      return node
    elsif value > node.value
      search_by_value(value, node.right_node)
    elsif value < node.value
      search_by_value(value, node.left_node)
    end
  end

  def remove_by_value(required_value)
    node = search_by_value(required_value, @root)
    remove_by_value_util(node) if !node.nil?
    nil
  end

  def print_root_to_leaf_paths
    curr_path = []
    root_to_leaf_rec(@root, curr_path)
  end

  private

  def remove_by_value_util(node)
    if node.left_node.nil? && node.right_node.nil?
      node = nil
    elsif !node.left_node.nil? && node.right_node.nil?
      node.value = node.left_node.value
      node.left_node = node.left_node.left_node
      node.right_node = node.left_node.right_node
    elsif node.left_node.nil? && !node.right_node.nil?
      node.value = node.right_node.value
      node.left_node = node.right_node.left_node
      node.right_node = node.right_node.right_node
    else
      min_node = min(node.right_node)
      replace_value(min_node, node)
      remove_min(min_node)
    end

    node
  end

  def find_largest_node_rec(node)
    return nil unless node
    return node unless node.right_node
    find_largest_node_rec(node.right_node)
  end

  def min(node)
    if node.left_node.nil?
      return node
    else
      min(node.left_node)
    end
  end

  def remove_min(node)
    node = nil
  end

  def replace_value(min_node, node)
    node.value = min_node.value
  end

  def root_to_leaf_rec(node, curr_path)
    if node.left_node == nil &&
       node.right_node == nil
      curr_path.push(node.value)
      p curr_path
      curr_path.pop
      return
    end

    curr_path.push(node.value)

    root_to_leaf_rec(node.left_node, curr_path) if node.left_node

    root_to_leaf_rec(node.right_node, curr_path) if node.right_node

    curr_path.pop
  end

  def insert_node_rec(node, value)
    return Node.new(value) unless node

    if value > node.value
      if node.right_node
        insert_node_rec(node.right_node, value)
      else
        node.right_node = Node.new(value)
      end
    elsif node.left_node
      insert_node_rec(node.left_node, value)
    else
      node.left_node = Node.new(value)
    end

    node
  end

  def inorder_rec(node)
    return [] unless node
    inorder_rec(node.left_node) +
      [node.value] +
      inorder_rec(node.right_node)
  end

  def preorder_rec(node)
    return [] unless node
    [node.value] +
      preorder_rec(node.left_node) +
      preorder_rec(node.right_node)
  end

  def postorder_rec(node)
    return [] unless node
    postorder_rec(node.left_node) +
      postorder_rec(node.right_node) +
      [node.value]
  end
end

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
rescue => exception
  abort exception.to_s
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
