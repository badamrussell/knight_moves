require "./treenode.rb"


class KnightPathFinder

  attr_accessor :move_tree
  attr_reader :starting_position

  def initialize(starting_position)
    @starting_position = starting_position

    @board = []
    8.times do |row|
      @board[row] = []
      8.times { @board[row] << "" }
    end

    build_move_tree()

  end

  def find_path(end_position)
    # start adding nodes based off of the new_positions elements
    visited_positions = [starting_position]
    visited_increment = 0

    num_children = new_move_positions(starting_position).length
    move_tree.add_node(@starting_position, num_children)

    until move_tree.bfs(end_position)
      current_position = visited_positions[visited_increment]
      new_positions = new_move_positions(current_position)

      new_positions.each do |new_position|
        next if visited_positions.include?(new_position)

        move_tree.add_node(new_position, new_positions.length)
        visited_positions << new_position
      end

      visited_increment += 1
    end

    final_node = move_tree.bfs(end_position)
    current_node = final_node
    path = []

    until current_node.nil?
      path.unshift(current_node)
      current_node = current_node.parent
    end

    return path
  end

  def build_move_tree
    self.move_tree = Tree.new(8)
  end

  def valid_position?(possible_position)
    return true if (0...8) === possible_position[0] && (0...8) === possible_position[1]
    false
  end

  def new_move_positions(pos)
    move_offsets = [[2, -1], [2, 1], [1, 2], [-1, 2], [-2, 1], [-2, -1], [-1, -2], [1, -2]]

    new_positions = []

    move_offsets.each do |(x_offset, y_offset)|
      possible_position = [pos[0] + x_offset, pos[1] + y_offset]
      new_positions << possible_position if valid_position?(possible_position)
    end

    new_positions
  end
end




kpf = KnightPathFinder.new([0, 0])

p kpf.find_path([2, 1]) # => [[0, 0], [2, 1]]
p kpf.find_path([3, 3]) # => [[0, 0], [2, 1], [3, 3]]