class Node
  attr_accessor :value, :left_node, :right_node

  def initialize(input_value, input_left_node: nil, input_right_node: nil)
    @value = input_value
    @left_node = input_left_node
    @right_node = input_right_node
  end
end
