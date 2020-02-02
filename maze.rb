require 'byebug'

class Maze

    attr_reader :maze_array

    def initialize(maze_file)
        #open maze file
        @maze = File.read(maze_file)
        restart_maze
    end

    def restart_maze
        #convert to array
        @maze_array = @maze.split("\n").map {|string| string.split("")}

        #determine starting position
        find_position

        #sets current position to starting location
        @current_position = @starting_position
        @previous_position = @starting_position
        set_current_position
    end

    def find_position
        #finds current position by iterating through the maze array
        @starting_position ||= [0, 0]
        @steps_taken = 0
        @maze_array.each_with_index do |row, row_num|
            row.each_with_index do |space, col_num|
                @starting_position = [row_num, col_num] if space == "S"
                @steps_taken += 1 if space == "X"
            end
        end
    end

    def steps
        find_position
        return @steps_taken
    end

    def find_exit
        #explores until exit is found
        while true
            explore
            break if near_exit?
        end
    end

    def compass
        #determines the direction you are moving in
        return nil unless @previous_position
        return nil if @previous_position == @current_position
        return "North" if @previous_position == [@y+1, @x]
        return "South" if @previous_position == [@y-1, @x]
        return "West" if @previous_position == [@y, @x+1]
        return "East" if @previous_position == [@y, @x-1]
    end

    def set_current_position
        #sets global @x & @y variables to the current position
        @x = @current_position[1]
        @y = @current_position[0]
    end

    def mark_current_position(coordinates)
        @previous_position = @current_position
        @current_position = [coordinates[0], coordinates[1]]
        set_current_position
        @maze_array[@y][@x] = "X"
    end

    def print_maze
        #print current maze array
        @maze_array.each {|row| puts row.join("")}
    end

    def near_exit?
        return true if @maze_array[@y+1][@x] == "E"
        return true if @maze_array[@y-1][@x] == "E"
        return true if @maze_array[@y][@x+1] == "E"
        return true if @maze_array[@y][@x-1] == "E"
        return false
        byebug
    end
    

    #checks if you are stuck
    def stuck?
        north = (@maze_array[@y-1][@x] == " ")
        south = (@maze_array[@y+1][@x] == " ")
        east = (@maze_array[@y][@x+1] == " ")
        west = (@maze_array[@y][@x-1] == " ")

        return false if near_exit?
        return true unless north || south || east || west
        false

    end


    #methods for exploring the cardinal directions
    def explore_north
        if @maze_array[@y-1][@x] == " " && !near_exit?
            mark_current_position([@y-1, @x])
        end
    end

    def explore_south
        if @maze_array[@y+1][@x] == " " && !near_exit?
            mark_current_position([@y+1, @x])
        end
    end

    def explore_west
        if @maze_array[@y][@x-1] == " " && !near_exit?
            mark_current_position([@y, @x-1])
        end
    end

    def explore_east
        if @maze_array[@y][@x+1] == " " && !near_exit?
            mark_current_position([@y, @x+1])
        end
    end


    #method for optimal exploration of a maze by turning to the leftmost open route
    def explore
        direction = compass
        temp_position = @current_position
        if direction == nil
            explore_north
        elsif direction == "North"
            explore_west
            explore_north if temp_position == @current_position
            explore_east if temp_position == @current_position
            explore_south if temp_position == @current_position
        elsif direction == "West"
            explore_south
            explore_west if temp_position == @current_position
            explore_north if temp_position == @current_position
            explore_east if temp_position == @current_position
        elsif direction == "South"
            explore_east
            explore_south if temp_position == @current_position
            explore_west if temp_position == @current_position
            explore_north if temp_position == @current_position
        elsif direction == "East"
            explore_north
            explore_east if temp_position == @current_position
            explore_south if temp_position == @current_position
            explore_west if temp_position == @current_position
        end
    end

    def explore_randomly
        until near_exit?
            direction = ["North","South","East","West"].sample
            distance = (0..20).to_a.sample

            if direction == "North"
                distance.times {explore_north}
            elsif direction == "East"
                distance.times {explore_east}
            elsif direction == "South"
                distance.times {explore_south}
            elsif direction == "West"
                distance.times {explore_west}
            end

            #restarts if stuck
            restart_maze if stuck?

        end
    end
    
end