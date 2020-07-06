require_relative "./bst_node.rb"

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

  def preorder_traversal(node = @root)
    return [] unless node
    [node.value] +
      preorder_traversal(node.left_node) +
      preorder_traversal(node.right_node)
  end

  def inorder_traversal(node = @root)
    return [] unless node
    inorder_traversal(node.left_node) +
      [node.value] +
      inorder_traversal(node.right_node)
  end

  def postorder_traversal(node = @root)
    return [] unless node
    postorder_traversal(node.left_node) +
      postorder_traversal(node.right_node) +
      [node.value]
  end

  def find_largest_node(node = @root)
    return nil unless node
    return node unless node.right_node
    find_largest_node(node.right_node)
  end

  def find_smallest_node(node = @root)
    if node.left_node.nil?
      return node
    else
      find_smallest_node(node.left_node)
    end
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

  def print_root_to_leaf_paths(node = @root, curr_path = [])
    if node.left_node == nil &&
       node.right_node == nil
      curr_path.push(node.value)
      p curr_path
      curr_path.pop
      return
    end

    curr_path.push(node.value)

    print_root_to_leaf_paths(node.left_node, curr_path) if node.left_node

    print_root_to_leaf_paths(node.right_node, curr_path) if node.right_node

    curr_path.pop
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

  def remove_min(node)
    node = nil
  end

  def replace_value(min_node, node)
    node.value = min_node.value
  end
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
end
