# Basic file
# require_relative 'cell.rb'
class World
	attr_accessor :rows, :cols, :cell_grid, :cells
	def initialize(rows=3, cols=3)
		@rows = rows
		@cols = cols
		@cells = []
		@cell_grid = Array.new(rows) do |row|
			Array.new(cols) do |col|
				cell = Cell.new(col,row)
				cells << cell
				cell
			end
		end
	end

	def live_cells
    	cells.select { |cell| cell.alive }
  	end

  	def dead_cells
    	cells.select { |cell| cell.alive == false }
  	end

	def randomly_populate
    	cells.each do |cell|
      		cell.alive = [true, false].sample
    	end
  	end

	def live_neighbours_around_cell(cell)
		live_neighbours = []

		#It detects a neighbour to the north
		if cell.y > 0
      		candidate = self.cell_grid[cell.y - 1][cell.x]
      		live_neighbours << candidate if candidate.alive?
   		 end

   		 # Neighbour to the East
    	if cell.x < (cols - 1)
      		candidate = self.cell_grid[cell.y][cell.x + 1]
      		live_neighbours << candidate if candidate.alive?
    	end
   		 # Neighbour to the South
    	if cell.y < (rows - 1)
      		candidate = self.cell_grid[cell.y + 1][cell.x]
      		live_neighbours << candidate if candidate.alive?
    	end
    	# Neighbours to the West
    	if cell.x > 0
      		candidate = self.cell_grid[cell.y][cell.x - 1]
      		live_neighbours << candidate if candidate.alive?
    	end

    	# Neighbour to the North-East
	    if cell.y > 0 and cell.x < (cols - 1)
	      candidate = self.cell_grid[cell.y - 1][cell.x + 1]
	      live_neighbours << candidate if candidate.alive?
	    end
	    # Neighbour to the South-East
	    if cell.y < (rows - 1) and cell.x < (cols - 1)
	      candidate = self.cell_grid[cell.y + 1][cell.x + 1]
	      live_neighbours << candidate if candidate.alive?
	    end
	    # Neighbours to the South-West
	    if cell.y < (rows - 1) and cell.x > 0
	      candidate = self.cell_grid[cell.y + 1][cell.x - 1]
	      live_neighbours << candidate if candidate.alive?
	    end
	    # Neighbours to the North-West
	    if cell.y > 0 and cell.x > 0
	      candidate = self.cell_grid[cell.y - 1][cell.x - 1]
	      live_neighbours << candidate if candidate.alive?
	    end



		live_neighbours
	end
end
