require_relative './maze.rb'

#command line input of maze file location
maze_file = ARGV.first

#setup solution library, using the "turn leftmost" explore method as a baseline
all_possible_solutions = {}
maze_instance = Maze.new(maze_file)
maze_instance.find_exit
all_possible_solutions[maze_instance.steps] = maze_instance

#iterate through other possible solutions, derived randomly
1000.times do
    maze_iteration = Maze.new(maze_file)
    maze_iteration.explore_randomly
    all_possible_solutions[maze_iteration.steps] = maze_iteration
end

#find the shortest route by searching the keys for minimum value and return
shortest_route = all_possible_solutions.keys.min
puts "\n\nThe shortest route to the exit is: #{shortest_route}\n\n"
all_possible_solutions[shortest_route].print_maze
puts "\n\n"
