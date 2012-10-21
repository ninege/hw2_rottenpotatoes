class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.ratings
 
    if params[:sort_key]
      session[:sort_key] = params[:sort_key]
      
    elsif session[:sort_key]
      flag = true
      params[:sort_key] = session[:sort_key]
      
    end
    
    qstring =  Movie.order(params[:sort_key])  
  
    if params[:commit] == 'Refresh'
      session[:ratings] = params[:ratings]
      
    elsif session[:ratings] != params[:ratings]
      flag = true
      params[:ratings] = session[:ratings]
      
    end
    
    @ratings, @sort_key = session[:ratings], session[:sort_key]
    
    if (flag)
      redirect_to movies_path(:sort_key => @sort_key,:ratings => @ratings)
    else
      puts "ashwani" + (@ratings.nil? ? false : @ratings.has_key?('R')).to_s
      @movies = @ratings.nil? ? qstring.all : qstring.find_all_by_rating(params[:ratings].keys)
    end
    
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
