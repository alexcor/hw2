class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
	sort = params[:sort] || session[:sort]
    case sort
    	when 'title'
      		ordering, @title_header = {:order => :title}, 'hilite'
    	when 'release_date'
      		ordering, @release_date_header = {:order => :release_date}, 'hilite'
      	else
      		ordering, @no_header = {:order => nil}, ''
    end   

   	@all_ratings = Movie.all_ratings
    @my_ratings = params[:ratings] || session[:ratings] || {"G"=>1,"PG"=>1,"PG-13"=>1,"R"=>1}
    
    if params[:sort] != session[:sort]
      session[:sort] = sort
      redirect_to :sort => sort, :ratings => @my_ratings and return
    end

    if params[:ratings] != session[:ratings] and @my_ratings != {}
      session[:sort] = sort
      session[:ratings] = @my_ratings
      redirect_to :sort => sort, :ratings => @my_ratings and return
    end

	# @movies = Movie.all(ordering)
	@movies = Movie.find_all_by_rating(@my_ratings.keys, ordering)
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
