require 'pry-byebug'

class Knight

  def knight_move(start, finish)
    # start_node = Node.new(start)
    # recursive_move(finish, [start_node], [start_node.data])
    # # path = start_node.level_order[0].path
    # path = start_node.level_order
    # path.map! { |node| node.path}
    # pretty_path(path)

    def mover(root, finish)
      
      holder = [root]
      completed_positions = []
      while true
        # binding.pry
        root_node = holder.shift
        locations = possible_positions(root_node.data)
        locations.select! { |loc| !completed_positions.include?(loc) && loc != nil }

        locations.each_with_index do |loc, index|
          # binding.pry
          new_loc_node = Node.new(loc)
          root_node.nodes[index] = new_loc_node
          new_loc_node.path = root_node.path + new_loc_node.path
          if loc == finish
            return new_loc_node
          else
            holder << new_loc_node
          end
        end
      end
    end
    
    start_node = Node.new(start)
    final_node = mover(start_node, finish)
    pretty_path(final_node.path)





    # create functon that gets a node and calculates all of the possible results that are within board
    # in array form

  end


  def pretty_path(path)
    display = "You made it in #{path.size - 1} moves! Here is your path\n"
    path.each { |loc| display += "#{loc}\n"}
    puts display
  end


  def recursive_move(finish, worked_moves, completed_positions = [])
    binding.pry
    return if worked_moves.empty?

    node = worked_moves.shift
    locations = possible_positions(node.data)
    locations.select! { |loc| !completed_positions.include?(loc) && loc != nil}


    locations.each_with_index do |location, index| 
      completed_positions << location
      new_node = Node.new(location)
      node.nodes << new_node
      node.path << location 

      if location == finish
        worked_moves = []
        return 
      else
        worked_moves << new_node # unless node.nodes[index].data == nil
      end
    end
    recursive_move(finish, worked_moves, completed_positions)
  end


  def possible_positions(start)
    possible_moves =[]
    permutations = [[2,1], [1,2], [-1,2], [-2,1], [2,-1], [-2,-1], [-1,-2], [1,-2], [2,-1]]

    def add_arrays_of_two(a, b)
      summed = []
      a.each_with_index { |value, index| summed[index] = value + b[index]}
      summed
    end

    def out_of_bounds(location)
      largest_space = 8
      lowest_space = 1

      location.each { |value| return true if value > largest_space || value < lowest_space }
      false
    end


    permutations.each do |permute|
      new_location = add_arrays_of_two(start, permute)
      out_of_bounds(new_location) ? possible_moves << nil : possible_moves << new_location
    end
    possible_moves
  end











  class Node
    attr_accessor :data, :nodes, :path
    def initialize(data = nil, nodes = [], path = [data])
      @data = data
      @nodes = nodes
      @path = path
    end

    def to_s
    
      def nodes_str
        string = ''
        @nodes.each { |node| string += node.to_s }
      end

      "Value: #{@data}, \nnodes: #{nodes_str}, \npath: #{path}"
    end

    def level_order
      holder = [self]
      ordered = []
      until holder.compact.empty?
        node = holder.shift
        next if node == nil
        node.nodes.each { |element| holder << element}
        ordered << node
      end
      ordered
    end

  end

  # def level_order
  #   holder = [@root]
  #   ordered = []
  #   until holder.compact.empty?
  #     node = holder.shift
  #     next if node == nil
  #     holder << node.left << node.right
  #     ordered << node
  #   end
  #   return ordered.map! { |node| node.data } unless block_given?
  #   ordered.each { |node| yield(node) }
  # end

end

knight = Knight.new
# p knight.possible_positions([7,3])
knight.knight_move([8,8], [1,1])
# knight.knight_move([4,2], [1,1])

# Value: [1, 1], 
# nodes: [], 
# path: [[4, 2], [7, 3], [5, 5], [3, 5], [1, 3], [7, 1], [1, 1]]