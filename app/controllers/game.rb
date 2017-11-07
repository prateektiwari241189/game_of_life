class Game
	attr_accessor :world , :seeds
	def initialize(world = World.new, seeds=[])
		@world = world
		@seeds = seeds

		seeds.each do |seed|
			world.cell_grid[seed[0]][seed[1]].alive = true
 		end

	end

	def tick!
		next_round_live_cells = []
    	next_round_dead_cells = []
		@world.cells.each do |cell|
      	neighbour_count = self.world.live_neighbours_around_cell(cell).count
     	# Rule 1: 
      	# Any live cell with fewer than two live neighbours dies
      	if cell.alive? && neighbour_count < 2
        	next_round_dead_cells << cell
      	end
      	# Rule 2:
      	# Any live cell with two or three live neighbours lives on to the next generation
      	if cell.alive? && ([2, 3].include? neighbour_count)
        	next_round_live_cells << cell
      	end
      	# Rule 3:
      	# Any live cell with more than three live neighbours dies
      	if cell.alive? && neighbour_count > 3
        	next_round_dead_cells << cell
      	end
      	# Rule 4:
      	# Any dead cell with exactly three live neighbours becomes a live cell
      	if cell.dead? && neighbour_count == 3
        	next_round_live_cells << cell
      	end
      end
      next_round_live_cells.each do |cell|
        cell.revive!
      end
      next_round_dead_cells.each do |cell|
        cell.die!
      end
	end
end